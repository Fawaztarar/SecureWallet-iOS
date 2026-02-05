//
//  CoinAmountTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain


final class CoinAmountTests: XCTestCase  {
    
    func test_zero_zeroMilliCoins() {
        
        let amount = CoinAmount.zero
        
        XCTAssertEqual(amount.milliCoins, 0)
    }
    
    
    func test_negativeMilliCoin_throwerror() {
        XCTAssertThrowsError( try CoinAmount(milliCoins: -1))
    }
    
    func test_addition_combineAmountMillCoins() throws {
        
        let a = try CoinAmount(milliCoins: 1000)
        let b = try CoinAmount(milliCoins: 2000)
        
        let result = a + b
        
     
        XCTAssertEqual(result.milliCoins, 3000)
    }
    
    
    
    
    
    func test_subtraction_whenResultWouldBeNegative_throwsError() throws {
        let balance = try CoinAmount(milliCoins: 20)
        let spend = try CoinAmount(milliCoins: 30)
        
        XCTAssertThrowsError(try balance - spend)
    }
    
}
