//
//  APIEnvironment.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//


enum APIEnvironment: String, Sendable, CaseIterable {
    case development = "dev"
    case staging
    case production = "prod"

    var baseURL: String {
        switch self {
        case .development:
            return "https://randomuser.me"
        case .staging:
            return "https://randomuser.me"
        case .production:
            return "https://randomuser.me"
        }
    }
}
