//
//  WalletViewController.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 19/03/2026.
//

//
//  WalletViewController.swift
//  SecureWallet
//
//  Created by Fawaz Tarar on 19/03/2026.
//
////
//import Foundation
//import UIKit
//import Combine
//import SecureWalletDomain
//
//
//
//
//final class WalletViewController: UIViewController {
//    
//    private let viewModel: WalletViewModel
//    private var cancellables = Set<AnyCancellable>()
//    
//    // UI
//    private let balanceLabel = UILabel()
//    private let loadButton = UIButton(type: .system)
//    private let creditButton = UIButton(type: .system)
//    private let debitButton = UIButton(type: .system)
//    private let tableView = UITableView()
//    
//
//    private var dataSource: UITableViewDiffableDataSource<Section, LedgerEntry>!
//    
//    // MARK: - Init
//    
//    init(viewModel: WalletViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .black
//        
//        setupUI()
//        bindViewModel()
//        configureDataSource()
//        viewModel.loadWallet() // ✅ auto load
//    }
//    
//    private func configureDataSource() {
//        dataSource = UITableViewDiffableDataSource<Section, LedgerEntry>(
//            tableView: tableView
//        ) { tableView, indexPath, entry in
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            
//            let isCredit = entry.direction == .credit
//            let sign = isCredit ? "+" : "-"
//            
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//            
//            let time = formatter.string(from: entry.createdAt)
//            
//            cell.textLabel?.text = "\(sign)\(entry.amount.milliCoins) • \(time)"
//            cell.textLabel?.textColor = isCredit ? .systemGreen : .systemRed
//            cell.backgroundColor = .black
//            
//            return cell
//        }
//    }
//    
//    private func applySnapshot(entries: [LedgerEntry]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, LedgerEntry>()
//        
//        snapshot.appendSections([.main])
//        
//        let sorted = entries.sorted { $0.createdAt > $1.createdAt }
//        
//        snapshot.appendItems(sorted)
//        
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
//    
//    // MARK: - UI Setup
//    
//    private func setupUI() {
//        balanceLabel.textColor = .white
//        balanceLabel.font = .systemFont(ofSize: 28, weight: .bold)
//        balanceLabel.text = "Balance: 0"
//        
//        loadButton.setTitle("Load Wallet", for: .normal)
//        creditButton.setTitle("Add 500", for: .normal)
//        debitButton.setTitle("Spend 200", for: .normal)
//        
//        loadButton.addTarget(self, action: #selector(loadTapped), for: .touchUpInside)
//        creditButton.addTarget(self, action: #selector(addCreditTapped), for: .touchUpInside)
//        debitButton.addTarget(self, action: #selector(addDebitTapped), for: .touchUpInside)
//        
//        let stack = UIStackView(arrangedSubviews: [
//            balanceLabel,
//            loadButton,
//            creditButton,
//            debitButton
//        ])
//        
//        stack.axis = .vertical
//        stack.spacing = 16
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        // TableView
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .black
////        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        view.addSubview(stack)
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Bindings
//    
//    private func bindViewModel() {
//        
//        // Balance
//        viewModel.$balance
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] (balance: Int) in
//                self?.balanceLabel.text = "Balance: \(balance)"
//            }
//            .store(in: &cancellables)
//        
//        // Transactions
//        viewModel.$transactions
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
////                self?.tableView.reloadData()
//                self?.applySnapshot(entries: self?.viewModel.transactions ?? [])
//            }
//            .store(in: &cancellables)
//    }
//    
//    // MARK: - Actions
//    
//    @objc private func loadTapped() {
//        print("📱 VC: loadTapped")
//        viewModel.loadWallet()
//    }
//
//    @objc private func addCreditTapped() {
//        print("📱 VC: addCreditTapped +500")
//        viewModel.addCredit(amount: 500)
//    }
//
//    @objc private func addDebitTapped() {
//        print("📱 VC: addDebitTapped -200")
//        viewModel.addDebit(amount: 200)
//    }
//}
//
//// MARK: - TableView
//
////extension WalletViewController: UITableViewDataSource {
////    
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        viewModel.transactions.count
////    }
////    
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        
////        let entry = viewModel.transactions[indexPath.row]
////        
////        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
////        
////        let isCredit = entry.direction == .credit
////        let sign = isCredit ? "+" : "-"
////        
////        // Format time
////        let formatter = DateFormatter()
////        formatter.timeStyle = .short
////        
////        let time = formatter.string(from: entry.createdAt)
////        
////        cell.textLabel?.text = "\(sign)\(entry.amount.milliCoins) • \(time)"
////        cell.textLabel?.textColor = isCredit ? .systemGreen : .systemRed
////        cell.backgroundColor = .black
////        
////        return cell
////    }
////}
