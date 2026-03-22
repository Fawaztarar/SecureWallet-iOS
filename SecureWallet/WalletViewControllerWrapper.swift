//
//  WalletViewControllerWrapper.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import SwiftUI
import SecureWalletDomain

struct WalletViewControllerWrapper: UIViewControllerRepresentable {
    
    let container: AppContainer
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let service = WalletService(store: container.walletStore)
        let provider = WalletIDProvider()
        
        let vm = WalletViewModel(
            service: service,
            walletIDProvider: provider
        )
        
        return WalletViewController(viewModel: vm)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
