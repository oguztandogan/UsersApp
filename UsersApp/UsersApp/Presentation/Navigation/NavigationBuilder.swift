//
//  NavigationBuilder.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit

protocol NavigationBuilder {
    func buildViewController(for destination: AppDestination) -> UIViewController?
    func buildCoordinator(for destination: AppDestination,
                          navigationController: UINavigationController) -> Coordinator?
}
