//
//  TabFactory.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit

class TabFactory {
    static func createDefaultTabConfigurations() -> [TabConfiguration] {
        return [
            TabConfiguration(
                title: "tab.users".localized,
                iconName: "person.3",
                selectedIconName: "person.3.fill"
            ) { navigationController in
                UsersListCoordinator(navigationController: navigationController)
            },
            TabConfiguration(
                title: "tab.bookmarks".localized,
                iconName: "heart.circle",
                selectedIconName: "heart.circle.fill"
            ) { navigationController in
                BookmarksCoordinator(navigationController: navigationController)
            }
        ]
    }

    static func createTabBarItem(from configuration: TabConfiguration) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = configuration.title
        tabBarItem.image = UIImage(systemName: configuration.iconName)
        if let selectedIconName = configuration.selectedIconName {
            tabBarItem.selectedImage = UIImage(systemName: selectedIconName)
        }
        tabBarItem.badgeValue = configuration.badgeValue
        tabBarItem.isEnabled = configuration.isEnabled
        return tabBarItem
    }
}
