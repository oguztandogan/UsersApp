//
//  DependencyContainer.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Swinject

class DependencyContainer {
    static let shared = DependencyContainer()

    let assembler: Assembler

    private init() {
        assembler = Assembler([
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly()
        ])
    }

    // MARK: - Resolver Methods
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return assembler.resolver.resolve(serviceType)
    }

    // MARK: - ViewModel Factory Methods
    func makeUsersListViewModel(navigation: UserListNavigation) -> UsersListViewModel {
        return assembler.resolver.resolve(UsersListViewModel.self, argument: navigation)!
    }

    func makeBookmarksViewModel(navigation: BookmarksNavigation) -> BookmarksViewModel {
        return assembler.resolver.resolve(BookmarksViewModel.self, argument: navigation)!
    }

    func makeUserDetailsViewModel(navigation: UserDetailsNavigation, user: UserEntity) -> UserDetailsViewModel {
        return assembler.resolver.resolve(UserDetailsViewModel.self, arguments: navigation, user)!
    }
}

// MARK: - Container Configuration Extension
extension DependencyContainer {
    func configureDependencies() {
        // Bu method AppDelegate'de çağrılacak
        // Assembler zaten lazy olarak initialize ediliyor
        _ = assembler
        print("Swinject dependencies configured successfully")
    }

}
