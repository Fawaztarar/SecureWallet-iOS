//
//  TransactionCardCell.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 21/03/2026.
//
//
//import Foundation
//import UIKit
//import SecureWalletDomain
//
//final class TransactionCardCell: UICollectionViewCell {
//    
//    static let identifier = "TransactionCardCell"
//    
//    // MARK: - UI
//    
//    private let cardView = UIView()
//    private let stack = UIStackView()
//    private let dateLabel = UILabel()
//    
//    // MARK: - Init
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    // MARK: - Setup
//    
//    private func setup() {
//        
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
//        
//        // Card
//        cardView.backgroundColor = UIColor(white: 0.12, alpha: 1)
//        cardView.layer.cornerRadius = 20
//        cardView.clipsToBounds = true
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        
//        contentView.addSubview(cardView)
//        
//        // Stack
//        stack.axis = .vertical
//        stack.spacing = 0
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        cardView.addSubview(stack)
//        
//        // Date label
//        dateLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        dateLabel.textColor = .lightGray
//        
//        let dateContainer = UIView()
//        dateContainer.addSubview(dateLabel)
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            dateLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 16),
//            dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 16),
//            dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -16),
//            dateLabel.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: -8)
//        ])
//        
//        stack.addArrangedSubview(dateContainer)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            stack.topAnchor.constraint(equalTo: cardView.topAnchor),
//            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Configure
//    
//    func configure(date: String, entries: [LedgerEntry]) {
//        
//        dateLabel.text = date
//        
//        // Remove old rows (reuse safe)
//        stack.arrangedSubviews.dropFirst().forEach {
//            stack.removeArrangedSubview($0)
//            $0.removeFromSuperview()
//        }
//        
//        for (index, entry) in entries.enumerated() {
//            
//            let row = TransactionRowView()
//            row.configure(with: entry)
//            
//            stack.addArrangedSubview(row)
//            
//            // Divider 
//            if index != entries.count - 1 {
//                stack.addArrangedSubview(makeDivider())
//            }
//        }
//    }
//    
//    private func makeDivider() -> UIView {
//        let view = UIView()
//        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            view.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//        
//        return view
//    }
//}
