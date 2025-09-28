//
//  NavigationProtocols.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import Foundation
import UIKit

// MARK: - Generic Navigation Protocol
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

// MARK: - Navigation Result
enum NavigationResult {
    case success
    case failure(NavigationError)
}

enum NavigationError: Error {
    case invalidDestination
    case missingData
    case coordinatorNotFound
    case navigationControllerMissing
    
    var localizedDescription: String {
        switch self {
        case .invalidDestination:
            return "Invalid navigation destination"
        case .missingData:
            return "Required navigation data is missing"
        case .coordinatorNotFound:
            return "Target coordinator not found"
        case .navigationControllerMissing:
            return "Navigation controller is missing"
        }
    }
}

// MARK: - Safe Navigation Protocol
protocol SafeNavigationCoordinator: NavigationCoordinator {
    func safeNavigate(to destination: Destination, with data: NavigationData?) -> NavigationResult
    func safeNavigate(to destination: Destination) -> NavigationResult
}

extension SafeNavigationCoordinator {
    func safeNavigate(to destination: Destination) -> NavigationResult {
        return safeNavigate(to: destination, with: nil)
    }
}

// MARK: - Specific Navigation Protocols

// Users Navigation
protocol UsersNavigation: AnyObject {
    func navigateToUserDetails(with user: UserEntity)
    func navigateToUserList()
}

// Bookmarks Navigation
protocol BookmarksNavigation: AnyObject {
    func navigateToBookmarks()
    func navigateToBookmarkDetails(with bookmark: UserEntity)
}

// User Details Navigation - Simplified to avoid conflicts
protocol UserDetailsNavigation: AnyObject {
    func goToUserDetails()
    func goBackToHome()
    func navigateToEditUser(with user: UserEntity)
}

// Tab Navigation
protocol TabNavigation: AnyObject {
    func switchToTab(_ tab: TabDestination)
    func navigateToUsersTab()
    func navigateToBookmarksTab()
}

// MARK: - Navigation Destinations
enum AppDestination {
    case tabBar
    case usersList
    case userDetails(UserEntity)
    case bookmarks
    case editUser(UserEntity)
}

enum TabDestination: Int, CaseIterable {
    case users = 0
    case bookmarks = 1
    
    var title: String {
        switch self {
        case .users: return "Users"
        case .bookmarks: return "Bookmarks"
        }
    }
    
    var iconName: String {
        switch self {
        case .users: return "person.3"
        case .bookmarks: return "heart.circle.fill"
        }
    }
}

enum UsersDestination {
    case usersList
    case userDetails(UserEntity)
    case editUser(UserEntity)
}

enum BookmarksDestination {
    case bookmarksList
    case bookmarkDetails(UserEntity)
}

enum UserDetailsDestination {
    case userDetails
    case editUser
    case backToHome
}

// MARK: - Navigation Data Types
protocol NavigationData {}

struct UserNavigationData: NavigationData {
    let user: UserEntity
    let shouldAnimate: Bool
    let presentationStyle: PresentationStyle
    
    init(user: UserEntity, shouldAnimate: Bool = true, presentationStyle: PresentationStyle = .push) {
        self.user = user
        self.shouldAnimate = shouldAnimate
        self.presentationStyle = presentationStyle
    }
}

struct TabNavigationData: NavigationData {
    let tabIndex: Int
    let shouldAnimate: Bool
    
    init(tabIndex: Int, shouldAnimate: Bool = false) {
        self.tabIndex = tabIndex
        self.shouldAnimate = shouldAnimate
    }
}

enum PresentationStyle {
    case push
    case present
    case modal
    case fullScreen
}

// MARK: - Navigation Builder Protocol
protocol NavigationBuilder {
    func buildViewController(for destination: AppDestination) -> UIViewController?
    func buildCoordinator(for destination: AppDestination, 
                         navigationController: UINavigationController) -> Coordinator?
}
