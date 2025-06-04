import XCTest
@testable import AnyCryptoSwift

final class GoldStandardTests: XCTestCase {
    /// Gold standard test using reference data from Go implementation
    func testGoCompatibility() throws {
        // Reference data from Go implementation
        let accountAddress = "AAsya5TCoq8WkoDKDXvmULraHg1EZPJogKiqnh3gMuHwCJPP"
        let publicKeyHex = "e7d0aa93cf727e99c7406fea1341629b7abae86450b18700ff1eac3f71996661"
        let message = "Test message 1"
        let messageHex = "54657374206d6573736167652031"
        let signatureHex = "0499290d20a66cd1e2b1e24a1fb912ee51d7b42767e65233af58522d770b6543af2c1aa28bf498d9c81d640ae5a4728132ba86c34d421381c789ac6c6d82550c"
        
        // Convert hex strings to Data
        let publicKeyData = Data(hexString: publicKeyHex)!
        let messageData = Data(hexString: messageHex)!
        let signatureData = Data(hexString: signatureHex)!
        
        // Verify message encoding
        XCTAssertEqual(message.data(using: .utf8)!, messageData, "Message encoding should match")
        
        // Test 1: Decode account address and verify it matches the public key
        let decodedPubKey = try AnyCryptoSwift.decodeAccountAddress(accountAddress)
        
        // Test 2: Create public key from raw data and verify it produces the same account address
        let pubKeyFromData = try Ed25519PubKey(data: publicKeyData)
        XCTAssertEqual(pubKeyFromData.account(), accountAddress, "Account address should match Go implementation")
        
        // Test 3: Verify the signature
        let isValid = try decodedPubKey.verify(data: messageData, signature: signatureData)
        XCTAssertTrue(isValid, "Signature should be valid according to Go implementation")
        
        // Test 4: Verify signature with public key created from raw data
        let isValidFromRaw = try pubKeyFromData.verify(data: messageData, signature: signatureData)
        XCTAssertTrue(isValidFromRaw, "Signature should be valid with public key from raw data")
    }
}

// Helper extension to convert hex strings to Data
extension Data {
    init?(hexString: String) {
        let hex = hexString.replacingOccurrences(of: " ", with: "")
        let len = hex.count / 2
        var data = Data(capacity: len)
        var index = hex.startIndex
        
        for _ in 0..<len {
            let nextIndex = hex.index(index, offsetBy: 2)
            guard let byte = UInt8(hex[index..<nextIndex], radix: 16) else {
                return nil
            }
            data.append(byte)
            index = nextIndex
        }
        
        self = data
    }
}