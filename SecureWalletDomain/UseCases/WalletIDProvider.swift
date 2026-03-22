//
//  WalletIDProvider.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 18/03/2026.
//

import Foundation

public protocol WalletIDProviding {
    func getWalletID() -> UUID
}


public final class WalletIDProvider: WalletIDProviding {
    
    private let key = "wallet_id"
    
    public init() {}
    
    public func getWalletID() -> UUID {
        if let saved = UserDefaults.standard.string(forKey: key),
           let uuid = UUID(uuidString: saved) {
            return uuid
        }
        
        let newID = UUID()
        UserDefaults.standard.set(newID.uuidString, forKey: key)
        return newID
    }
}
