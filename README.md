# AnyCryptoSwift

A Swift package that implements Ed25519 signature verification and account address encoding/decoding compatible with Anytype's crypto format.

## Features

- Ed25519 public key signature verification
- Account address encoding/decoding with Base58
- CRC16 checksum validation
- Compatible with Anytype's account address format (addresses starting with 'A')

## Installation

Add this package to your Swift project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "path/to/any-crypto-swift", from: "1.0.0")
]
```

## Usage

### Decoding an Account Address

```swift
import AnyCryptoSwift

do {
    let accountAddress = "A..." // Your account address starting with 'A'
    let pubKey = try AnyCryptoSwift.decodeAccountAddress(accountAddress)
    
    // Verify a signature
    let message = "Hello, World!".data(using: .utf8)!
    let signature = Data(...) // 64-byte signature
    let isValid = try pubKey.verify(data: message, signature: signature)
    
    // Get account address representation
    let address = pubKey.account()
} catch {
    print("Error: \(error)")
}
```

### Working with Ed25519 Public Keys

```swift
import AnyCryptoSwift

// Create from 32-byte public key data
let pubKeyData = Data(...) // 32 bytes
let pubKey = try Ed25519PubKey(data: pubKeyData)

// Verify signatures
let isValid = try pubKey.verify(data: messageData, signature: signatureData)

// Get account address
let accountAddress = pubKey.account() // Returns address starting with 'A'
```

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.9+

## Dependencies

- [swift-crypto](https://github.com/apple/swift-crypto) - For Ed25519 cryptographic operations
- [BigInt](https://github.com/attaswift/BigInt) - For Base58 encoding/decoding

## License

This package is available under the MIT license.