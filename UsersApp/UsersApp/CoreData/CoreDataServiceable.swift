//
//  CoreDataServiceable.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import Foundation
import CoreData

protocol CoreDataServiceable {
    var viewContext: NSManagedObjectContext { get }
    func saveContext() async throws
    func fetchSavedItems() async throws -> [SavedUser]
    func deleteItem(deletedTask: NSManagedObject) async throws
}

extension CoreDataServiceable {
    var viewContext: NSManagedObjectContext {
        return PersistenceStore.shared.persistentContainer.viewContext
    }
}
