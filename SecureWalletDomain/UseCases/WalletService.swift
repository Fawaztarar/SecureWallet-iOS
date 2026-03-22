//
//  WalletService.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation

public protocol WalletServicing {
    func createWallet() throws -> Wallet
    func loadWallet(id: UUID) throws -> Wallet
    func getOrCreateWallet(id: UUID) throws -> Wallet
    func apply(_ entry: LedgerEntry, to walletID: UUID) throws -> Wallet
}

public final class WalletService: WalletServicing {
    
    private let store: WalletStore
    
    public init(store: WalletStore) {
        self.store = store
    }
    
    public func createWallet() throws -> Wallet {
        let wallet = Wallet()
        try store.save(wallet)
        return wallet
    }
    
    public func loadWallet(id: UUID) throws -> Wallet {
        return try store.load(walletID: id)
    }
    
    public func getOrCreateWallet(id: UUID) throws -> Wallet {
        do {
            return try store.load(walletID: id)
        } catch WalletStoreError.walletNotFound {
            let wallet = Wallet(id: id)
            try store.save(wallet)
            return wallet
        }
    }
    
    public func apply(
        _ entry: LedgerEntry,
        to walletID: UUID
    ) throws -> Wallet {
        
        var wallet = try getOrCreateWallet(id: walletID)
        try wallet.apply(entry)
        try store.save(wallet)
        
        return wallet
    }
}
