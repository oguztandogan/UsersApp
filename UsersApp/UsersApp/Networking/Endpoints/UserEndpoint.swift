//
//  UserEndpoint.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Users API endpoints conforming to the new EndpointProtocol
enum UserEndpoint: EndpointProtocol, Sendable {
    case userList(page: String?, results: Int = 25)
    case userDetail(id: String)
    case createUser(userData: Data)
    case updateUser(id: String, userData: Data)
    case deleteUser(id: String)

    // MARK: - EndpointProtocol Implementation
    var baseURL: String {
        return Environment.current.baseURL
    }

    var path: String {
        switch self {
        case .userList:
            return "/api"
        case .userDetail(let id):
            return "/api/user/\(id)"
        case .createUser:
            return "/api/user"
        case .updateUser(let id, _):
            return "/api/user/\(id)"
        case .deleteUser(let id):
            return "/api/user/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userList, .userDetail:
            return .GET
        case .createUser:
            return .POST
        case .updateUser:
            return .PUT
        case .deleteUser:
            return .DELETE
        }
    }

    var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]

        switch self {
        case .createUser, .updateUser:
            headers["Accept"] = "application/json"
        default:
            break
        }

        return headers
    }

    var queryParameters: [String: String] {
        switch self {
        case .userList(let page, let results):
            var params = ["results": String(results)]
            if let page = page {
                params["page"] = page
            }
            return params
        default:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case .createUser(let userData), .updateUser(_, let userData):
            return userData
        default:
            return nil
        }
    }

    var timeoutInterval: TimeInterval {
        switch self {
        case .userList:
            return 15.0 // Shorter timeout for list requests
        case .createUser, .updateUser:
            return 30.0 // Longer timeout for data modification
        default:
            return 20.0 // Default timeout
        }
    }
}

// MARK: - Convenience Extensions
extension UserEndpoint {
    /// Creates a user list endpoint with page number
    static func userList(page: Int, results: Int = 25) -> UserEndpoint {
        return .userList(page: String(page), results: results)
    }

    /// Creates a user list endpoint for the first page
    static func firstPage(results: Int = 25) -> UserEndpoint {
        return .userList(page: "1", results: results)
    }
}

// MARK: - Request Builder Extensions
extension UserEndpoint {
    /// Creates a create user endpoint with encodable object
    static func createUser<T: Encodable>(user: T, encoder: JSONEncoder = JSONEncoder()) throws -> UserEndpoint {
        let userData = try encoder.encode(user)
        return .createUser(userData: userData)
    }

    /// Creates an update user endpoint with encodable object
    static func updateUser<T: Encodable>(
        id: String,
        user: T,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> UserEndpoint {
        let userData = try encoder.encode(user)
        return .updateUser(id: id, userData: userData)
    }
}
