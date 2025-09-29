//
//  TabBarCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class TabBarCoordinator: NavigationCoordinator {
    typealias Destination = TabDestination
    typealias NavigationData = TabNavigationData
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var window: UIWindow?
    private var tabBarController: TabBarController?
    private let tabBuilder: TabBuilder
    private let tabConfigurations: [TabConfiguration]
    init(navigationController: UINavigationController,
         window: UIWindow,
         tabBuilder: TabBuilder = DefaultTabBuilder(),
         tabConfigurations: [TabConfiguration] = TabFactory.createDefaultTabConfigurations()) {
        self.navigationController = navigationController
        self.window = window
        self.tabBuilder = tabBuilder
        self.tabConfigurations = tabConfigurations
    }

    func start() {
        setupTabBarController()
    }

    private func setupTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.customDelegate = self
        let (navigationControllers, coordinators) = tabBuilder.buildTabs(
            from: tabConfigurations,
            parentCoordinator: self
        )

        self.tabBarController = tabBarController
        childCoordinators.append(contentsOf: coordinators)

        tabBarController.viewControllers = navigationControllers

        coordinators.forEach { $0.start() }

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

extension TabBarCoordinator {
    func navigate(to destination: TabDestination, with data: TabNavigationData?) {
        guard let tabBarController = tabBarController else { return }
        let shouldAnimate = data?.shouldAnimate ?? false
        tabBarController.selectedIndex = destination.rawValue

        if shouldAnimate {
            UIView.transition(with: tabBarController.view,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
}

extension TabBarCoordinator: TabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelectTab index: Int) {
        guard let destination = TabDestination(rawValue: index) else { return }

        print("Tab selected: \(destination.title)")
    }

    func tabBarController(_: UITabBarController, shouldSelectTab _: Int) -> Bool {
        return true
    }
}

extension TabBarCoordinator: TabNavigation {
    func switchToTab(_ tab: TabDestination) {
        navigate(to: tab)
    }

    func navigateToUsersTab() {
        navigate(to: .users)
    }

    func navigateToBookmarksTab() {
        navigate(to: .bookmarks)
    }
}
