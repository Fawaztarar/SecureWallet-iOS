//
//   InMemoryCoreDataStack.swift
//  SecureWalletDataTests
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData
@testable import SecureWalletData

final class InMemoryCoreDataStack: CoreDataStacking {
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    
    init(modelName: String = "SecureWallet") {

        let bundle = Bundle(for: CoreDataStack.self)

        guard
            let modelURL = bundle.url(forResource: modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load Core Data model: \(modelName)")
        }

        container = NSPersistentContainer(
            name: modelName,
            managedObjectModel: model
        )

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
    }
    
//    init(modelName: String = "SecureWallet") {
//        container = NSPersistentContainer(name: modelName)
//        
//        
//        //    Store Type
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        container.persistentStoreDescriptions = [description]
//        //    load store
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Failed to load in-memory store: \(error)")
//            }
//        }
//        
//        //     Configure Context
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.undoManager = nil
//    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
