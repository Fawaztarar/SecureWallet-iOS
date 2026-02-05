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
        
        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
         direction: .credit
        )
        
        
//    ACT
        
        try wallet.apply(credit)
        
//ASSERT
        XCTAssertEqual(wallet.balance, try CoinAmount(milliCoins: 100))
    }
    
    func test_walletApplyingDebitMoreThanBalanceThrowsError() throws {
        // Arrange
        var wallet = Wallet()

        let debit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 50),
            direction: .debit
        )

        // Act & Assert
        XCTAssertThrowsError(try wallet.apply(debit))
    }
    
    func test_walletApplyingDebitEqualToBalanceSucceeds() throws {
        var wallet = Wallet()
        
        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit
        )
        
        let debit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .debit
        )
        
        try wallet.apply(credit)
        try wallet.apply(debit)
        
        
        XCTAssertEqual(wallet.balance, .zero)
    }
    
    
    func test_walletDoesNotMutateBalanceWhenDebitFails() throws {
        // Arrange
        var wallet = Wallet()

        let credit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit
        )
        try wallet.apply(credit)

        let failingDebit = LedgerEntry(
            amount: try CoinAmount(milliCoins: 200),
            direction: .debit
        )

        // Act
        XCTAssertThrowsError(try wallet.apply(failingDebit))

        // Assert
        XCTAssertEqual(wallet.balance, try CoinAmount(milliCoins: 100))
    }



}
