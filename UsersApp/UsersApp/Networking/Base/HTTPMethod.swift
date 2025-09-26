//
//  HTTPMethod.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// HTTP methods enum conforming to Sendable for Swift 6 compatibility
enum HTTPMethod: String, Sendable, CaseIterable {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
    case OPTIONS
}

/// Extension providing utility methods for HTTPMethod
extension HTTPMethod {
    /// Returns true if the method typically includes a request body
    var hasBody: Bool {
        switch self {
        case .POST, .PUT, .PATCH:
            return true
        case .GET, .DELETE, .HEAD, .OPTIONS:
            return false
        }
    }

    /// Returns true if the method is considered idempotent
    var isIdempotent: Bool {
        switch self {
        case .GET, .PUT, .DELETE, .HEAD, .OPTIONS:
            return true
        case .POST, .PATCH:
            return false
        }
    }
}
