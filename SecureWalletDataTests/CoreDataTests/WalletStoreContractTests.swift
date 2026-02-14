//
//  WalletStoreTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 06/02/2026.
//

import Foundation
import XCTest
@testable import SecureWalletDomain




//final class WalletStoreTests: XCTestCase {
    
    
 class WalletStoreContractTests: XCTestCase {
    
    func makeStore() -> WalletStore {
        fatalError("Subclasses must override")
    }

    
    func test_saveAndLoadWallet_preservesIdentityAndBalance() throws {
        
//    let store = InMemoryWalletStore()
        let store = makeStore()
        
        var wallet = Wallet()
        let createdAt = Date()
        
        let credit =  LedgerEntry(
            amount: try CoinAmount(milliCoins: 100),
            direction: .credit,
            createdAt: createdAt)
        
    
        
        
        try wallet.apply(credit)
        
        
        let originalBalance = wallet.balance
        let originalID = wallet.id
        
        try store.save(wallet)
        
        // WHEN the wallet is saved
        try store.save(wallet)
        
        // AND later loaded by its ID
             let loadedWallet = try store.load(walletID: originalID)
        
        // THEN the wallet identity is preserved
            XCTAssertEqual(loadedWallet.id, originalID)

               // AND the financial truth is preserved
            XCTAssertEqual(loadedWallet.balance, originalBalance)

    }
    
    
    func test_loadingNonExistentWallet_throwsWalletNotFound() throws {
        
        // Arrange
//        let store = InMemoryWalletStore()
        let store = makeStore()
        let unknownID = UUID()
        
        // Act + Assert
        XCTAssertThrowsError(try store.load(walletID: unknownID)) { error in
            XCTAssertEqual(error as? WalletStoreError, .walletNotFound)
        }
    }

}

