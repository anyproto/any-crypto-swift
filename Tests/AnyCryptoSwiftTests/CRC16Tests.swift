import XCTest
@testable import AnyCryptoSwift

final class CRC16Tests: XCTestCase {
    func testChecksum() throws {
        let testData = "Hello, World!".data(using: .utf8)!
        let checksum = CRC16.checksum(testData)
        
        XCTAssertEqual(checksum.count, 2)
        
        try CRC16.validate(testData, checksum: checksum)
    }
    
    func testValidateWithInvalidChecksum() throws {
        let testData = "Hello, World!".data(using: .utf8)!
        let invalidChecksum = Data([0x00, 0x00])
        
        XCTAssertThrowsError(try CRC16.validate(testData, checksum: invalidChecksum)) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.checksumMismatch)
        }
    }
    
    func testValidateWithInvalidChecksumSize() throws {
        let testData = "Hello, World!".data(using: .utf8)!
        let invalidChecksum = Data([0x00])
        
        XCTAssertThrowsError(try CRC16.validate(testData, checksum: invalidChecksum)) { error in
            XCTAssertEqual(error as? CryptoError, CryptoError.invalidChecksum)
        }
    }
}