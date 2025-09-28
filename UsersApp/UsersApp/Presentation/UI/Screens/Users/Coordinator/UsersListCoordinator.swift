//
//  UsersListCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UsersListCoordinator: NavigationCoordinator {
    typealias Destination = UsersDestination
    typealias NavigationData = UserDetailsNavigationData
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userListVC = UsersListViewController()
        userListVC.viewModel = DependencyContainer.shared.makeUsersListViewModel(navigation: self)
        customizeNavigationBar()
        navigationController.pushViewController(userListVC, animated: true)
    }

    deinit {
        print("Deinit home coordinator")
    }
}

extension UsersListCoordinator {
    func navigate(to destination: UsersDestination, with data: UserDetailsNavigationData?) {
        switch destination {
        case .usersList:
            break
        case let .userDetails(user):
            navigateToUserDetails(with: user, data: data)
        case let .editUser(user):
            navigateToEditUser(with: user, data: data)
        }
    }

    private func navigateToUserDetails(with user: UserEntity, data _: UserDetailsNavigationData?) {
        let userDetailsCoordinator = UserDetailsCoordinator(
            navigationController: navigationController,
            userData: user
        )
        userDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(userDetailsCoordinator)
        userDetailsCoordinator.start()
    }

    private func navigateToEditUser(with user: UserEntity, data _: UserDetailsNavigationData?) {
        print("Navigate to edit user: \(user.name, default: "")")
    }
}

extension UsersListCoordinator: UsersNavigation {
    func navigateToUserDetails(with user: UserEntity) {
        navigate(to: .userDetails(user))
    }

    func navigateToUserList() {}
}
