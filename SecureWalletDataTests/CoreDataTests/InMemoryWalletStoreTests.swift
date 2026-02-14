//
//  InMemoryWalletStoreTests.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import XCTest
@testable import SecureWalletDomain
@testable import SecureWalletData

final class InMemoryWalletStoreTests: WalletStoreContractTests {

    override func makeStore() -> WalletStore {
        InMemoryWalletStore()
    }
}
