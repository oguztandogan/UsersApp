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
