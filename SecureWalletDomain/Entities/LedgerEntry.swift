//
//  LedgerEntry.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import Foundation

/// LedgerEntry represents a single immutable financial record in the domain.
///
/// Responsibilities:
/// - Capture a single financial event
/// - Hold a monetary amount
/// - Remain immutable once created
///
/// Invariants:
/// - Amount must always be a valid CoinAmount
///
/// Notes:
/// - LedgerEntry contains no business logic
/// - LedgerEntry does not mutate state
/// - LedgerEntry is append-only when used by a Wallet

public struct LedgerEntry: Equatable, Codable, Hashable, Sendable {
    
    public enum Direction: Codable, Sendable, Hashable {
        case credit
        case debit
    }
        public let amount: CoinAmount
    
        public let direction: Direction
    
        public let createdAt: Date
    
    public let id: UUID
        
    public init(id:UUID = UUID(), amount: CoinAmount, direction: Direction, createdAt: Date) {
        self.id = id
            self.amount = amount
            self.direction = direction
        self.createdAt = createdAt
        
        }
    
}
