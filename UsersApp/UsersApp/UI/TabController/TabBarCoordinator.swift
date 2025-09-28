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
        
        // Store references
        self.tabBarController = tabBarController
        childCoordinators.append(contentsOf: coordinators)
        
        // Setup view controllers
        tabBarController.viewControllers = navigationControllers
        
        // Start coordinators
        coordinators.forEach { $0.start() }
        
        // Set as root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

// MARK: - NavigationCoordinator Implementation
extension TabBarCoordinator {
    func navigate(to destination: TabDestination, with data: TabNavigationData?) {
        guard let tabBarController = tabBarController else { return }
        
        let shouldAnimate = data?.shouldAnimate ?? false
        tabBarController.selectedIndex = destination.rawValue
        
        // Optional: Animate tab selection
        if shouldAnimate {
            UIView.transition(with: tabBarController.view,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil)
        }
    }
}

// MARK: - TabBarControllerDelegate
extension TabBarCoordinator: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelectTab index: Int) {
        guard let destination = TabDestination(rawValue: index) else { return }
        
        // Handle tab selection analytics or other logic
        print("Tab selected: \(destination.title)")
        
        // Notify parent coordinator if needed
        // parentCoordinator?.handleTabSelection(destination)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelectTab index: Int) -> Bool {
        // Add any logic to prevent tab selection if needed
        return true
    }
}

// MARK: - Tab Navigation Helpers
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
