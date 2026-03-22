//
//  WalletRecord.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 06/02/2026.
//

import Foundation

public struct WalletRecord: Equatable, Codable {
    
    public let walletID: UUID
    public let entries: [LedgerEntry]
    
    
    public init(walletID: UUID, entries: [LedgerEntry]) {
        self.walletID = walletID
        self.entries = entries
    }
}
