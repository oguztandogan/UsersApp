//
//  EndpointProtocol.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

protocol EndpointProtocol: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    var body: Data? { get }
    var timeoutInterval: TimeInterval { get }
}

extension EndpointProtocol {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var queryParameters: [String: String] {
        [:]
    }

    var body: Data? {
        nil
    }

    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        if !queryParameters.isEmpty {
            components?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        return components?.url
    }
}
