//
//  BalanceCardCell.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 20/03/2026.
//

import Foundation
import UIKit

final class BalanceCardCell: UICollectionViewCell {
    static let identifier = "BalanceCardCell"
    
    
//    Mark: UI Component
    
    private let cardView = UIView()
    private let balanceLabel = UILabel()
    private let titleLabel = UILabel()
    private let accountLabel = UILabel()
    
    
    private let topStack = UIStackView()
    
    private let addButton = makeActionButton(title: "Add money")
    private let spendButton = makeActionButton(title: "Spend money")
    
 
    var onAddTapped: (() -> Void)?
    var onSpendTapped: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    func setupView() {
        
        contentView.addSubview(cardView)
        cardView.addSubview(topStack)
        cardView.addSubview(accountLabel)
        cardView.addSubview(addButton)
        cardView.addSubview(spendButton)
  
        
        
        
        
        cardView.backgroundColor = .systemGreen
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.distribution = .equalSpacing
        topStack.translatesAutoresizingMaskIntoConstraints = false
       
        
        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(balanceLabel)
        
        titleLabel.text = "Wallet"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        balanceLabel.textColor = .white
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        balanceLabel.adjustsFontForContentSizeCategory = true
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.numberOfLines = 1
        
        accountLabel.text = "Account •••• 1234"
        accountLabel.numberOfLines = 1
        accountLabel.textColor = .white
        accountLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        accountLabel.adjustsFontForContentSizeCategory = true
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        spendButton.translatesAutoresizingMaskIntoConstraints = false
      

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        spendButton.addTarget(self, action: #selector(spendButtonTapped), for: .touchUpInside)
        
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            topStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            topStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            accountLabel.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 8),
            accountLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            accountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            addButton.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 12),
            addButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            addButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            spendButton.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 12),
            spendButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8),
            spendButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            spendButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            spendButton.widthAnchor.constraint(equalTo: addButton.widthAnchor),
            
           ])
    }
    
    func configure(balanceText: String, accountText: String) {
        balanceLabel.text = balanceText
        accountLabel.text = accountText
    }
    
    @objc private func addButtonTapped() {
        print("add button tapped")
        onAddTapped?()
        
    }
    
    @objc private func spendButtonTapped(){
        print("spend button tapped")
        onSpendTapped?()
    }
    
  
    
    private static func makeActionButton(title: String) -> UIButton {
        
        var config = UIButton.Configuration.filled()
        
        config.title = title
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
        
        config.cornerStyle = .capsule
        
        let button = UIButton(type: .system)
        button.configuration = config
        
        return button
    }
}
