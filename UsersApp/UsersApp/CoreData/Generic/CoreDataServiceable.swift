
import Foundation
import CoreData

protocol CoreDataServiceable: Sendable {
    var viewContext: NSManagedObjectContext { get }

    func saveContext() throws
    func fetch<T: NSManagedObject>(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) throws -> [T]
    func create<T: NSManagedObject>() -> T
    func delete(object: NSManagedObject) throws
}

extension CoreDataServiceable {
    var viewContext: NSManagedObjectContext {
        return PersistenceStore.shared.persistentContainer.viewContext
    }

    func fetch<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        try fetch(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}
