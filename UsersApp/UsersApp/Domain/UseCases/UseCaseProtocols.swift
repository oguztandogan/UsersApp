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

    func execute(_ request: Request) async throws -> Response
}

// MARK: - Specific Use Case Protocols
protocol GetUsersUseCaseProtocol {
    func execute(pageNumber: String) async throws -> UsersResponse
}

protocol GetSavedUsersUseCaseProtocol {
    func execute() async throws -> [UserEntity]
}

protocol SaveUserUseCaseProtocol {
    func execute(_ user: UserEntity) async throws
}

protocol DeleteUserUseCaseProtocol {
    func execute(userId: UUID) async throws
}

protocol CheckUserSavedStatusUseCaseProtocol {
    func execute(userId: UUID) async throws -> Bool
}
