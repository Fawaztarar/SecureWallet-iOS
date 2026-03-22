//
//   DummyWalletService.swift
//  SecureWalletTests3
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import SecureWalletDomain

final class DummyWalletService: WalletServicing {

    private var wallet: Wallet

    init(wallet: Wallet = Wallet()) {
        self.wallet = wallet
        print("🧪 Service init with balance =", wallet.balance.milliCoins)
    }

    // MARK: - Create

    func createWallet() throws -> Wallet {
        print("🧪 Service: createWallet")
        wallet = Wallet()
        return wallet
    }

    // MARK: - Load

    func loadWallet(id: UUID) throws -> Wallet {
        print("🧪 Service: loadWallet =", wallet.balance.milliCoins)
        return wallet
    }

    // MARK: - Get or Create

    func getOrCreateWallet(id: UUID) throws -> Wallet {
        print("🧪 Service: getOrCreateWallet =", wallet.balance.milliCoins)
        return wallet
    }

    // MARK: - Apply

    func apply(_ entry: LedgerEntry, to walletID: UUID) throws -> Wallet {
        print("🧪 Service: applying entry =", entry.amount.milliCoins, entry.direction)

        try wallet.apply(entry)

        print("🧪 Service: new balance =", wallet.balance.milliCoins)

        return wallet
    }
}
