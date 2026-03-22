//
//  SecureWalletApp.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 04/02/2026.
//

import SwiftUI

@main
struct SecureWalletApp: App {
    
    
    let container = AppContainer()
    
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            WalletViewControllerWrapper(container: container)
        }
    }
}
