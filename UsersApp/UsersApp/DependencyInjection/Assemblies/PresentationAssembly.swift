//
//  PresentationAssembly.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Swinject

class PresentationAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - ViewModels with Navigation
        container.register(UsersListViewModel.self) { (resolver, navigation: UsersNavigation) in
            UsersListViewModel(
                navigation: navigation,
                getUsersUseCase: resolver.resolve(GetUsersUseCaseProtocol.self)!,
                getSavedUsersUseCase: resolver.resolve(GetSavedUsersUseCaseProtocol.self)!,
                saveUserUseCase: resolver.resolve(SaveUserUseCaseProtocol.self)!,
                deleteUserUseCase: resolver.resolve(DeleteUserUseCaseProtocol.self)!
            )
        }

        container.register(BookmarksViewModel.self) { (resolver, navigation: BookmarksNavigation) in
            BookmarksViewModel(
                navigation: navigation,
                getSavedUsersUseCase: resolver.resolve(GetSavedUsersUseCaseProtocol.self)!,
                deleteUserUseCase: resolver.resolve(DeleteUserUseCaseProtocol.self)!
            )
        }

        // swiftlint:disable:next line_length
        container.register(UserDetailsViewModel.self) { (resolver, navigation: UserDetailsNavigation, user: UserEntity) in
            UserDetailsViewModel(
                navigation: navigation,
                user: user,
                saveUserUseCase: resolver.resolve(SaveUserUseCaseProtocol.self)!,
                deleteUserUseCase: resolver.resolve(DeleteUserUseCaseProtocol.self)!,
                getSavedUsersUseCase: resolver.resolve(GetSavedUsersUseCaseProtocol.self)!
            )
        }
    }
}
