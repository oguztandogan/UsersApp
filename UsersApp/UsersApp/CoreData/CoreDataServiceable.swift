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
    func saveContext() throws
    func fetchSavedItems() throws -> [SavedUser]
    func deleteItem(deletedTask: NSManagedObject) throws
}

extension CoreDataServiceable {
    var viewContext: NSManagedObjectContext {
        return PersistenceStore.shared.persistentContainer.viewContext
    }
}
