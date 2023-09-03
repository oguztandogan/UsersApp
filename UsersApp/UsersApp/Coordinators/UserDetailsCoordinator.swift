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
    var userData: User
//    lazy var userDetailsViewModel = UserDetailsViewModel(nav: self)

    init(navigationController: UINavigationController,
         userData: User) {
        self.navigationController = navigationController
        self.userData = userData
    }

    func start() {
        print("TransactionCoordinator Start")
        goToUserDetails()
    }

    deinit {
        print("TransactionCoordinator deinit")
    }
}

extension UserDetailsCoordinator: UserDetailsNavigation {
    func goToUserDetails() {
        let userDetailsVC = UserDetailsViewController()
        let userDetailsViewModel = UserDetailsViewModel(nav: self, user: userData)
        userDetailsVC.viewModel = userDetailsViewModel
        navigationController.pushViewController(userDetailsVC, animated: true)
    }

    func goBackToHome() {
        navigationController.popToRootViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
