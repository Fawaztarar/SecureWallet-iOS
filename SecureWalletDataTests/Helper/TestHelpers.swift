//
//  TestHelpers.swift
//  SecureWalletDataTests
//
//  Created by Fawaz Tarar on 15/02/2026.
//

import Foundation

@testable import SecureWalletDomain

// Fixed timestamp for deterministic replay
let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

func makeCredit(_ amount: Int64) throws -> LedgerEntry {
    LedgerEntry(
        amount: try CoinAmount(milliCoins: Int(amount)),
        direction: .credit,
        createdAt: fixedDate
    )
}

func makeDebit(_ amount: Int64) throws -> LedgerEntry {
    LedgerEntry(
        amount: try CoinAmount(milliCoins: Int(amount)),
        direction: .debit,
        createdAt: fixedDate
    )
}
