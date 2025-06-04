import Foundation

enum CRC16 {
    static func checksum(_ data: Data) -> Data {
        var crc: UInt16 = 0x0000
        
        for byte in data {
            crc = crc ^ UInt16(byte) << 8
            
            for _ in 0..<8 {
                if (crc & 0x8000) != 0 {
                    crc = (crc << 1) ^ 0x1021
                } else {
                    crc = crc << 1
                }
            }
        }
        
        var checksumData = Data(count: 2)
        checksumData[0] = UInt8(crc & 0xFF)
        checksumData[1] = UInt8((crc >> 8) & 0xFF)
        
        return checksumData
    }
    
    static func validate(_ data: Data, checksum: Data) throws {
        guard checksum.count == 2 else {
            throw CryptoError.invalidChecksum
        }
        
        let calculated = self.checksum(data)
        guard calculated == checksum else {
            throw CryptoError.checksumMismatch
        }
    }
}