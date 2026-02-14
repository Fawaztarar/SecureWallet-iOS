//
//  CoreDataWalletStore.swift
//  SecureWalletData
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData
import SecureWalletDomain



final class CoreDataWalletStore: WalletStore {
    
    private let stack: CoreDataStacking
    
    init(stack: CoreDataStacking) {
        self.stack = stack
    }
    
//    Convert wallet → record
//    2️⃣ Fetch WalletEntity by record.walletID
//    3️⃣ If found → reuse it
//    4️⃣ If not found → create new WalletEntity
//    5️⃣ Delete all existing LedgerEntryEntity rows
//    6️⃣ Recreate from record.entries
//    7️⃣ Call stack.save()
    
    func save(_ wallet: Wallet) throws {

        let record = wallet.toRecord()

        // Fetch existing WalletEntity
        let request: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.walletID as CVarArg)

        let results: [WalletEntity]
        do {
            results = try stack.context.fetch(request)
        } catch {
            throw WalletStoreError.persistenceFailure
        }

        if results.count > 1 {
            throw WalletStoreError.persistenceFailure
        }

        let walletEntity: WalletEntity

        if let existing = results.first {
            walletEntity = existing
        } else {
            walletEntity = WalletEntity(context: stack.context)
            walletEntity.id = record.walletID
        }

        // Delete existing entries
        if let existingEntries = walletEntity.entries {
            for case let entry as LedgerEntryEntity in existingEntries {
                stack.context.delete(entry)
            }
        }

        // Recreate entries deterministically
        for (index, entry) in record.entries.enumerated() {

            let entity = LedgerEntryEntity(context: stack.context)
            entity.id = entry.id
            entity.milliCoins = Int64(entry.amount.milliCoins)
            entity.createdAt = entry.createdAt
            entity.orderIndex = Int64(index)

            switch entry.direction {
            case .credit:
                entity.direction = "credit"
            case .debit:
                entity.direction = "debit"
            @unknown default:
                throw WalletStoreError.persistenceFailure
            }

            entity.wallet = walletEntity
        }

        // Atomic save
        do {
            try stack.save()
        } catch {
            throw WalletStoreError.persistenceFailure
        }
    }


    
    func load(walletID: UUID) throws -> Wallet {

        // 1️⃣ Fetch WalletEntity
        let walletRequest: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        walletRequest.predicate = NSPredicate(format: "id == %@", walletID as CVarArg)

        let wallets: [WalletEntity]
        do {
            wallets = try stack.context.fetch(walletRequest)
        } catch {
            throw WalletStoreError.persistenceFailure
        }

        if wallets.count > 1 {
            throw WalletStoreError.persistenceFailure
        }

        guard let walletEntity = wallets.first else {
            throw WalletStoreError.walletNotFound
        }

        // 2️⃣ Fetch LedgerEntryEntity sorted by orderIndex ASC
        let entryRequest: NSFetchRequest<LedgerEntryEntity> = LedgerEntryEntity.fetchRequest()
        entryRequest.predicate = NSPredicate(format: "wallet == %@", walletEntity)
        entryRequest.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true)
        ]

        let entryEntities: [LedgerEntryEntity]
        do {
            entryEntities = try stack.context.fetch(entryRequest)
        } catch {
            throw WalletStoreError.persistenceFailure
        }

        // 3️⃣ Map to Domain LedgerEntry
        var entries: [LedgerEntry] = []
        entries.reserveCapacity(entryEntities.count)

        for entity in entryEntities {

            // Strict direction mapping
            let direction: LedgerEntry.Direction
            switch entity.direction {
            case "credit":
                direction = .credit
            case "debit":
                direction = .debit
            default:
                throw WalletStoreError.persistenceFailure
            }

            // Amount mapping
            let amount: CoinAmount
            do {
                amount = try CoinAmount(milliCoins: Int(entity.milliCoins))
            } catch {
                throw WalletStoreError.persistenceFailure
            }

            // Validate required fields (do NOT default silently)
            guard let id = entity.id else {
                throw WalletStoreError.persistenceFailure
            }

            guard let createdAt = entity.createdAt else {
                throw WalletStoreError.persistenceFailure
            }

            let entry = LedgerEntry(
                id: id,
                amount: amount,
                direction: direction,
                createdAt: createdAt
            )

            entries.append(entry)
        }

        // 4️⃣ Build record
        let record = WalletRecord(walletID: walletID, entries: entries)

        // 5️⃣ Rehydrate via Domain replay
        do {
            return try Wallet.fromRecord(record)
        } catch {
            throw WalletStoreError.persistenceFailure
        }
    }

    
}
