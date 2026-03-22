//
//  CoreDataStack.swift
//  SecureWalletData
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData

public final class CoreDataStack: CoreDataStacking {

     static let sharedModel: NSManagedObjectModel = {
        let bundle = Bundle(for: CoreDataStack.self)

        guard
            let modelURL = bundle.url(forResource: "SecureWallet", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load Core Data model")
        }

        return model
    }()

    private let container: NSPersistentContainer

    public init(modelName: String = "SecureWallet", inMemory: Bool = false) {

        container = NSPersistentContainer(
            name: modelName,
            managedObjectModel: Self.sharedModel
        )

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
