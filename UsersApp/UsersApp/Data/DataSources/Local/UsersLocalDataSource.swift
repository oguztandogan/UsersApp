//
//  UsersLocalDataSource.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import CoreData

protocol UsersLocalDataSourceProtocol {
    func getSavedUsers() async -> Result<[SavedUser], CoreDataError>
    func saveUser(_ user: UserEntity) async -> Result<Void, CoreDataError>
    func deleteUser(withId id: UUID) async -> Result<Void, CoreDataError>
    func isUserSaved(withId id: UUID) async -> Result<Bool, CoreDataError>
}

enum CoreDataError: Error {
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
    case notFound
}

class UsersLocalDataSource: UsersLocalDataSourceProtocol, @unchecked Sendable {
    private let coreDataService: CoreDataServiceable
    private let mapper: UserMapperProtocol

    init(coreDataService: CoreDataServiceable, mapper: UserMapperProtocol) {
        self.coreDataService = coreDataService
        self.mapper = mapper
    }

    func getSavedUsers() async -> Result<[SavedUser], CoreDataError> {
        return await withCheckedContinuation { continuation in
            let coreDataService = self.coreDataService
            do {
                let savedUsers = try coreDataService.fetchSavedItems()
                continuation.resume(returning: .success(savedUsers))
            } catch {
                continuation.resume(returning: .failure(.fetchError(error.localizedDescription)))
            }
        }
    }

    func saveUser(_ user: UserEntity) async -> Result<Void, CoreDataError> {
        return await withCheckedContinuation { continuation in
            let coreDataService = self.coreDataService
            let managedContext = coreDataService.viewContext
            managedContext.perform {
                do {
                    // Check if user already exists
                    let fetchRequest = NSFetchRequest<SavedUser>(entityName: "SavedUser")
                    fetchRequest.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
                    
                    let existingUsers = try managedContext.fetch(fetchRequest)
                    
                    if existingUsers.isEmpty {
                        // Create new SavedUser entity
                        _ = self.mapper.mapToCoreData(user, context: managedContext)
                        try coreDataService.saveContext()
                        continuation.resume(returning: .success(()))
                    } else {
                        // User already exists, no need to save again
                        continuation.resume(returning: .success(()))
                    }
                } catch {
                    continuation.resume(returning: .failure(.saveError(error.localizedDescription)))
                }
            }
        }
    }

    func deleteUser(withId id: UUID) async -> Result<Void, CoreDataError> {
        return await withCheckedContinuation { continuation in
            let coreDataService = self.coreDataService
            do {
                let savedUsers = try coreDataService.fetchSavedItems()
                guard let userToDelete = savedUsers.first(where: { $0.id == id }) else {
                    continuation.resume(returning: .failure(.notFound))
                    return
                }

                try coreDataService.deleteItem(deletedTask: userToDelete)
                continuation.resume(returning: .success(()))
            } catch {
                continuation.resume(returning: .failure(.deleteError(error.localizedDescription)))
            }
        }
    }

    func isUserSaved(withId id: UUID) async -> Result<Bool, CoreDataError> {
        return await withCheckedContinuation { continuation in
            let coreDataService = self.coreDataService
            do {
                let savedUsers = try coreDataService.fetchSavedItems()
                let isSaved = savedUsers.contains { $0.id == id }
                continuation.resume(returning: .success(isSaved))
            } catch {
                continuation.resume(returning: .failure(.fetchError(error.localizedDescription)))
            }
        }
    }
}

// MARK: - Core Data Entity to Domain Entity Mapper
extension SavedUser {
    func toDomainEntity() -> UserEntity {
        return UserMapper.mapFromCoreData(self)
    }
}
