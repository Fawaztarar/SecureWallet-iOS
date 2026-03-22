//
//  EncyptionServiceTest.swift
//  SecureWalletSecurityTests
//
//  Created by Fawaz Tarar on 17/03/2026.
//

import Foundation
import XCTest
@testable import SecureWalletSecurity

final class EncyptionServiceTest: XCTestCase {
    
    func test_encrypt_dycrpt_return_OrginalData() throws {
        
        let service = BasicEncryptionService()
        
        let input = "wallet-data".data(using: .utf8)!
        
        let encrypted = try service.encrypt(input)
        
        let decrypted = try service.encrypt(encrypted)
        
        XCTAssertEqual(decrypted, input)
    }
    
    func test_decrypt_emptyData_throwsError() {
        let service = BasicEncryptionService()

        let emptyData = Data()

        XCTAssertThrowsError(try service.decrypt(emptyData))
    }
    
}
