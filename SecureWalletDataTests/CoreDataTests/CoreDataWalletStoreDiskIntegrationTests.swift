//
//  CoreDataWalletStoreDiskIntegrationTests.swift
//  SecureWalletDataTests
//
//  Created by Fawaz Tarar on 13/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain
@testable import SecureWalletData
@testable import SecureWalletSecurity

final class CoreDataWalletStoreDiskIntegrationTests: XCTestCase {

    func test_save_persistsAcrossStackReinitialization() throws {

        let stack1 = CoreDataStack()
     
        
        let encryption = BasicEncryptionService()

        let store1 = CoreDataWalletStore(
            stack: stack1,
            encryptionService: encryption
        )

        var wallet = Wallet()

        let entry = try LedgerEntry(
            amount: CoinAmount(milliCoins: 200),
            direction: .credit,
            createdAt: Date()
        )

        try wallet.apply(entry)
        try store1.save(wallet)

        // 🔁 Simulate app restart
        let stack2 = CoreDataStack()
        let store2 = CoreDataWalletStore(
            stack: stack2,
            encryptionService: encryption
        )
        let loaded = try store2.load(walletID: wallet.id)

        XCTAssertEqual(loaded.balance, wallet.balance)
    }
}
