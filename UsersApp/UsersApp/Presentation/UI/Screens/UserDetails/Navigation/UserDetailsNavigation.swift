//
//  UserDetailsNavigation.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

protocol UserDetailsNavigation: AnyObject {
    func goToUserDetails()
    func goBackToHome()
    func navigateToEditUser(with user: UserEntity)
}
