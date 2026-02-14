//
//   CoreDataStacking.swift
//  SecureWalletData
//
//  Created by Fawaz Tarar on 12/02/2026.
//

import Foundation
import CoreData

protocol CoreDataStacking {
    var context: NSManagedObjectContext { get }
    func save() throws
}
