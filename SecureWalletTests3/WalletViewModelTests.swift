//
//  WalletViewModelTests.swift
//  SecureWalletTests3
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import XCTest

@testable import SecureWallet
@testable import SecureWalletDomain

final class WalletViewModelTests: XCTestCase {
    
    
    
   
    func test_viewModel_loadWallet_setsBalance_only() throws {
        
        // 1. Create wallet FIRST
        var wallet = Wallet()
        try wallet.apply(makeCredit(500))
        
        print("🧪 Test: wallet before assigning =", wallet.balance.milliCoins)
        
        // 2. Inject into service
        let service = DummyWalletService(wallet: wallet)
        let provider = MockWalletIDProvider()
        
        // 3. Create ViewModel
        let vm = WalletViewModel(service: service, walletIDProvider: provider)
        
        print("🧪 Test: ViewModel created")
        
        // 4. Act
        vm.loadWallet()
        
        print("🧪 Test: ViewModel balance after load =", vm.balance)
        
        // 5. Assert
        XCTAssertEqual(vm.balance, 500)
    }
}
