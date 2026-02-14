//
//   WalletSnapShot.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 05/02/2026.
//

import Foundation


public struct WalletSnapShot {
    
    public let balance: CoinAmount
    public let entries: [LedgerEntry]
    
    public init(wallet: Wallet) {
        self.balance = wallet.balance
        self.entries = wallet.entries
            .sorted { $0.createdAt > $1.createdAt }

    }
    
}
