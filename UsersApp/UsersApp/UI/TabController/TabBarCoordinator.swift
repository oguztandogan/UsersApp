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
        userListCoordinator.parentCoordinator = self

        let userListItem = UITabBarItem()
        userListItem.title = "Users"
        userListItem.image = UIImage.init(systemName: "person.3")
        userListNavigationController.tabBarItem = userListItem

        let bookmarksNavigationController = UINavigationController()
        let bookmarksCoordinator = BookmarksCoordinator.init(navigationController: bookmarksNavigationController)
        bookmarksCoordinator.parentCoordinator = self

        let bookmarksItem = UITabBarItem()
        bookmarksItem.title = "Bookmarks"
        bookmarksItem.image = UIImage.init(systemName: "heart.circle.fill")
        bookmarksNavigationController.tabBarItem = bookmarksItem
        childCoordinators.append(userListCoordinator)
        childCoordinators.append(bookmarksCoordinator)
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
