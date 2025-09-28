//
//  DomainAssembly.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Swinject

class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetUsersUseCaseProtocol.self) { resolver in
            GetUsersUseCase(repository: resolver.resolve(UsersRepository.self)!)
        }
        container.register(GetSavedUsersUseCaseProtocol.self) { resolver in
            GetSavedUsersUseCase(repository: resolver.resolve(UsersRepository.self)!)
        }
        container.register(SaveUserUseCaseProtocol.self) { resolver in
            SaveUserUseCase(repository: resolver.resolve(UsersRepository.self)!)
        }
        container.register(DeleteUserUseCaseProtocol.self) { resolver in
            DeleteUserUseCase(repository: resolver.resolve(UsersRepository.self)!)
        }
    }
}
