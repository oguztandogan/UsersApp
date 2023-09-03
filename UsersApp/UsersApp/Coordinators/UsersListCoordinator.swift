//
//  UsersListCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UsersListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userListVC = UsersListViewController()
        userListVC.viewModel = UsersListViewModel(nav: self)
        navigationController.pushViewController(userListVC, animated: true)
    }

    deinit {
        print("Deinit home coordinator")
    }
}

extension UsersListCoordinator: UserListNavigation {
    func navigateToUserDetails(selectedUserData: User) {
        let userDetailsCoordinator = UserDetailsCoordinator(navigationController: navigationController, userData: selectedUserData)
        userDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(userDetailsCoordinator)
        userDetailsCoordinator.start()
    }
}
