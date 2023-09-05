//
//  CoreDataService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import CoreData

class CoreDataService: CoreDataServiceable {
    func saveContext() throws {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                throw error
            }
        }
    }

    func fetchSavedItems() throws -> [SavedUser] {
        var fetchResults: [SavedUser] = []
        try viewContext.performAndWait {
            let fetchRequest = NSFetchRequest<SavedUser>(entityName: String(describing: SavedUser.self))
            do {
                fetchResults = try self.viewContext.fetch(fetchRequest)
            } catch {
                throw error
            }
        }
        return fetchResults
    }

    func deleteItem(deletedTask: NSManagedObject) throws {
        try viewContext.performAndWait {
            self.viewContext.delete(deletedTask)
            do {
                try self.viewContext.save()
            } catch {
                throw error
            }
        }
    }
}
