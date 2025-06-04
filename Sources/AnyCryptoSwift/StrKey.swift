import Foundation

typealias VersionByte = UInt8

enum StrKey {
    static let accountAddressVersionByte: VersionByte = 0x5b
    
    static func decode(expected: VersionByte, src: String) throws -> Data {
        let raw = try decodeString(src)
        
        guard raw.count >= 3 else {
            throw CryptoError.invalidStrKey
        }
        
        let version = raw[0]
        let vp = raw[0..<raw.count-2]
        let payload = raw[1..<raw.count-2]
        let checksum = raw[raw.count-2..<raw.count]
        
        guard version == expected else {
            throw CryptoError.invalidVersionByte
        }
        
        try CRC16.validate(vp, checksum: checksum)
        
        return payload
    }
    
    static func encode(version: VersionByte, src: Data) throws -> String {
        var raw = Data()
        raw.append(version)
        raw.append(src)
        
        let checksum = CRC16.checksum(raw)
        raw.append(checksum)
        
        return Base58.encode(raw)
    }
    
    private static func decodeString(_ src: String) throws -> Data {
        let raw = try Base58.decode(src)
        
        guard raw.count >= 3 else {
            throw CryptoError.invalidStrKey
        }
        
        return raw
    }
}