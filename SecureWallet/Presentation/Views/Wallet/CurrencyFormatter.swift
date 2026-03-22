//
//  CurrencyFormatter.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 21/03/2026.
//

import Foundation
enum CurrencyFormatter {
    
    static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GBP"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
