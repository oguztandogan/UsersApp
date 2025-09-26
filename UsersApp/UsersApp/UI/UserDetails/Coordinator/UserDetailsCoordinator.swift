//
//  UserDetailsCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UserDetailsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var userData: UserEntity

    init(navigationController: UINavigationController,
         userData: UserEntity) {
        self.navigationController = navigationController
        self.userData = userData
    }

    func start() {
        goToUserDetails()
    }

    deinit {
    }
}

extension UserDetailsCoordinator: UserDetailsNavigation {
    func goToUserDetails() {
        let userDetailsVC = UserDetailsViewController()
        let userDetailsViewModel = DependencyContainer.shared.makeUserDetailsViewModel(navigation: self, user: userData)
        userDetailsVC.viewModel = userDetailsViewModel
        customizeNavigationBar()
        navigationController.pushViewController(userDetailsVC, animated: true)
    }

    func goBackToHome() {
        navigationController.popToRootViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
