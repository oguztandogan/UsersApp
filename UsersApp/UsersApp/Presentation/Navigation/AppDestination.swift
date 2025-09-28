//
//  AppDestination.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//


enum AppDestination {
    case tabBar
    case usersList
    case userDetails(UserEntity)
    case bookmarks
    case editUser(UserEntity)
}