//
//  MockWalletIDProvider.swift
//  SecureWalletTests3
//
//  Created by Fawaz Tarar on 19/03/2026.
//

import Foundation
import SecureWalletDomain

final class MockWalletIDProvider: WalletIDProviding {
    
    func getWalletID() -> UUID {
        return UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    }
}


