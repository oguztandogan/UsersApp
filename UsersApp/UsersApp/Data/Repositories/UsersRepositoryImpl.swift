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

    func getUsers(pageNumber: String) async -> Result<UsersResponse, DomainError> {
        let result = await remoteDataSource.getUsers(pageNumber: pageNumber)

        switch result {
        case .success(let usersResponse):
            // Check which users are saved locally and update the isSaved flag
            var updatedUsers: [UserEntity] = []
            for user in usersResponse.users {
                let isUserSavedResult = await localDataSource.isUserSaved(withId: user.id)
                var updatedUser = user
                if case .success(let isSaved) = isUserSavedResult {
                    updatedUser.isSaved = isSaved
                }
                updatedUsers.append(updatedUser)
            }

            let finalResponse = UsersResponse(users: updatedUsers, info: usersResponse.info)
            return .success(finalResponse)
        case .failure(let error):
            return .failure(.networkError(error.localizedDescription))
        }
    }

    func getSavedUsers() async -> Result<[UserEntity], DomainError> {
        let result = await localDataSource.getSavedUsers()

        switch result {
        case .success(let savedUsers):
            let domainUsers = savedUsers.map { $0.toDomainEntity() }
            return .success(domainUsers)
        case .failure(let error):
            return .failure(.persistenceError(error.localizedDescription))
        }
    }

    func saveUser(_ user: UserEntity) async -> Result<Void, DomainError> {
        let result = await localDataSource.saveUser(user)

        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(.persistenceError(error.localizedDescription))
        }
    }

    func deleteUser(withId id: UUID) async -> Result<Void, DomainError> {
        let result = await localDataSource.deleteUser(withId: id)

        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(.persistenceError(error.localizedDescription))
        }
    }

    func isUserSaved(withId id: UUID) async -> Result<Bool, DomainError> {
        let result = await localDataSource.isUserSaved(withId: id)

        switch result {
        case .success(let isSaved):
            return .success(isSaved)
        case .failure(let error):
            return .failure(.persistenceError(error.localizedDescription))
        }
    }
}
