//
//  WalletListModels.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 22/03/2026.
//

import Foundation

import SecureWalletDomain

// MARK: - Section

nonisolated enum WalletSection: Hashable, Sendable {
    case balance
    case day(DaySection)
}

nonisolated struct DaySection: Hashable, Sendable {
    let id: UUID = UUID()
    let date: Date
    let title: String
 
}

// MARK: - Item

nonisolated enum WalletItem: Hashable, Sendable {
    case balance(Int) 
    case transaction(LedgerEntry)
}
