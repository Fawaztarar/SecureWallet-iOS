//
//  CoreDataWalletStoreTests.swift
//  SecureWalletDataTests
//
//  Created by Fawaz Tarar on 12/02/2026.
//


import XCTest
@testable import SecureWalletDomain
@testable import SecureWalletData
@testable import SecureWalletSecurity



final class CoreDataWalletStoreTests: WalletStoreContractTests {
    
    //    override func makeStore() -> WalletStore {
    //        let stack = InMemoryCoreDataStack()
    //        return CoreDataWalletStore(stack: stack)
    //    }
    override func makeStore() -> WalletStore {
        let stack = InMemoryCoreDataStack()
        let encryption = BasicEncryptionService()
        
        return CoreDataWalletStore(
            stack: stack,
            encryptionService: encryption
        )
    }
}
