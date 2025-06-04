// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AnyCryptoSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "AnyCryptoSwift",
            targets: ["AnyCryptoSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "AnyCryptoSwift",
            dependencies: [
                "BigInt",
                .product(name: "Crypto", package: "swift-crypto")
            ]),
        .testTarget(
            name: "AnyCryptoSwiftTests",
            dependencies: ["AnyCryptoSwift"]),
    ]
)