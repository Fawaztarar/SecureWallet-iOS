//
//  WalletStore.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 06/02/2026.
//

import Foundation

public protocol WalletStore {
    
    /// Persist the current state of a wallet
    func save(_ wallet: Wallet) throws
    
    /// Load and rehydrate a wallet by its identity
    func load(walletID: UUID) throws -> Wallet
}
