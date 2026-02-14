//
//  Wallet.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation

/// Wallet is a domain aggregate responsible for managing a collection of ledger entries
/// and enforcing financial business rules.
///
/// Responsibilities:
/// - Own and protect the ledger of financial entries
/// - Apply credits and debits in a controlled, validated manner
/// - Prevent invalid financial states (e.g. overdrafts)
/// - Derive the current balance from the ledger history
///
/// Invariants:
/// - The ledger is append-only and cannot be mutated externally
/// - The wallet balance can never be negative
/// - Invalid debits are rejected before mutating state
///
/// Notes:
/// - Wallet does not store balance directly; it is always computed
/// - Wallet contains no persistence, networking, or cryptographic logic
/// - All monetary validation is enforced at the aggregate boundary


public struct Wallet: Equatable {
    
    public let id: UUID
    
    private var ledger: [LedgerEntry] = []
    
    private var appliedEntryIds: Set<UUID> = []
    
    
    public init(id: UUID = UUID()) {
         self.id = id
     }

    
    public mutating func apply(_ entry: LedgerEntry) throws {
        
//        indempotency guard ignores duplicate entries
        if appliedEntryIds.contains(entry.id) {
            return
        }

        // Business rule: debits must not overdraft
        if entry.direction == .debit {
            guard (try? balance - entry.amount) != nil
            else {
                throw WalletError.insufficientFunds
            }
        }

        ledger.append(entry)
        appliedEntryIds.insert(entry.id)
    }

    
    public var balance: CoinAmount {
        var total = CoinAmount.zero

        for entry in ledger {
            switch entry.direction {
            case .credit:
                total =  total + entry.amount
            case .debit:
                total = try! total - entry.amount
            }
        }

        return total
    }
    
    public var entries: [LedgerEntry] {
        ledger
    }
    
    
    public func toRecord() -> WalletRecord {
        WalletRecord(walletID: id, entries: ledger)
    }
    
    public static func fromRecord(_ record: WalletRecord) throws -> Wallet {
        
        var wallet = Wallet(id: record.walletID)
        
        for entries in record.entries {
            try wallet.apply(entries)
        }
        
        return wallet
    }


}
