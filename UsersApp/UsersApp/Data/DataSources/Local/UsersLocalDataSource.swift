//
//  UsersLocalDataSource.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import CoreData

protocol UsersLocalDataSourceProtocol {
    func getSavedUsers() async throws -> [SavedUser]
    func saveUser(_ user: UserEntity) async throws
    func deleteUser(withId id: UUID) async throws
    func isUserSaved(withId id: UUID) async throws -> Bool
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

    func getSavedUsers() async throws -> [SavedUser] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let savedUsers: [SavedUser] = try coreDataService.fetch()
                continuation.resume(returning: savedUsers)
            } catch {
                continuation.resume(throwing: CoreDataError.fetchError(error.localizedDescription))
            }
        }
    }

    func saveUser(_ user: UserEntity) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let managedContext = coreDataService.viewContext
            managedContext.perform {
                do {
                    let predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
                    let existingUsers: [SavedUser] = try self.coreDataService.fetch(predicate: predicate)
                    
                    if existingUsers.isEmpty {
                        _ = self.mapper.mapToCoreData(user, context: managedContext)
                        try self.coreDataService.saveContext()
                        continuation.resume(returning: ())
                    } else {
                        continuation.resume(returning: ())
                    }
                } catch {
                    continuation.resume(throwing: CoreDataError.saveError(error.localizedDescription))
                }
            }
        }
    }

    func deleteUser(withId id: UUID) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let savedUsers: [SavedUser] = try coreDataService.fetch(predicate: predicate)
                guard let userToDelete = savedUsers.first else {
                    continuation.resume(throwing: CoreDataError.notFound)
                    return
                }

                try coreDataService.delete(object: userToDelete)
                continuation.resume(returning: ())
            } catch {
                continuation.resume(throwing: CoreDataError.deleteError(error.localizedDescription))
            }
        }
    }

    func isUserSaved(withId id: UUID) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let savedUsers: [SavedUser] = try coreDataService.fetch(predicate: predicate)
                continuation.resume(returning: !savedUsers.isEmpty)
            } catch {
                continuation.resume(throwing: CoreDataError.fetchError(error.localizedDescription))
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
