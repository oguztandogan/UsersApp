//
//  CoreDataService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation
import CoreData

class CoreDataService: CoreDataServiceable, @unchecked Sendable {
    func saveContext() throws {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                throw error
            }
        }
    }

    func fetch<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        var fetchResults: [T] = []
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        try viewContext.performAndWait {
            do {
                fetchResults = try self.viewContext.fetch(request)
            } catch {
                throw error
            }
        }
        return fetchResults
    }

    func create<T: NSManagedObject>() -> T {
        let object = T(context: viewContext)
        return object
    }

    func delete(object: NSManagedObject) throws {
        try viewContext.performAndWait {
            self.viewContext.delete(object)
            do {
                try self.viewContext.save()
            } catch {
                throw error
            }
        }
    }
}
