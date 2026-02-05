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
        
        let entry = LedgerEntry(
            amount: amount,
            direction: .credit
        )
        
        XCTAssertEqual(entry.amount, amount)
    }
    
    
    func test_ledgerEntry_hasDirection() throws {
        
        let amount = try CoinAmount(milliCoins: 50)
        
        let entry = LedgerEntry(
            amount: amount,
            direction: .credit
        )
        
        XCTAssertEqual(entry.direction, .credit)
    }
    
    
}
