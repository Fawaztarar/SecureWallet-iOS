//
//  CoreDataWalletStore.swift
//  SecureWalletData
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData
import SecureWalletDomain
import SecureWalletSecurity



public final class CoreDataWalletStore: WalletStore {
  
    
    private let stack: CoreDataStacking
    private let encryptionService: EncryptionService
    

    
    public init(stack: CoreDataStacking, encryptionService: EncryptionService) {
        self.stack = stack
        self.encryptionService = encryptionService
    }
    
    
    
    public func save(_ wallet: Wallet) throws {
        
        print("💾 Store: saving wallet with entries =", wallet.entries.count)

        
        // 1. Convert domain → record
        let record = wallet.toRecord()

        // 2. Encode → Data
        let rawData: Data

        rawData = try JSONEncoder().encode(record)
     

        // 3. Encrypt
        let encryptedData: Data
    
        encryptedData = try encryptionService.encrypt(rawData)
      
 

        // 4. Fetch existing wallet
        let entity = try fetchOrCreateEntity(for: wallet.id)
        // 5. Store encrypted payload
        entity.encryptedPayload = encryptedData

        // 6. Save
        do {
            try stack.save()
        } catch {
            throw WalletStoreError.persistenceFailure
        }
    }
    
    private func fetchOrCreateEntity(for id: UUID) throws -> WalletEntity {

        let request: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let results = try stack.context.fetch(request)

        if results.count > 1 {
            throw WalletStoreError.persistenceFailure
        }

        if let existing = results.first {
            return existing
        }

        let new = WalletEntity(context: stack.context)
        new.id = id
        return new
    }
    

    
    public func load(walletID: UUID) throws -> Wallet {
        
        
        print("💾 Store: loading wallet", walletID)

        // 1. Fetch WalletEntity
        let request: NSFetchRequest<WalletEntity> = WalletEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", walletID as CVarArg)

        let results: [WalletEntity]
        do {
            results = try stack.context.fetch(request)
        } catch {
            throw WalletStoreError.persistenceFailure
        }

        guard results.count == 1 else {
            throw WalletStoreError.walletNotFound
        }

        let entity = results[0]

     
        // 2. Get encrypted payload safely
        guard let encryptedData = entity.encryptedPayload else {
            throw WalletStoreError.persistenceFailure
        }

        // 3. Decrypt
        let decryptedData: Data
        do {
            decryptedData = try encryptionService.decrypt(encryptedData)
        } catch {
            throw WalletStoreError.persistenceFailure
        }
        
        // 4. Decode → WalletRecord
        let record: WalletRecord
        do {
            record = try JSONDecoder().decode(WalletRecord.self, from: decryptedData)
        } catch {
            throw WalletStoreError.persistenceFailure
        }

        // 5. Rebuild Wallet
        do {
            return try Wallet.fromRecord(record)
        } catch {
            throw WalletStoreError.persistenceFailure
        }
    }
    
}
