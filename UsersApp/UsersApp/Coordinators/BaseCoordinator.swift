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
