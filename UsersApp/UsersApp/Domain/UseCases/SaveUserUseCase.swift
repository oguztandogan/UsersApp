//
//  SaveUserUseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class SaveUserUseCase: SaveUserUseCaseProtocol {
    private let repository: UsersRepository

    init(repository: UsersRepository) {
        self.repository = repository
    }

    func execute(_ user: UserEntity) async throws {
        try await repository.saveUser(user)
    }
}
