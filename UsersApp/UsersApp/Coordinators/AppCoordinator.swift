//
//  AppCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var window: UIWindow?

    init(navigationController: UINavigationController,
         window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        navigateToTabBar()
    }

    func navigateToTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, window: window!)
        childCoordinators.removeAll()
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.start()
    }
}
