//
//  DemoWalletService.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import SecureWalletDomain

final class DemoWalletService: WalletServicing {
    
    private var wallet = Wallet()
    
    func createWallet() throws -> Wallet {
        wallet = Wallet()
        return wallet
    }
    
    func loadWallet(id: UUID) throws -> Wallet {
        return wallet
    }
    
    func getOrCreateWallet(id: UUID) throws -> Wallet {
        return wallet
    }
    
    func apply(_ entry: LedgerEntry, to walletID: UUID) throws -> Wallet {
        try wallet.apply(entry)
        return wallet
    }
}
