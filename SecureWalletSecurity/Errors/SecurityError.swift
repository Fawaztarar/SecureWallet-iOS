//
//  SecurityError.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation

enum SecurityError: Error {
    case invalidData
    case encryptionFailed
    case decryptionFailed
}
