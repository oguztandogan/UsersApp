////
////  BookmarksCoordinator.swift
////  UsersApp
////
////  Created by Oguz Tandogan on 3.09.2023.
////

import Foundation
import UIKit

class BookmarksCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = BookmarksViewModel(nav: self)
        let bookmarksVC = BookmarksViewController(viewModel: viewModel)
        navigationController.pushViewController(bookmarksVC, animated: true)
    }

    deinit {
        print("Deinit home coordinator")
    }
}

extension BookmarksCoordinator: BookmarksNavigation {}
