import XCTest
import Crypto
@testable import AnyCryptoSwift

final class Ed25519PubKeyTests: XCTestCase {
    func testInitWithValidData() throws {
        let keyData = Data(repeating: 0x01, count: 32)
        _ = try Ed25519PubKey(data: keyData)
    }
    
    func testInitWithInvalidDataSize() throws {
        let keyData = Data(repeating: 0x01, count: 31)
        
        XCTAssertThrowsError(try Ed25519PubKey(data: keyData)) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.invalidPublicKeySize)
        }
    }
    
    func testVerifySignature() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let message = "Hello, World!".data(using: .utf8)!
        let signature = try privateKey.signature(for: message)
        
        let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
        let isValid = try pubKey.verify(data: message, signature: signature)
        
        XCTAssertTrue(isValid)
    }
    
    func testVerifyInvalidSignature() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let message = "Hello, World!".data(using: .utf8)!
        let invalidSignature = Data(repeating: 0x00, count: 64)
        
        let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
        let isValid = try pubKey.verify(data: message, signature: invalidSignature)
        
        XCTAssertFalse(isValid)
    }
    
    func testVerifyWithWrongSignatureSize() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let message = "Hello, World!".data(using: .utf8)!
        let invalidSignature = Data(repeating: 0x00, count: 63)
        
        let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
        
        XCTAssertThrowsError(try pubKey.verify(data: message, signature: invalidSignature)) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.invalidSignature)
        }
    }
    
    func testAccount() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
        let account = pubKey.account()
        
        if !account.isEmpty {
            XCTAssertTrue(account.hasPrefix("A"))
        }
    }
    
    func testUnmarshalEd25519PublicKey() throws {
        let keyData = Data(repeating: 0x01, count: 32)
        let pubKey = try unmarshalEd25519PublicKey(data: keyData)
        
        XCTAssertNotNil(pubKey)
    }
}