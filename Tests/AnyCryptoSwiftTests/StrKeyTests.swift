import XCTest
@testable import AnyCryptoSwift

final class StrKeyTests: XCTestCase {
    func testEncodeDecode() throws {
        let version: VersionByte = 0x5b
        let payload = Data(repeating: 0x01, count: 32)
        
        let encoded = try StrKey.encode(version: version, src: payload)
        let decoded = try StrKey.decode(expected: version, src: encoded)
        
        XCTAssertEqual(payload, decoded)
    }
    
    func testDecodeWithWrongVersion() throws {
        let version: VersionByte = 0x5b
        let wrongVersion: VersionByte = 0x5c
        let payload = Data(repeating: 0x01, count: 32)
        
        let encoded = try StrKey.encode(version: version, src: payload)
        
        XCTAssertThrowsError(try StrKey.decode(expected: wrongVersion, src: encoded))
    }
    
    func testDecodeInvalidChecksum() throws {
        let version: VersionByte = 0x5b
        let payload = Data(repeating: 0x01, count: 32)
        
        var raw = Data()
        raw.append(version)
        raw.append(payload)
        raw.append(Data([0x00, 0x00]))
        
        let encoded = Base58.encode(raw)
        
        XCTAssertThrowsError(try StrKey.decode(expected: version, src: encoded))
    }
    
    func testDecodeTooShort() throws {
        let encoded = Base58.encode(Data([0x5b, 0x01]))
        
        XCTAssertThrowsError(try StrKey.decode(expected: 0x5b, src: encoded))
    }
}