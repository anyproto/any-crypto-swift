import XCTest
@testable import AnyCryptoSwift

final class Base58Tests: XCTestCase {
    func testEncodeDecode() throws {
        let testData = "Hello, World!".data(using: .utf8)!
        let encoded = Base58.encode(testData)
        let decoded = try Base58.decode(encoded)
        
        XCTAssertEqual(testData, decoded)
    }
    
    func testEncodeWithLeadingZeros() throws {
        let testData = Data([0x00, 0x00, 0x01, 0x02, 0x03])
        let encoded = Base58.encode(testData)
        let decoded = try Base58.decode(encoded)
        
        XCTAssertEqual(testData, decoded)
        XCTAssertTrue(encoded.hasPrefix("11"))
    }
    
    func testDecodeInvalidString() throws {
        let invalidString = "0OIl"
        
        XCTAssertThrowsError(try Base58.decode(invalidString)) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.invalidBase58String)
        }
    }
    
    func testDecodeEmptyString() throws {
        XCTAssertThrowsError(try Base58.decode("")) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.invalidBase58String)
        }
    }
}