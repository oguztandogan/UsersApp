//
//  TabDestination.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

enum TabDestination: Int, CaseIterable {
    case users = 0
    case bookmarks = 1
    var title: String {
        switch self {
        case .users: return "tab.users".localized
        case .bookmarks: return "tab.bookmarks".localized
        }
    }

    var iconName: String {
        switch self {
        case .users: return "person.3"
        case .bookmarks: return "heart.circle.fill"
        }
    }
}
