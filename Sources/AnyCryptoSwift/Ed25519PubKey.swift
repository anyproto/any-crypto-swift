import Foundation
import Crypto

public struct Ed25519PubKey: PubKey {
    private let publicKey: Curve25519.Signing.PublicKey
    
    public init(data: Data) throws {
        guard data.count == 32 else {
            throw CryptoError.invalidPublicKeySize
        }
        self.publicKey = try Curve25519.Signing.PublicKey(rawRepresentation: data)
    }
    
    public func verify(data: Data, signature: Data) throws -> Bool {
        guard signature.count == 64 else {
            throw CryptoError.invalidSignature
        }
        return publicKey.isValidSignature(signature, for: data)
    }
    
    public func account() -> String {
        return (try? StrKey.encode(version: StrKey.accountAddressVersionByte, src: publicKey.rawRepresentation)) ?? ""
    }
}

public func unmarshalEd25519PublicKey(data: Data) throws -> PubKey {
    return try Ed25519PubKey(data: data)
}