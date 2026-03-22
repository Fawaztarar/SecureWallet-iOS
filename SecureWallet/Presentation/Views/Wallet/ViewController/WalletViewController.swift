//
//  WalletViewController.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 20/03/2026.
//

//
//  WalletViewController.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 20/03/2026.
//

import Foundation
import UIKit
import Combine
import SecureWalletDomain

final class WalletViewController: UIViewController {
    
    private let viewModel: WalletViewModel
    private var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    
  
    
    
    private var dataSource: UICollectionViewDiffableDataSource<WalletSection, WalletItem>!
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        registerCell()
        configureDataSource() 
        bindViewModel()
        viewModel.loadWallet()
    }
}

// MARK: - Setup

private extension WalletViewController {
    
    func setupCollectionView() {
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: WalletLayoutFactory.makeLayout()
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        collectionView.dataSource = self
    }
    
    func registerCell() {
        
        // Balance
        collectionView.register(
            BalanceCardCell.self,
            forCellWithReuseIdentifier: BalanceCardCell.identifier
        )
        
        // Transaction Row (ONLY cell for transactions)
        collectionView.register(
            TransactionRowCell.self,
            forCellWithReuseIdentifier: TransactionRowCell.identifier
        )
        
        // Header (date)
        collectionView.register(
            TransactionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TransactionHeaderView.identifier
        )
    }
}

// MARK: - Binding

private extension WalletViewController {
    
  
    func bindViewModel() {
        
        Publishers.CombineLatest(
            viewModel.$balance,
            viewModel.$transactions
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] balance, transactions in
            self?.applySnapshot(balance: balance, transactions: transactions)
        }
        .store(in: &cancellables)
    }
}

private extension WalletViewController {
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<WalletSection, WalletItem>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            
            switch item {
                
            case .balance(let balance):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BalanceCardCell.identifier,
                    for: indexPath
                ) as! BalanceCardCell
                
                guard let self else { return cell }
                
                cell.configure(
                    balanceText: self.formatBalance(balance),
                    accountText: "Account •••• 1234"
                )
                
                cell.onAddTapped = { [weak self] in
                    self?.viewModel.addCredit(amount: 500)
                }
                
                cell.onSpendTapped = { [weak self] in
                    self?.viewModel.addDebit(amount: 200)
                }
                
                return cell
                
            case .transaction(let entry):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TransactionRowCell.identifier,
                    for: indexPath
                ) as! TransactionRowCell
                
                cell.configure(with: entry)
                return cell
            }
        }
        
        // ✅ THIS is where your code goes
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
            guard kind == UICollectionView.elementKindSectionHeader,
                  let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else {
                return nil
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TransactionHeaderView.identifier,
                for: indexPath
            ) as! TransactionHeaderView
            
            switch section {
            case .balance:
                header.isHidden = true
                
            case .day(let day):
                header.configure(title: day.title)
            }
            
            return header
        }
    }
}


extension WalletViewController {
    private func applySnapshot(balance: Int, transactions: [LedgerEntry]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<WalletSection, WalletItem>()
        
        // 1️⃣ Balance section
        snapshot.appendSections([.balance])
        snapshot.appendItems([.balance(balance)], toSection: .balance)
        
        // 2️⃣ Group transactions by day
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) {
            calendar.startOfDay(for: $0.createdAt)
        }
        
        let sortedDays = grouped.sorted { $0.key > $1.key }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        
        for (date, entries) in sortedDays {
            
            let section = DaySection(
                date: date,
                title: formatter.string(from: date)
            )
            
            let sectionID = WalletSection.day(section)
            
            snapshot.appendSections([sectionID])
            
            // Sort entries inside the day
            let sortedEntries = entries.sorted { $0.createdAt > $1.createdAt }
            
            let items = sortedEntries.map { WalletItem.transaction($0) }
            
            snapshot.appendItems(items, toSection: sectionID)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - DataSource

//extension WalletViewController: UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        switch WalletSection(rawValue: section)! {
//        case .balance:
//            return 1
//            
//        case .transactions:
//            return sections.count // ✅ one card per day
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        switch WalletSection(rawValue: indexPath.section)! {
//            
//        case .balance:
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: BalanceCardCell.identifier,
//                for: indexPath
//            ) as! BalanceCardCell
//            
//            cell.configure(
//                balanceText: formatBalance(viewModel.balance),
//                accountText: "Account •••• 1234"
//            )
//            
//            cell.onAddTapped = { [weak self] in
//                self?.viewModel.addCredit(amount: 500)
//            }
//            
//            cell.onSpendTapped = { [weak self] in
//                self?.viewModel.addDebit(amount: 200)
//            }
//            
//            return cell
//            
//        case .transactions:
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: TransactionCardCell.identifier,
//                for: indexPath
//            ) as! TransactionCardCell
//            
//            let section = sections[indexPath.item]
//            
//            cell.configure(
//                date: section.date,
//                entries: section.entries
//            )
//            
//            return cell
//        }
//    }
//}

// MARK: - Helpers

private extension WalletViewController {
    
    private func formatBalance(_ balance: Int) -> String {
        return CurrencyFormatter.shared.string(from: NSNumber(value: balance)) ?? "£0.00"
    }
    
 
}
