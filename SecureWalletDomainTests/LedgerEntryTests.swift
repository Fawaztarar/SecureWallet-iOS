//
//  LedgerEntryTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain

final class LedgerEntryTest: XCTestCase {
    
    func test_ledgerEntry_StoresAmount() throws {
        
        let amount = try CoinAmount(milliCoins: 100)
        let createdAt = Date(timeIntervalSince1970: 0)

        
        let entry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
            
        )
        
        XCTAssertEqual(entry.amount, amount)
    }
    
    
    func test_ledgerEntry_hasDirection() throws {
        
        let amount = try CoinAmount(milliCoins: 50)
        let createdAt = Date(timeIntervalSince1970: 0)
        
        let entry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
        )
        
        XCTAssertEqual(entry.direction, .credit)
    }
    
    func test_ledgerEntry_hasStableId() throws {
        
        let amount = try CoinAmount(milliCoins: 100)
        let createdAt = Date()

        let entry = LedgerEntry(
            amount: amount,
            direction: LedgerEntry.Direction.credit,
            createdAt: createdAt
        
        )
        
        let firstId = entry.id
        let secondId = entry.id
        
        
        XCTAssertEqual(firstId,secondId)
        
    }
    
    func test_ledgerEntry_generatesUniqueIds() throws {
        let amount = try CoinAmount(milliCoins: 100)
        let createdAt = Date()

        let firstEntry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
        )

        let secondEntry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
        )

        XCTAssertNotEqual(firstEntry.id, secondEntry.id)
    }
    
    
    func test_ledgerEntry_storesCreationTimestamp() throws {
        
        let amount = try CoinAmount(milliCoins: 50)
        let fixedtime = Date()
        
        let entry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: fixedtime
        )
        
        XCTAssertEqual(entry.createdAt, fixedtime)
        
    }
    
    
    func test_wallet_apply_and_balance_doesNotCrash() throws {
        var wallet = Wallet()
        
        let entry = try LedgerEntry(
            amount: CoinAmount(milliCoins: 500),
            direction: .credit,
            createdAt: Date()
        )
        
        try wallet.apply(entry)
        
        // 🔥 This is where your crash happens indirectly
        let balance = wallet.balance
        
        XCTAssertEqual(balance.milliCoins, 500)
    }
    
}
