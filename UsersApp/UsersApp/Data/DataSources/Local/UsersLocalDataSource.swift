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

    init(coreDataService: CoreDataServiceable) {
        self.coreDataService = coreDataService
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
                let newUser = SavedUser(context: managedContext)
                newUser.id = user.id
                newUser.userName = user.fullName
                newUser.userAge = user.dateOfBirth?.age?.description
                newUser.userNationality = user.nationality
                newUser.userPictureUrl = user.picture?.medium

                do {
                    try coreDataService.saveContext()
                    continuation.resume(returning: .success(()))
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
        return UserEntity(
            id: id ?? UUID(),
            gender: nil,
            name: UserName(title: nil, first: userName, last: nil),
            dateOfBirth: UserDateOfBirth(date: nil, age: Int(userAge ?? "")),
            phone: nil,
            picture: UserPicture(large: nil, medium: userPictureUrl, thumbnail: nil),
            nationality: userNationality,
            isSaved: true
        )
    }
}
