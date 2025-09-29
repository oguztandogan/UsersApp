//
//  CoreDataError.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 14.10.2025.
//

import Foundation

enum CoreDataError: Error {
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
    case notFound
}
