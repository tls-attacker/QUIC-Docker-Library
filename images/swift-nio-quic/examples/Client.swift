// QUIC client based on swift-nio-quic: 
// Opens one stream, sends a message and prints the response of the server.

import Foundation
import Logging
import NIOCore
import NIOPosix
import NIOQUIC

@main
struct Client {
    static let usage =
        "Usage: swift-quic-client --host IP --port PORT [--ca CA_CERTIFICATE] [--server-name NAME] [--no-verify] [--alpn PROTOCOLS] [--message TEXT]"

    static func main() async {
        var host: String?
        var port = 0
        var caCertificate: String?
        var serverName: String?
        var verify = true
        var applicationProtocols = ["h3"]
        var message = "Hello from swift-quic-client"

        var arguments = CommandLine.arguments.dropFirst()
        while let argument = arguments.popFirst() {
            switch argument {
            case "--no-verify":
                verify = false
            case "--host", "--port", "--ca", "--server-name", "--alpn", "--message":
                guard let value = arguments.popFirst() else { fail("Missing value for \(argument)") }
                switch argument {
                case "--host": host = value
                case "--port": port = Int(value) ?? 0
                case "--ca": caCertificate = value
                case "--server-name": serverName = value
                case "--alpn": applicationProtocols = value.split(separator: ",").map(String.init)
                default: message = value
                }
            default:
                fail("Unknown argument \(argument)")
            }
        }
        guard let host, port > 0 else { fail("Missing or invalid argument") }

        let logger = Logger(label: "swift-quic-client")
        // Without a CA certificate the default trust store of the system is used
        var configuration = QUICConfiguration.forClient(
            verificationConfiguration: .x509Certificates(trustRootsFilePath: caCertificate),
            applicationProtocols: applicationProtocols
        )
        if !verify {
            configuration.peerCertificateVerification = .noVerification
        }

        do {
            try await run(host: host, port: port, serverName: serverName ?? host, message: message, configuration: configuration, logger: logger)
        } catch {
            logger.error("Connection failed: \(error)")
            exit(1)
        }
    }

    static func run(
        host: String,
        port: Int,
        serverName: String,
        message: String,
        configuration quicConfiguration: QUICConfiguration,
        logger: Logger
    ) async throws {
        let remoteAddress = try SocketAddress.makeAddressResolvingHost(host, port: port)
        let localHost = remoteAddress.protocol == .inet6 ? "::" : "0.0.0.0"
        let (channel, multiplexer) = try await DatagramBootstrap(group: .singletonMultiThreadedEventLoopGroup)
            .bind(host: localHost, port: 0) {
                channel -> EventLoopFuture<(any Channel, QUICHandler<QUICStreamChannels>.ConnectionMultiplexer<Void>)> in
                channel.eventLoop.makeCompletedFuture {
                    let (quicHandler, multiplexer) = try QUICHandler.makeHandlerAndConnectionMultiplexer(
                        channel: channel,
                        quicConfiguration: quicConfiguration,
                        logger: logger,
                        inboundStreamChannelInitializer: { $0.eventLoop.makeSucceededVoidFuture() }
                    )
                    try channel.pipeline.syncOperations.addHandler(quicHandler)
                    return (channel, multiplexer)
                }
            }

        let connection = try await multiplexer.createNewConnection(
            serverName: serverName,
            remoteAddress: remoteAddress
        ) { $0.eventLoop.makeSucceededVoidFuture() }
        logger.info("Connected to \(remoteAddress)")

        let stream = try await connection.createBidirectionalStream { streamInitializer in
            streamInitializer.channel.eventLoop.makeCompletedFuture {
                try NIOAsyncChannel<ByteBuffer, ByteBuffer>(
                    wrappingChannelSynchronously: streamInitializer.channel,
                    configuration: .init(isOutboundHalfClosureEnabled: true)
                )
            }
        }
        try await stream.executeThenClose { inbound, outbound in
            try await outbound.write(ByteBuffer(string: message))
            outbound.finish()
            logger.info("Sent: \(message)")
            for try await buffer in inbound {
                logger.info("Received: \(String(buffer: buffer))")
            }
        }
        try await channel.close()
    }

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("\(message)\n\(usage)\n".utf8))
        exit(1)
    }
}
