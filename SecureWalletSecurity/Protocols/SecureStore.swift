//
//  SecureStore.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
public protocol SecureStore {
    func save(_ data: Data, for key: String) throws
    func load(for key: String) throws -> Data
}
