//
//  TabConfiguration.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import Foundation
import UIKit

// MARK: - Tab Configuration Protocol
protocol TabConfigurable {
    var title: String { get }
    var iconName: String { get }
    var selectedIconName: String? { get }
    var badgeValue: String? { get }
    var isEnabled: Bool { get }
}

// MARK: - Tab Configuration Struct
struct TabConfiguration: TabConfigurable {
    let title: String
    let iconName: String
    let selectedIconName: String?
    let badgeValue: String?
    let isEnabled: Bool
    let coordinatorFactory: (UINavigationController) -> Coordinator
    
    init(title: String,
         iconName: String,
         selectedIconName: String? = nil,
         badgeValue: String? = nil,
         isEnabled: Bool = true,
         coordinatorFactory: @escaping (UINavigationController) -> Coordinator) {
        self.title = title
        self.iconName = iconName
        self.selectedIconName = selectedIconName
        self.badgeValue = badgeValue
        self.isEnabled = isEnabled
        self.coordinatorFactory = coordinatorFactory
    }
}

// MARK: - Tab Factory
class TabFactory {
    static func createDefaultTabConfigurations() -> [TabConfiguration] {
        return [
            TabConfiguration(
                title: "Users",
                iconName: "person.3",
                selectedIconName: "person.3.fill"
            ) { navigationController in
                return UsersListCoordinator(navigationController: navigationController)
            },
            
            TabConfiguration(
                title: "Bookmarks",
                iconName: "heart.circle",
                selectedIconName: "heart.circle.fill"
            ) { navigationController in
                return BookmarksCoordinator(navigationController: navigationController)
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

// MARK: - Tab Builder Protocol
protocol TabBuilder {
    func buildTabs(from configurations: [TabConfiguration], 
                  parentCoordinator: Coordinator) -> ([UINavigationController], [Coordinator])
}

// MARK: - Default Tab Builder
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
