//
//  WalletStoreError.swift
//  SecureWalletDomain
//
//  Created by Fawaz Tarar on 06/02/2026.
//

import Foundation


public enum WalletStoreError: Error {
    case walletNotFound
    case persistenceFailure
}
