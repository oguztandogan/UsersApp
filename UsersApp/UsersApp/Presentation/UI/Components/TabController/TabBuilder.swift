//
//  TabBuilder.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit

protocol TabBuilder {
    func buildTabs(from configurations: [TabConfiguration],
                   parentCoordinator: Coordinator) -> ([UINavigationController], [Coordinator])
}

class DefaultTabBuilder: TabBuilder {
    func buildTabs(from configurations: [TabConfiguration],
                   parentCoordinator: Coordinator) -> ([UINavigationController], [Coordinator]) {
        var navigationControllers: [UINavigationController] = []
        var coordinators: [Coordinator] = []
        for configuration in configurations {
            let navigationController = UINavigationController()
            let coordinator = configuration.coordinatorFactory(navigationController)
            coordinator.parentCoordinator = parentCoordinator
            let tabBarItem = TabFactory.createTabBarItem(from: configuration)
            navigationController.tabBarItem = tabBarItem
            navigationControllers.append(navigationController)
            coordinators.append(coordinator)
        }
        return (navigationControllers, coordinators)
    }
}
