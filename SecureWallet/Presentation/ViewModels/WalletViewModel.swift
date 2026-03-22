//
//  walletViewModel.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 18/03/2026.
//

import Foundation
import SecureWalletDomain
import Combine




final class WalletViewModel {
    
    
    private let service: WalletServicing
    private let walletID: UUID
    
    private var wallet: Wallet?
    
    @Published private(set) var balance: Int = 0
    @Published private(set) var transactions: [LedgerEntry] = []
    

    
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    

    
    init(service: WalletServicing, walletIDProvider: WalletIDProviding) {
        self.service = service
        self.walletID = walletIDProvider.getWalletID()
    }
    
    func loadWallet() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self else { return }
            
            do {
                let wallet = try self.service.getOrCreateWallet(id: self.walletID)
                
                DispatchQueue.main.async {
                    self.wallet = wallet // ✅ store it
                    self.updateState(with: wallet)
                    self.isLoading = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load wallet"
                    self.isLoading = false
                }
            }
        }
    }
    

    
    private func updateState(with wallet: Wallet){
        print("🧠 VM: updateState")
        print("   balance =", wallet.balance.milliCoins)
        print("   entries =", wallet.entries.count)
        balance = wallet.balance.milliCoins
        transactions = wallet.entries

        errorMessage = nil
        
    }
    
    private func apply(
        amount: Int,
        direction: LedgerEntry.Direction,
        errorMessageText: String
    ) {
        print("🧠 VM: apply \(direction) \(amount)")
        
        isLoading = true
        
        do {
            let entry = try LedgerEntry(
                amount: CoinAmount(milliCoins: amount),
                direction: direction,
                createdAt: Date()
            )
            
            let wallet = try service.apply(entry, to: walletID)
            
            print("🧠 VM: updated wallet balance =", wallet.balance.milliCoins)
            
            updateState(with: wallet)
            
        } catch {
            print("❌ VM: apply failed")
            errorMessage = errorMessageText
        }
        
        isLoading = false
    }

    func addCredit(amount: Int) {
        apply(amount: amount, direction: .credit, errorMessageText: "Failed to add credit")
    }
    
    func addDebit(amount: Int) {
        apply(amount: amount, direction: .debit, errorMessageText: "Failed to add debit")
    }
}
