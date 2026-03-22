//
//  EncryptionService.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation

public protocol EncryptionService {
    func encrypt(_ data: Data) throws -> Data
    func decrypt(_ data: Data) throws -> Data
}
