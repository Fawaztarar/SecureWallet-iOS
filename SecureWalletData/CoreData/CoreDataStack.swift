//
//  CoreDataStack.swift
//  SecureWalletData
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData

/// Responsibility:
/// - Owns and configures the NSPersistentContainer
/// - Loads the Core Data model
/// - Exposes a single working NSManagedObjectContext
/// - Provides controlled save() access
///
final class CoreDataStack: CoreDataStacking {
    
    private let container: NSPersistentContainer
//    private let container: NSPersistentCloudKitContainer

    
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

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            print("SQLite file URL:", storeDescription.url?.absoluteString ?? "nil")
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }


}
