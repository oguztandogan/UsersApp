//
//  TabBarController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

protocol TabBarControllerDelegate: AnyObject {
    func tabBarController(_ tabBarController: UITabBarController, didSelectTab index: Int)
    func tabBarController(_ tabBarController: UITabBarController, shouldSelectTab index: Int) -> Bool
}

class TabBarController: UITabBarController {
    weak var customDelegate: TabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        customizeTabBar()
    }
    
    private func setupDelegates() {
        delegate = self
    }

    private func customizeTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .purple.withAlphaComponent(0.5)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .light)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        return customDelegate?.tabBarController(tabBarController, shouldSelectTab: index) ?? true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        customDelegate?.tabBarController(tabBarController, didSelectTab: index)
    }
}
