//
//  DeleteUserUseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    private let repository: UsersRepository

    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute(userId: UUID) async -> Result<Void, DomainError> {
        return await repository.deleteUser(withId: userId)
    }
}
