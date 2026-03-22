//
//  KeychainSecureStore.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
import Security

 public final class KeychainSecureStore: SecureStore {
     public init() {}
     
      public func save(_ data: Data, for key: String) throws {
        
        let query: [String: Any] = [
                 kSecClass as String: kSecClassGenericPassword,
                 kSecAttrAccount as String: key,
                 kSecValueData as String: data
             ]
        
        SecItemDelete(query as CFDictionary)

            let status = SecItemAdd(query as CFDictionary, nil)

            guard status == errSecSuccess else {
                throw SecurityError.encryptionFailed
            }
    }
    
    public func load(for key: String) throws -> Data {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

       
        if status == errSecItemNotFound {
            throw SecureStoreError.itemNotFound
        }

        guard status == errSecSuccess else {
            throw SecureStoreError.failure(status)
        }

        guard let data = result as? Data else {
            throw SecureStoreError.unexpectedData
        }

        return data
    }
    
}
