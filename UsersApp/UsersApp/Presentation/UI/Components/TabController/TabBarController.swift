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
        tabBar.accessibilityIdentifier = "MainTabBar"
        setupDelegates()
        customizeTabBar()
    }

    private func setupDelegates() {
        delegate = self
    }

    private func customizeTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .appBackground

        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.appOnSurfaceVariant
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .appOnSurfaceVariant

        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .appPrimary
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

        addTabBarShadow()
    }

    private func addTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.masksToBounds = false

        tabBar.layer.shadowPath = UIBezierPath(
            rect: CGRect(
                x: 0,
                y: -8,
                width: tabBar.bounds.width,
                height: tabBar.bounds.height + 8
            )
        ).cgPath
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateTabBarShadowPath()
    }

    private func updateTabBarShadowPath() {
        tabBar.layer.shadowPath = UIBezierPath(
            rect: CGRect(
                x: 0,
                y: -8,
                width: tabBar.bounds.width,
                height: tabBar.bounds.height + 8
            )
        ).cgPath
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        return customDelegate?.tabBarController(tabBarController, shouldSelectTab: index) ?? true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        customDelegate?.tabBarController(tabBarController, didSelectTab: index)
    }
}
