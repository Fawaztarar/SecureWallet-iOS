//
//  DemoWalletIDProvider.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import SecureWalletDomain

final class DemoWalletIDProvider: WalletIDProviding {
    func getWalletID() -> UUID {
        return UUID()
    }
}
