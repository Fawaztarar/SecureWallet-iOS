//
//  InMemoryWalletStore.swift
//  SecureWalletDomainTests
//
//  Created by Fawaz Tarar on 06/02/2026.
//

import Foundation
//import XCTest
@testable import SecureWalletDomain

final class InMemoryWalletStore: WalletStore {

    private var storage: [UUID: WalletRecord] = [:]

    func save(_ wallet: Wallet) throws {
        let record = wallet.toRecord()
        storage[record.walletID] = record
    }

    func load(walletID: UUID) throws -> Wallet {
        guard let record = storage[walletID] else {
            throw WalletStoreError.walletNotFound
        }

        return try Wallet.fromRecord(record)
    }
}

