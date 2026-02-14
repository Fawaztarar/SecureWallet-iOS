//
//  WalletRecordRoundTripTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 05/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain

final class WalletRecordRoundTripTests: XCTestCase {
    
    func test_wallet_roundTrip_throughRecord_preservesFinancialTruth() throws {
        
        var wallet = Wallet()
        let createdAt = Date()
        
        let credit =  LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: createdAt)
        
        let debit =  LedgerEntry(
            amount: try CoinAmount(milliCoins: 50),
            direction: .debit,
            createdAt: createdAt)
        
        
        try wallet.apply(credit)
        try wallet.apply(debit)
        
        
        let originalBalance = wallet.balance
        
        // WHEN the wallet is persisted into a record
          let record = wallet.toRecord()
        
        // AND rehydrated back into a wallet
           let rehydratedWallet = try Wallet.fromRecord(record)
        
        // THEN financial truth is preserved
        XCTAssertEqual(rehydratedWallet.balance, originalBalance)
    }

    
 
}
