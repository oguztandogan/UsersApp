//
//  GetUsersUseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class GetUsersUseCase: GetUsersUseCaseProtocol {
    private let repository: UsersRepository

    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute(pageNumber: String) async throws -> UsersResponse {
        return try await repository.getUsers(pageNumber: pageNumber)
    }
}
