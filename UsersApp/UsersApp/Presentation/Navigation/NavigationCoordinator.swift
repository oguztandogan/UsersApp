//
//  NavigationCoordinator.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation
import UIKit

protocol NavigationCoordinator: Coordinator {
    associatedtype Destination
    associatedtype NavigationData
    func navigate(to destination: Destination, with data: NavigationData?)
    func navigate(to destination: Destination)
}

extension NavigationCoordinator {
    func navigate(to destination: Destination) {
        navigate(to: destination, with: nil)
    }
}
