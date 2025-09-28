//
//  UsersNavigation.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

protocol UsersNavigation: AnyObject {
    func navigateToUserDetails(with user: UserEntity)
    func navigateToUserList()
}
