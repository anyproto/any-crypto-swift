import Foundation
import Crypto

public protocol PubKey {
    func verify(data: Data, signature: Data) throws -> Bool
    func account() -> String
}