
//  WalletStoreTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 06/02/2026.



import Foundation
import XCTest
@testable import SecureWalletDomain

class WalletStoreContractTests: XCTestCase {

    override func invokeTest() {
        if type(of: self) == WalletStoreContractTests.self {
            return
        }
        super.invokeTest()
    }

    func makeStore() -> WalletStore {
        fatalError("Subclasses must override")
    }

    // MARK: - Core Persistence Guarantees

    func test_saveAndLoadWallet_preservesIdentityAndBalance() throws {
        // GIVEN
        let store = makeStore()
        var wallet = Wallet()

        try wallet.apply(makeCredit(100))

        let originalBalance = wallet.balance
        let originalID = wallet.id

        // WHEN
        try store.save(wallet)
        let loaded = try store.load(walletID: originalID)

        // THEN
        XCTAssertEqual(loaded.id, originalID)
        XCTAssertEqual(loaded.balance, originalBalance)
    }

    func test_loadingNonExistentWallet_throwsWalletNotFound() throws {
        let store = makeStore()
        let unknownID = UUID()

        XCTAssertThrowsError(
            try store.load(walletID: unknownID)
        ) { error in
            XCTAssertEqual(error as? WalletStoreError, .walletNotFound)
        }
    }

    // MARK: - Financial Integrity Guarantees

    func test_failedDebit_doesNotMutateState_afterReload() throws {
        // GIVEN
        let store = makeStore()
        var wallet = Wallet()

        try wallet.apply(makeCredit(100))

        // WHEN
        XCTAssertThrowsError(
            try wallet.apply(makeDebit(200))
        )

        try store.save(wallet)
        let loaded = try store.load(walletID: wallet.id)

        // THEN
        XCTAssertEqual(loaded.balance.milliCoins, 100)
    }

    func test_duplicateLedgerEntry_isIdempotent_afterReload() throws {
        // GIVEN
        let store = makeStore()
        var wallet = Wallet()

        let entry = try makeCredit(100)

        try wallet.apply(entry)
        try wallet.apply(entry) // duplicate apply

        let balanceAfterDuplicate = wallet.balance

        // WHEN
        try store.save(wallet)
        let loaded = try store.load(walletID: wallet.id)

        // THEN
        XCTAssertEqual(loaded.balance, balanceAfterDuplicate)
    }

    func test_ledgerOrder_isPreserved_afterReload() throws {
        // GIVEN
        let store = makeStore()
        var wallet = Wallet()

        try wallet.apply(makeCredit(100))
        try wallet.apply(makeCredit(50))
        try wallet.apply(makeDebit(25))

        // WHEN
        try store.save(wallet)
        let loaded = try store.load(walletID: wallet.id)

        // THEN
        let amounts = loaded.entries.map { $0.amount.milliCoins }
        XCTAssertEqual(amounts, [100, 50, 25])
    }
}
