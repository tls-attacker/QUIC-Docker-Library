// QUIC server based on swift-nio-quic: 
// The data of every bidirectional stream that a client opens is sent back on that stream.

import Foundation
import Logging
import NIOCore
import NIOPosix
import NIOQUIC
import NIOQUICHelpers

@main
struct Server {
    static let usage =
        "Usage: swift-quic-server --cert CERTIFICATE --key PRIVATE_KEY [--host IP] [--port PORT] [--alpn PROTOCOLS] [--retry]"

    static func main() async throws {
        var host = "0.0.0.0"
        var port = 4433
        var certificate: String?
        var privateKey: String?
        var applicationProtocols = ["h3"]
        var sendRetry = false

        var arguments = CommandLine.arguments.dropFirst()
        while let argument = arguments.popFirst() {
            switch argument {
            case "--retry":
                sendRetry = true
            case "--host", "--port", "--cert", "--key", "--alpn":
                guard let value = arguments.popFirst() else { fail("Missing value for \(argument)") }
                switch argument {
                case "--host": host = value
                case "--port": port = Int(value) ?? 0
                case "--cert": certificate = value
                case "--key": privateKey = value
                default: applicationProtocols = value.split(separator: ",").map(String.init)
                }
            default:
                fail("Unknown argument \(argument)")
            }
        }
        guard let certificate, let privateKey, port > 0 else { fail("Missing or invalid argument") }

        let logger = Logger(label: "swift-quic-server")
        var configuration = QUICConfiguration.forServer(
            serverName: "localhost",
            authenticationConfiguration: .x509Certificates(
                certificateChainFilePath: certificate,
                privateKeyFilePath: privateKey
            ),
            applicationProtocols: applicationProtocols
        )
        configuration.sendRetry = sendRetry
        let quicConfiguration = configuration

        let (channel, multiplexer) = try await DatagramBootstrap(group: .singletonMultiThreadedEventLoopGroup)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .bind(host: host, port: port) { channel in
                channel.eventLoop.makeCompletedFuture {
                    let (quicHandler, multiplexer) = try QUICHandler.makeHandlerAndConnectionMultiplexer(
                        channel: channel,
                        quicConfiguration: quicConfiguration,
                        logger: logger,
                        inboundStreamChannelInitializer: { streamChannel in
                            streamChannel.getOption(.quicStreamID).flatMapThrowing { streamID in
                                (
                                    isUnidirectional: streamID & 0x2 != 0,
                                    channel: try NIOAsyncChannel<ByteBuffer, ByteBuffer>(
                                        wrappingChannelSynchronously: streamChannel,
                                        configuration: .init(isOutboundHalfClosureEnabled: true)
                                    )
                                )
                            }
                        }
                    )
                    try channel.pipeline.syncOperations.addHandler(quicHandler)
                    return (channel, multiplexer)
                }
            }
        logger.info("Listening on \(channel.localAddress!) with ALPN \(applicationProtocols)")

        await withDiscardingTaskGroup { group in
            for await connection in multiplexer.inboundConnections {
                logger.info("New connection")
                group.addTask {
                    await withDiscardingTaskGroup { group in
                        for await stream in connection.inboundStreams {
                            group.addTask {
                                do {
                                    try await stream.channel.executeThenClose { inbound, outbound in
                                        if stream.isUnidirectional {
                                            for try await _ in inbound {}
                                        } else {
                                            try await outbound.write(contentsOf: inbound)
                                            outbound.finish()
                                        }
                                    }
                                } catch {
                                    logger.warning("Stream failed: \(error)")
                                }
                            }
                        }
                    }
                    logger.info("Connection closed")
                }
            }
        }
    }

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("\(message)\n\(usage)\n".utf8))
        exit(1)
    }
}
