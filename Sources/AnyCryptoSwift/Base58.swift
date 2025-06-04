import Foundation
import BigInt

enum Base58 {
    private static let alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    private static let alphabetMap: [Character: Int] = {
        var map = [Character: Int]()
        for (index, char) in alphabet.enumerated() {
            map[char] = index
        }
        return map
    }()
    
    static func encode(_ data: Data) -> String {
        guard !data.isEmpty else {
            return ""
        }
        
        let bytes = Array(data)
        var encoded = ""
        
        let base = BigInt(58)
        var num = BigInt(sign: .plus, magnitude: BigUInt(Data(bytes)))
        
        while num > 0 {
            let (quotient, remainder) = num.quotientAndRemainder(dividingBy: base)
            encoded = String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(remainder))]) + encoded
            num = quotient
        }
        
        if encoded.isEmpty {
            encoded = "1"
        }
        
        for byte in bytes {
            if byte == 0 {
                encoded = "1" + encoded
            } else {
                break
            }
        }
        
        return encoded
    }
    
    static func decode(_ string: String) throws -> Data {
        guard !string.isEmpty else {
            throw CryptoError.invalidBase58String
        }
        
        var num = BigInt(0)
        let base = BigInt(58)
        
        for char in string {
            guard let value = alphabetMap[char] else {
                throw CryptoError.invalidBase58String
            }
            num = num * base + BigInt(value)
        }
        
        let magnitude = num.magnitude
        var bytes = [UInt8]()
        
        if magnitude == 0 {
            bytes = [0]
        } else {
            var temp = magnitude
            while temp > 0 {
                bytes.insert(UInt8(temp % 256), at: 0)
                temp /= 256
            }
        }
        
        for char in string {
            if char == "1" {
                bytes.insert(0, at: 0)
            } else {
                break
            }
        }
        
        return Data(bytes)
    }
}