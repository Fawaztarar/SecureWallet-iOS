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

        container = NSPersistentContainer(
            name: modelName,
            managedObjectModel: CoreDataStack.sharedModel
        )

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
    }

    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
