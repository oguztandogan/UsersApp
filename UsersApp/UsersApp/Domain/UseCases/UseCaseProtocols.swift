//
//  UseCaseProtocols.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

// MARK: - Use Case Protocol Base
protocol UseCase {
    associatedtype Request
    associatedtype Response
    associatedtype Error: Swift.Error

    func execute(_ request: Request) async -> Result<Response, Error>
}

// MARK: - Specific Use Case Protocols
protocol GetUsersUseCaseProtocol {
    func execute(pageNumber: String) async -> Result<UsersResponse, DomainError>
}

protocol GetSavedUsersUseCaseProtocol {
    func execute() async -> Result<[UserEntity], DomainError>
}

protocol SaveUserUseCaseProtocol {
    func execute(_ user: UserEntity) async -> Result<Void, DomainError>
}

protocol DeleteUserUseCaseProtocol {
    func execute(userId: UUID) async -> Result<Void, DomainError>
}

protocol CheckUserSavedStatusUseCaseProtocol {
    func execute(userId: UUID) async -> Result<Bool, DomainError>
}
