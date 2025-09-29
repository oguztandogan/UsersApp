import Foundation
import UIKit

class BookmarksCoordinator: NavigationCoordinator {
    typealias Destination = BookmarksDestination
    typealias NavigationData = UserDetailsNavigationData
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

extension BookmarksCoordinator {
    func navigate(to destination: BookmarksDestination, with data: UserDetailsNavigationData?) {
        switch destination {
        case .bookmarksList:
            break
        case let .bookmarkDetails(user):
            navigateToBookmarkDetails(with: user, data: data)
        }
    }

    private func navigateToBookmarkDetails(with user: UserEntity, data _: UserDetailsNavigationData?) {
        let userDetailsCoordinator = UserDetailsCoordinator(
            navigationController: navigationController,
            userData: user
        )
        userDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(userDetailsCoordinator)
        userDetailsCoordinator.start()
    }
}

extension BookmarksCoordinator: BookmarksNavigation {
    func navigateToBookmarks() {}

    func navigateToBookmarkDetails(with bookmark: UserEntity) {
        navigate(to: .bookmarkDetails(bookmark))
    }
}
