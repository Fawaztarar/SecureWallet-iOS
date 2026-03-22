//
//  KeyManager.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
import CryptoKit

public final class KeyManager {
    private let store: SecureStore
    private let keyIdentifier = "wallet_encryption_key"
    
    public init(store: SecureStore) {
        self.store = store
    }
    
    public func getKey() throws -> SymmetricKey {
        
        do {
          let data = try store.load(for: keyIdentifier)
            return SymmetricKey(data: data)
            
        } catch SecureStoreError.itemNotFound {
            
            let newKey = SymmetricKey(size: .bits256)
            let keyData = newKey.withUnsafeBytes{ Data($0) }
            
            try store.save(keyData, for: keyIdentifier)
            
            return newKey
        } catch {
            throw error
        }
    }
}
