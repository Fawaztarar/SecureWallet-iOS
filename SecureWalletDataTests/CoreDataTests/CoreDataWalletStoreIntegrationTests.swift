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
@testable import SecureWalletSecurity

import CoreData

final class CoreDataWalletStoreIntegrationTests: XCTestCase {

    func test_save_persistsEncryptedWalletPayload() throws {

        let stack = InMemoryCoreDataStack()
        let encryption = BasicEncryptionService()

        let store = CoreDataWalletStore(
            stack: stack,
            encryptionService: encryption
        )

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

        let request: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        let wallets = try context.fetch(request)

        XCTAssertEqual(wallets.count, 1)

        guard let entity = wallets.first else {
            XCTFail("WalletEntity not found")
            return
        }

        XCTAssertEqual(entity.id, wallet.id)

        // ✅ New assertion: encrypted payload exists
        guard let payload = entity.encryptedPayload else {
            XCTFail("Encrypted payload missing")
            return
        }

        XCTAssertFalse(payload.isEmpty)
    }
    
    
    func test_tamperedEncryptedPayload_throwsError() throws {

        let stack = InMemoryCoreDataStack()
        let encryption = BasicEncryptionService()

        let store = CoreDataWalletStore(
            stack: stack,
            encryptionService: encryption
        )

        var wallet = Wallet()

        let entry = try LedgerEntry(
            amount: CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: Date()
        )

        try wallet.apply(entry)
        try store.save(wallet)

        // 🔥 Tamper with stored data
        let context = stack.context

        let request: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        let wallets = try context.fetch(request)

        guard let entity = wallets.first else {
            XCTFail("Missing wallet")
            return
        }

        entity.encryptedPayload = Data("corrupted-data".utf8)

        try stack.save()

        // 🚨 Must throw
        XCTAssertThrowsError(
            try store.load(walletID: wallet.id)
        )
    }
    
}

