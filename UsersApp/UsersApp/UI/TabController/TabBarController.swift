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
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .appBackground // Liste background ile aynı
        
        // Normal state (unselected)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.appOnSurfaceVariant
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .appOnSurfaceVariant
        
        // Selected state
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .appPrimary
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        // Add shadow to TabBar
        addTabBarShadow()
    }
    
    private func addTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.masksToBounds = false
        
        // Create shadow path for better performance
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
        // Update shadow path when layout changes
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
