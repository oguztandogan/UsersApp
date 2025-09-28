////
////  BookmarksCoordinator.swift
////  UsersApp
////
////  Created by Oguz Tandogan on 3.09.2023.
////

import Foundation
import UIKit

class BookmarksCoordinator: NavigationCoordinator {
    typealias Destination = BookmarksDestination
    typealias NavigationData = UserNavigationData
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = DependencyContainer.shared.makeBookmarksViewModel(navigation: self)
        let bookmarksVC = BookmarksViewController()
        bookmarksVC.viewModel = viewModel
        customizeNavigationBar()
        navigationController.pushViewController(bookmarksVC, animated: true)
    }

    deinit {
        print("Deinit home coordinator")
    }
}

// MARK: - NavigationCoordinator Implementation
extension BookmarksCoordinator {
    func navigate(to destination: BookmarksDestination, with data: UserNavigationData?) {
        switch destination {
        case .bookmarksList:
            // Already at bookmarks list
            break
        case .bookmarkDetails(let user):
            navigateToBookmarkDetails(with: user, data: data)
        }
    }
    
    private func navigateToBookmarkDetails(with user: UserEntity, data: UserNavigationData?) {
        let userDetailsCoordinator = UserDetailsCoordinator(
            navigationController: navigationController,
            userData: user
        )
        userDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(userDetailsCoordinator)
        userDetailsCoordinator.start()
    }
}

// MARK: - BookmarksNavigation Implementation
extension BookmarksCoordinator: BookmarksNavigation {
    func navigateToBookmarks() {
        // Already at bookmarks
    }
    
    func navigateToBookmarkDetails(with bookmark: UserEntity) {
        navigate(to: .bookmarkDetails(bookmark))
    }
}
