//
//  CryptoKitEncryptionService.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
import CryptoKit

public final class CryptoKitEncryptionService: EncryptionService {

    private let keyManager: KeyManager

    public init(keyManager: KeyManager) {
        self.keyManager = keyManager
    }
   

    public func encrypt(_ data: Data) throws -> Data {
        print("🔐 Encrypting data size:", data.count)
        
        let key = try keyManager.getKey()
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)

            guard let combined = sealedBox.combined else {
                throw SecurityError.encryptionFailed
            }

            return combined
        } catch {
            throw SecurityError.encryptionFailed
        }
    }

    public func decrypt(_ data: Data) throws -> Data {
        print("🔓 Decrypting data size:", data.count)
        let key = try keyManager.getKey()
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            throw SecurityError.decryptionFailed
        }
    }
}
