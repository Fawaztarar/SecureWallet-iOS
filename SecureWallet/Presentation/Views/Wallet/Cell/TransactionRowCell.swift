//
//  TransactionRowCell.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 22/03/2026.
//

import Foundation
import UIKit
import SecureWalletDomain

final class TransactionRowCell: UICollectionViewCell {
    
    static let identifier = "TransactionRowCell"
    
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        let container = UIStackView(arrangedSubviews: [icon, textStack, amountLabel])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        
        icon.backgroundColor = .white
        icon.layer.cornerRadius = 12
        icon.clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .white
        
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .lightGray
        
        amountLabel.font = .preferredFont(forTextStyle: .headline)
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with entry: LedgerEntry) {
        
        let isCredit = entry.direction == .credit
        
        titleLabel.text = isCredit ? "Bank Transfer" : "Card Payment"
        subtitleLabel.text = isCredit ? "Incoming payment" : "Apple Pay"
        
        let amount = CurrencyFormatter.shared.string(from: NSNumber(value: entry.amount.milliCoins)) ?? "£0.00"
        amountLabel.text = (isCredit ? "+" : "-") + amount
        amountLabel.textColor = isCredit ? .systemGreen : .white
        
        icon.image = UIImage(systemName: "creditcard.fill")
    }
}
