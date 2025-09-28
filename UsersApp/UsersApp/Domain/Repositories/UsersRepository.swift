//
//  UsersRepository.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol UsersRepository {
    func getUsers(pageNumber: String) async throws -> UsersResponse
    func getSavedUsers() async throws -> [UserEntity]
    func saveUser(_ user: UserEntity) async throws
    func deleteUser(withId id: UUID) async throws
    func isUserSaved(withId id: UUID) async throws -> Bool
}

enum DomainError: Error {
    case networkError(String)
    case persistenceError(String)
    case unknownError(String)
}
