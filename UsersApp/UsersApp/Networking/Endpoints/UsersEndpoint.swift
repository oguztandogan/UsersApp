//
//  UsersEndpoint.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation

enum UsersEndpoint {
    case userList(String?)
}

extension UsersEndpoint: Endpoint {
    var path: String {
        switch self {
        case .userList:
            return "/api"
        }
    }

    var method: RequestMethod {
        switch self {
        case .userList:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .userList:
            return [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    var queries: [URLQueryItem]? {
        switch self {
        case .userList(let pageNumber):
            return [
                URLQueryItem(name: "results", value: "25"),
                URLQueryItem(name: "page", value: pageNumber)
            ]
        }
    }

    var body: [String: String]? {
        switch self {
        case .userList:
            return nil
        }
    }
}
