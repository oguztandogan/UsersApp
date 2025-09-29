//
//  TabNavigation.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

protocol TabNavigation: AnyObject {
    func switchToTab(_ tab: TabDestination)
    func navigateToUsersTab()
    func navigateToBookmarksTab()
}
