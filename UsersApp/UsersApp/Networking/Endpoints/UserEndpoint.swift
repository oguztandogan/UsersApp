//
//  UserEndpoint.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

enum UserEndpoint: EndpointProtocol, Sendable {
    case userList(page: String?, results: Int = 25)
    case userDetail(id: String)
    var baseURL: String {
        return Environment.current.baseURL
    }

    var path: String {
        switch self {
        case .userList:
            return "/api"
        case let .userDetail(id):
            return "/api/user/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userList, .userDetail:
            return .GET
        }
    }

    var headers: [String: String] {
        let headers = ["Content-Type": "application/json"]
        return headers
    }

    var queryParameters: [String: String] {
        switch self {
        case let .userList(page, results):
            var params = ["results": String(results)]
            if let page = page {
                params["page"] = page
            }
            return params
        default:
            return [:]
        }
    }

    var timeoutInterval: TimeInterval {
        return 15.0
    }
}

extension UserEndpoint {
    static func userList(page: Int, results: Int = 25) -> UserEndpoint {
        return .userList(page: String(page), results: results)
    }

    static func firstPage(results: Int = 25) -> UserEndpoint {
        return .userList(page: "1", results: results)
    }
}
