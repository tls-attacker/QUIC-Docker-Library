// swift-tools-version: 6.3

import PackageDescription

// The version of swift-nio-quic is taken from the environment variable VERSION (the build argument of the Dockerfile)
let version = Version(Context.environment["VERSION"] ?? "0.6.0")!

let dependencies: [Target.Dependency] = [
    .product(name: "NIOCore", package: "swift-nio"),
    .product(name: "NIOPosix", package: "swift-nio"),
    .product(name: "Logging", package: "swift-log"),
    .product(name: "NIOQUIC", package: "swift-nio-quic"),
    .product(name: "NIOQUICHelpers", package: "swift-nio-quic-helpers"),
]

let package = Package(
    name: "examples",
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.104.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.12.1"),
        .package(url: "https://github.com/apple/swift-nio-quic.git", exact: version),
        .package(url: "https://github.com/apple/swift-nio-quic-helpers.git", from: "0.1.1"),
    ],
    targets: [
        .executableTarget(name: "swift-quic-server", dependencies: dependencies, path: ".", sources: ["Server.swift"]),
        .executableTarget(name: "swift-quic-client", dependencies: dependencies, path: ".", sources: ["Client.swift"]),
    ]
)
