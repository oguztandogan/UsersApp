//
//  DeleteUserUseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol DeleteUserUseCaseProtocol {
    func execute(userId: UUID) async throws
}

class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    private let repository: UsersRepository
    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute(userId: UUID) async throws {
        try await repository.deleteUser(withId: userId)
    }
}
