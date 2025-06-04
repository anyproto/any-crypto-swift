import XCTest
import Crypto
@testable import AnyCryptoSwift

final class AnyCryptoSwiftTests: XCTestCase {
    func testDecodeAccountAddress() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let account = try StrKey.encode(version: StrKey.accountAddressVersionByte, src: publicKey.rawRepresentation)
        
        let decodedPubKey = try AnyCryptoSwift.decodeAccountAddress(account)
        
        XCTAssertEqual(decodedPubKey.account(), account)
    }
    
    func testDecodeAccountAddressAndVerifySignature() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let account = try StrKey.encode(version: StrKey.accountAddressVersionByte, src: publicKey.rawRepresentation)
        
        let message = "Test message for signature".data(using: .utf8)!
        let signature = try privateKey.signature(for: message)
        
        let decodedPubKey = try AnyCryptoSwift.decodeAccountAddress(account)
        let isValid = try decodedPubKey.verify(data: message, signature: signature)
        
        XCTAssertTrue(isValid)
    }
    
    func testDecodeInvalidAccountAddress() throws {
        let invalidAccount = "InvalidAccountAddress"
        
        XCTAssertThrowsError(try AnyCryptoSwift.decodeAccountAddress(invalidAccount))
    }
    
    func testAccountAddressStartsWithA() throws {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        
        let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
        let account = pubKey.account()
        
        if !account.isEmpty {
            XCTAssertTrue(account.hasPrefix("A"), "Account address should start with 'A'")
        }
    }
}