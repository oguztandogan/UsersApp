//
//  UsersRepository.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol UsersRepository {
    func getUsers(pageNumber: String) async -> Result<UsersResponse, DomainError>
    func getSavedUsers() async -> Result<[UserEntity], DomainError>
    func saveUser(_ user: UserEntity) async -> Result<Void, DomainError>
    func deleteUser(withId id: UUID) async -> Result<Void, DomainError>
    func isUserSaved(withId id: UUID) async -> Result<Bool, DomainError>
}

enum DomainError: Error {
    case networkError(String)
    case persistenceError(String)
    case unknownError(String)
}
