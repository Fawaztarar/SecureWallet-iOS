//
//  Helpers.swift
//  SecureWalletTests3
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation

@testable import SecureWalletDomain

func makeCredit(_ amount: Int) throws -> LedgerEntry {
    return try LedgerEntry(
        amount: CoinAmount(milliCoins: amount),
        direction: .credit,
        createdAt: Date()
    )
}

func makeDebit(_ amount: Int) throws -> LedgerEntry {
    return try LedgerEntry(
        amount: CoinAmount(milliCoins: amount),
        direction: .debit,
        createdAt: Date()
    )
}
