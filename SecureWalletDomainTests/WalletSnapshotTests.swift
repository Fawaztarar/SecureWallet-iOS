//
//  WalletSnapshotTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 05/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain

final class WalletSnapshotTests: XCTestCase {
    
    
    func test_walletSnapshot_exposesCurrentBalance() throws {
        
        
        var wallet = Wallet()
        let amount = try CoinAmount(milliCoins: 100)
        let createdAt = Date(timeIntervalSince1970: 0)
        
        let credit = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
            
        )
        
        try wallet.apply(credit)
        
        //    ACT
        let snapshot = WalletSnapShot(wallet: wallet)
        
        
        XCTAssertEqual(snapshot.balance, amount)

        
        
    }
    
    func test_walletSnapshot_exposesLedgerEntries() throws {
        // Arrange
        var wallet = Wallet()
        let amount = try CoinAmount(milliCoins: 100)
        let createdAt = Date(timeIntervalSince1970: 0)

        let credit = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
        )

        try wallet.apply(credit)

        // Act
        let snapshot = WalletSnapShot(wallet: wallet)

        // Assert
        XCTAssertEqual(snapshot.entries.count, 1)
        XCTAssertEqual(snapshot.entries.first?.amount, amount)
        XCTAssertEqual(snapshot.entries.first?.direction, .credit)
    }
    
    
    func test_walletSnapshot_ordersEntriesMostRecentFirst() throws {
        
        // Arrange
        var wallet = Wallet()
        let amount = try CoinAmount(milliCoins: 100)
        let olderDate = Date(timeIntervalSince1970: 0)
          let newerDate = Date(timeIntervalSince1970: 100)

        let olderEntry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: olderDate
        )
        
        let NewerEntry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: newerDate
        )

        try wallet.apply(olderEntry)
        try wallet.apply(NewerEntry)
        
        
        // Act
        let snapshot = WalletSnapShot(wallet: wallet)
        
        
//         Assert
        XCTAssertEqual(snapshot.entries.count, 2)
        XCTAssertEqual(snapshot.entries.first?.createdAt, newerDate)
         XCTAssertEqual(snapshot.entries.last?.createdAt, olderDate)
        
    }


    
    
}
