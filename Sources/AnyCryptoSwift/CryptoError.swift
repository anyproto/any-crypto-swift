import Foundation

public enum CryptoError: Error {
    case invalidChecksum
    case checksumMismatch
    case invalidBase58String
    case invalidStrKey
    case invalidVersionByte
    case invalidPublicKeySize
    case invalidSignature
}