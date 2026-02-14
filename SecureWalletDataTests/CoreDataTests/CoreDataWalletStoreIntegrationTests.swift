//
//  CoreDataWalletStoreIntegrationTests.swift
//  SecureWalletDataTests
//
//  Created by Fawaz Tarar on 13/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain
@testable import SecureWalletData
import CoreData

final class CoreDataWalletStoreIntegrationTests: XCTestCase {

    func test_save_persistsWalletAndEntries_withCorrectMapping() throws {

        let stack = InMemoryCoreDataStack()
        let store = CoreDataWalletStore(stack: stack)

        var wallet = Wallet()

        let credit = try LedgerEntry(
            amount: CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: Date()
        )

        let debit = try LedgerEntry(
            amount: CoinAmount(milliCoins: 40),
            direction: .debit,
            createdAt: Date()
        )

        try wallet.apply(credit)
        try wallet.apply(debit)

        try store.save(wallet)

        // 🔎 Direct Core Data inspection

        let context = stack.context

        let walletFetch: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        let wallets = try context.fetch(walletFetch)

        XCTAssertEqual(wallets.count, 1)

        guard let walletEntity = wallets.first else {
            XCTFail("WalletEntity not found")
            return
        }

        XCTAssertEqual(walletEntity.id, wallet.id)

        let entryFetch: NSFetchRequest<LedgerEntryEntity> = LedgerEntryEntity.fetchRequest()
        entryFetch.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true)
        ]

        let entries = try context.fetch(entryFetch)

        XCTAssertEqual(entries.count, 2)

        XCTAssertEqual(entries[0].milliCoins, 100)
        XCTAssertEqual(entries[0].direction, "credit")
        XCTAssertEqual(entries[0].orderIndex, 0)

        XCTAssertEqual(entries[1].milliCoins, 40)
        XCTAssertEqual(entries[1].direction, "debit")
        XCTAssertEqual(entries[1].orderIndex, 1)
    }
}
