import Foundation

public struct AnyCryptoSwift {
    public static func decodeAccountAddress(_ address: String) throws -> PubKey {
        let pubKeyRaw = try StrKey.decode(expected: StrKey.accountAddressVersionByte, src: address)
        return try unmarshalEd25519PublicKey(data: pubKeyRaw)
    }
}