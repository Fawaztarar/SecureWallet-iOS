//
//  WalletTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain

final class WalletTests: XCTestCase {
    
    func test_walletBalanceStartsZero() throws {
        let wallet =  Wallet()
        
        XCTAssertEqual(wallet.balance, try CoinAmount(milliCoins: 0))
    }
    
    func test_walletAppplyingCreditIncreaseBalance() throws {
//        Arrange
        var wallet = Wallet()
        let createdAt = Date(timeIntervalSince1970: 0)
        
        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
         direction: .credit,
            createdAt: createdAt
            
        )
        
        
//    ACT
        
        try wallet.apply(credit)
        
//ASSERT
        XCTAssertEqual(wallet.balance, try CoinAmount(milliCoins: 100))
    }
    
    func test_walletApplyingDebitMoreThanBalanceThrowsError() throws {
        // Arrange
        var wallet = Wallet()
        let createdAt = Date(timeIntervalSince1970: 0)

        let debit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 50),
            direction: .debit,
            createdAt: createdAt
        )

        // Act & Assert
        XCTAssertThrowsError(try wallet.apply(debit))
    }
    
    func test_walletApplyingDebitEqualToBalanceSucceeds() throws {
        var wallet = Wallet()
        let createdAt = Date(timeIntervalSince1970: 0)

        
        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: createdAt
        )
        
        let debit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .debit,
            createdAt: createdAt
        )
        
        try wallet.apply(credit)
        try wallet.apply(debit)
        
        
        XCTAssertEqual(wallet.balance, .zero)
    }
    
    
    func test_walletDoesNotMutateBalanceWhenDebitFails() throws {
        // Arrange
        var wallet = Wallet()
        let createdAt = Date(timeIntervalSince1970: 0)


        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: createdAt
        )
        try wallet.apply(credit)

        let failingDebit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 200),
            direction: .debit,
            createdAt: createdAt
        )

        // Act
        XCTAssertThrowsError(try wallet.apply(failingDebit))

        // Assert
        XCTAssertEqual(wallet.balance, try CoinAmount(milliCoins: 100))
    }
    
    
    // Wallet must be retry-safe and prevent duplicate application of the same financial event
    func test_walletApplyingSameLedgerEntryTwice_doesNotChangeBalance() throws {
        
        var wallet = Wallet()
        let createdAt = Date(timeIntervalSince1970: 0)
        let amount = try CoinAmount(milliCoins: 100)

        
        let ledgerEntry = LedgerEntry(
            amount: amount,
            direction: .credit,
            createdAt: createdAt
        )
        
//        Act
        try wallet.apply(ledgerEntry)
        try wallet.apply(ledgerEntry)
        
        
        XCTAssertEqual(wallet.balance, amount)
        
    }



}
