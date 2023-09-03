//
//  GetUsersError.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

enum GetUsersError: Error, Hashable, Identifiable, Equatable, LocalizedError {
    var id: Self { self }
    
    case networkError(cause: String)
    case localStorageError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let cause):
            return cause
        case .localStorageError(let cause):
            return cause
        }
    }
}
