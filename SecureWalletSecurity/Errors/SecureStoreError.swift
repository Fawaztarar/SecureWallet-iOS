//
//  SecureStoreError.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
enum SecureStoreError: Error {
    case itemNotFound
    case unexpectedData
    case failure(OSStatus)
}
