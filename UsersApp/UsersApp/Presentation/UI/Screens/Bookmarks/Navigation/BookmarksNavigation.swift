//
//  BookmarksNavigation.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

protocol BookmarksNavigation: AnyObject {
    func navigateToBookmarks()
    func navigateToBookmarkDetails(with bookmark: UserEntity)
}
