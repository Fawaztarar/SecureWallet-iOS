//
//  AppContainer.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 18/03/2026.
//

import Foundation
import SecureWalletSecurity
import SecureWalletData
import SecureWalletDomain

final class AppContainer {
    
    // MARK: - Security
    
    lazy var secureStore: SecureWalletSecurity.SecureStore = {
        KeychainSecureStore()
    }()
    
    
    lazy var keyManager: SecureWalletSecurity.KeyManager = {
        KeyManager(store: secureStore)
    }()

    lazy var encryptionService: SecureWalletSecurity.EncryptionService = {
        
        return CryptoKitEncryptionService(keyManager: keyManager)
      }()
    
    // MARK: - Persistence
    
    lazy var coreDataStack: CoreDataStacking = {
        CoreDataStack()
    }()
    
    lazy var walletStore: WalletStore = {
        CoreDataWalletStore(
            stack: coreDataStack,
            encryptionService: encryptionService
        )
    }()
}
