//
//  BaseCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() where child === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground // Liste background ile aynı
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        
        // Remove default shadow/border
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        let proxy = UINavigationBar.appearance()
        proxy.tintColor = .appOnSurface
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
        proxy.compactAppearance = appearance
    }
}
