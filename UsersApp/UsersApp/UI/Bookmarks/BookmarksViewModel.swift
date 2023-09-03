//
//  BookmarksViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol BookmarksNavigation : AnyObject {}

class BookmarksViewModel {
    weak var navigation : BookmarksNavigation!

    init(nav : BookmarksNavigation) {
        self.navigation = nav
    }
}
