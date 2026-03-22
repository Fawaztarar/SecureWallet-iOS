//
//  BasicEncryptionService.swift
//  SecureWalletSecurity
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation

final class BasicEncryptionService: EncryptionService {
    func encrypt(_ data: Data) throws -> Data {
        return Data(data.reversed())
    }
    
    func decrypt(_ data: Data) throws -> Data {
        guard !data.isEmpty else {
            throw SecurityError.invalidData
        }
        return Data(data.reversed())
    }
    
    
}
