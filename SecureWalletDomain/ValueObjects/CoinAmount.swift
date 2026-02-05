//
//  CoinAmount.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation


public struct CoinAmount: Equatable, Comparable {
    
    
    public let milliCoins: Int
    
    public static let zero = try! CoinAmount(milliCoins: 0)

    
    public init(milliCoins: Int) throws {
        
        guard milliCoins >= 0 else {
            throw CoinAmountError.negativeNotAllowed
        }
        self.milliCoins = milliCoins
        
    }
    
    
    public static func + (lhs:CoinAmount, rhs:CoinAmount) -> CoinAmount {
        
        return try! CoinAmount(milliCoins: lhs.milliCoins + rhs.milliCoins) 
        
    }
    
    public static func - (lhs:CoinAmount, rhs:CoinAmount) throws -> CoinAmount {
        
        let result = lhs.milliCoins - rhs.milliCoins
            
            return try CoinAmount(milliCoins: result)
        }
    
    public static func < (lhs:CoinAmount, rhs:CoinAmount) -> Bool {
        lhs.milliCoins < rhs.milliCoins
    }
        
    
}

