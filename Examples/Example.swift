import Foundation
import AnyCryptoSwift
import Crypto

// Example: Creating a key pair and verifying signatures
func exampleSignatureVerification() throws {
    // Generate a new key pair
    let privateKey = Curve25519.Signing.PrivateKey()
    let publicKey = privateKey.publicKey
    
    // Create Ed25519PubKey from raw public key data
    let pubKey = try Ed25519PubKey(data: publicKey.rawRepresentation)
    
    // Get the account address (starts with 'A')
    let accountAddress = pubKey.account()
    print("Account Address: \(accountAddress)")
    
    // Create a message and sign it
    let message = "Hello, Anytype!".data(using: .utf8)!
    let signature = try privateKey.signature(for: message)
    
    // Verify the signature
    let isValid = try pubKey.verify(data: message, signature: signature)
    print("Signature is valid: \(isValid)")
    
    // Decode the account address back to public key
    let decodedPubKey = try AnyCryptoSwift.decodeAccountAddress(accountAddress)
    
    // Verify signature with decoded public key
    let isValidDecoded = try decodedPubKey.verify(data: message, signature: signature)
    print("Signature verified with decoded key: \(isValidDecoded)")
}

// Example: Verifying an existing signature
func exampleVerifyExistingSignature() throws {
    // Example account address (replace with actual address)
    let accountAddress = "A..." // Should start with 'A'
    
    // Decode the account address
    let pubKey = try AnyCryptoSwift.decodeAccountAddress(accountAddress)
    
    // Message and signature to verify
    let message = "Message to verify".data(using: .utf8)!
    let signature = Data(base64Encoded: "...")! // Replace with actual 64-byte signature
    
    // Verify the signature
    let isValid = try pubKey.verify(data: message, signature: signature)
    print("Signature is valid: \(isValid)")
}

// Run examples
do {
    try exampleSignatureVerification()
    // try exampleVerifyExistingSignature() // Uncomment with real data
} catch {
    print("Error: \(error)")
}