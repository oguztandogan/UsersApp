//
//  CoreDataService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import CoreData

class CoreDataService {

    let viewContext = PersistenceStore.shared.persistentContainer.viewContext

    func saveContext () async throws {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                throw error
            }
        }
    }

    func fetchSavedItems() async throws -> [SavedUser] {
        let fetchRequest = NSFetchRequest<SavedUser>(entityName: String(describing: SavedUser.self))
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResults = try viewContext.fetch(fetchRequest)
            return fetchResults
        } catch {
            throw error
        }
    }

    func deleteItem(deletedTask: NSManagedObject) async throws {
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedUser")
        fetchedRequest.returnsObjectsAsFaults = false
        viewContext.delete(deletedTask)
        do {
            try await saveContext()
        } catch {
            throw error
        }
    }
}
