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
            do {
                let savedUsers: [SavedUser] = try coreDataService.fetch()
                continuation.resume(returning: .success(savedUsers))
            } catch {
                continuation.resume(returning: .failure(.fetchError(error.localizedDescription)))
            }
        }
    }

    func saveUser(_ user: UserEntity) async -> Result<Void, CoreDataError> {
        return await withCheckedContinuation { continuation in
            let managedContext = coreDataService.viewContext
            managedContext.perform {
                do {
                    let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
                    let existingUsers: [SavedUser] = try self.coreDataService.fetch(predicate: predicate)
                    
                    if existingUsers.isEmpty {
                        _ = self.mapper.mapToCoreData(user, context: managedContext)
                        try self.coreDataService.saveContext()
                        continuation.resume(returning: .success(()))
                    } else {
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
            do {
                let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let savedUsers: [SavedUser] = try coreDataService.fetch(predicate: predicate)
                guard let userToDelete = savedUsers.first else {
                    continuation.resume(returning: .failure(.notFound))
                    return
                }

                try coreDataService.delete(object: userToDelete)
                continuation.resume(returning: .success(()))
            } catch {
                continuation.resume(returning: .failure(.deleteError(error.localizedDescription)))
            }
        }
    }

    func isUserSaved(withId id: UUID) async -> Result<Bool, CoreDataError> {
        return await withCheckedContinuation { continuation in
            do {
                let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let savedUsers: [SavedUser] = try coreDataService.fetch(predicate: predicate)
                continuation.resume(returning: .success(!savedUsers.isEmpty))
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
