//
//  UsersRepositoryImpl.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class UsersRepositoryImpl: UsersRepository {
    private let remoteDataSource: UsersRemoteDataSourceProtocol
    private let localDataSource: UsersLocalDataSourceProtocol
    init(remoteDataSource: UsersRemoteDataSourceProtocol, localDataSource: UsersLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getUsers(pageNumber: String) async throws -> UsersResponse {
        do {
            let usersResponse = try await remoteDataSource.getUsers(pageNumber: pageNumber)

            var updatedUsers: [UserEntity] = []
            for user in usersResponse.users {
                do {
                    let isSaved = try await localDataSource.isUserSaved(withId: user.id)
                    var updatedUser = user
                    updatedUser.isSaved = isSaved
                    updatedUsers.append(updatedUser)
                } catch {
                    var updatedUser = user
                    updatedUser.isSaved = false
                    updatedUsers.append(updatedUser)
                }
            }
            return UsersResponse(users: updatedUsers, info: usersResponse.info)
        } catch let networkError as NetworkError {
            throw DomainError.networkError(networkError.localizedDescription)
        } catch {
            throw DomainError.networkError(error.localizedDescription)
        }
    }

    func getSavedUsers() async throws -> [UserEntity] {
        do {
            let savedUsers = try await localDataSource.getSavedUsers()
            return savedUsers.map { $0.toDomainEntity() }
        } catch let coreDataError as CoreDataError {
            throw DomainError.persistenceError(coreDataError.localizedDescription)
        } catch {
            throw DomainError.persistenceError(error.localizedDescription)
        }
    }

    func saveUser(_ user: UserEntity) async throws {
        do {
            try await localDataSource.saveUser(user)
        } catch let coreDataError as CoreDataError {
            throw DomainError.persistenceError(coreDataError.localizedDescription)
        } catch {
            throw DomainError.persistenceError(error.localizedDescription)
        }
    }

    func deleteUser(withId id: UUID) async throws {
        do {
            try await localDataSource.deleteUser(withId: id)
        } catch let coreDataError as CoreDataError {
            throw DomainError.persistenceError(coreDataError.localizedDescription)
        } catch {
            throw DomainError.persistenceError(error.localizedDescription)
        }
    }
}
