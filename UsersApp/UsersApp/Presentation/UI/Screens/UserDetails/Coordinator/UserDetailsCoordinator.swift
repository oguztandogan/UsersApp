//
//  UserDetailsCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UserDetailsCoordinator: NavigationCoordinator {
    typealias Destination = UserDetailsDestination
    typealias NavigationData = UserDetailsNavigationData
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

    deinit {}
}

extension UserDetailsCoordinator {
    func navigate(to destination: UserDetailsDestination, with data: UserDetailsNavigationData?) {
        switch destination {
        case .userDetails:
            goToUserDetails()
        case .editUser:
            navigateToEditUser(data: data)
        case .backToHome:
            goBackToHome()
        }
    }

    private func navigateToEditUser(data _: UserDetailsNavigationData?) {
        print("Navigate to edit user: \(userData.name, default: "")")
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

    func navigateToEditUser(with user: UserEntity) {
        navigate(to: .editUser, with: UserDetailsNavigationData(user: user))
    }
}
