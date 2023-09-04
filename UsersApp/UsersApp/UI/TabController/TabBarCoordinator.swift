//
//  TabBarCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let window: UIWindow

    init(navigationController: UINavigationController,
         window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    func start() {
        initializeHomeTabBar()
    }

    func initializeHomeTabBar() {
        let tabbarController = TabBarController()

        let userListNavigationController = UINavigationController()
        let userListCoordinator = UsersListCoordinator.init(navigationController: userListNavigationController)
        userListCoordinator.parentCoordinator = parentCoordinator

        let userListItem = UITabBarItem()
        userListItem.title = "Users"
        userListItem.image = UIImage.init(systemName: "house.fill")
        userListNavigationController.tabBarItem = userListItem

        // Setup for profile tab
        let bookmarksNavigationController = UINavigationController()
        let bookmarksCoordinator = BookmarksCoordinator.init(navigationController: bookmarksNavigationController)
        bookmarksCoordinator.parentCoordinator = parentCoordinator

        let bookmarksItem = UITabBarItem()
        bookmarksItem.title = "Bookmarks"
        bookmarksItem.image = UIImage.init(systemName: "person.fill")
        bookmarksNavigationController.tabBarItem = bookmarksItem
        parentCoordinator?.childCoordinators.append(userListCoordinator)
        parentCoordinator?.childCoordinators.append(bookmarksCoordinator)
        userListCoordinator.start()
        bookmarksCoordinator.start()
        tabbarController.viewControllers = [
            userListNavigationController,
            bookmarksNavigationController
        ]
        window.rootViewController = tabbarController
        window.makeKeyAndVisible()
    }
}
