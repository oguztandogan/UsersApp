//
//  GetSavedUsersUseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class GetSavedUsersUseCase: GetSavedUsersUseCaseProtocol {
    private let repository: UsersRepository

    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute() async throws -> [UserEntity] {
        return try await repository.getSavedUsers()
    }
}
