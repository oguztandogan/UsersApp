//
//  BaseEndpoint.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

struct BaseEndpoint: EndpointProtocol, Sendable {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryParameters: [String: String]
    let body: Data?
    let timeoutInterval: TimeInterval
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:],
        body: Data? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers.merging(["Content-Type": "application/json"]) { current, _ in current }
        self.queryParameters = queryParameters
        self.body = body
        self.timeoutInterval = timeoutInterval
    }
}

extension BaseEndpoint {
    static func get(
        baseURL: String,
        path: String,
        queryParameters: [String: String] = [:],
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .GET,
            headers: headers,
            queryParameters: queryParameters,
            timeoutInterval: timeoutInterval
        )
    }

    static func post(
        baseURL: String,
        path: String,
        body: Data,
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .POST,
            headers: headers,
            body: body,
            timeoutInterval: timeoutInterval
        )
    }

    static func post<T: Encodable>(
        baseURL: String,
        path: String,
        body: T,
        encoder: JSONEncoder = JSONEncoder(),
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) throws -> BaseEndpoint {
        let bodyData = try encoder.encode(body)
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .POST,
            headers: headers,
            body: bodyData,
            timeoutInterval: timeoutInterval
        )
    }

    static func put(
        baseURL: String,
        path: String,
        body: Data,
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .PUT,
            headers: headers,
            body: body,
            timeoutInterval: timeoutInterval
        )
    }

    static func put<T: Encodable>(
        baseURL: String,
        path: String,
        body: T,
        encoder: JSONEncoder = JSONEncoder(),
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) throws -> BaseEndpoint {
        let bodyData = try encoder.encode(body)
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .PUT,
            headers: headers,
            body: bodyData,
            timeoutInterval: timeoutInterval
        )
    }

    static func delete(
        baseURL: String,
        path: String,
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .DELETE,
            headers: headers,
            timeoutInterval: timeoutInterval
        )
    }

    static func patch(
        baseURL: String,
        path: String,
        body: Data,
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .PATCH,
            headers: headers,
            body: body,
            timeoutInterval: timeoutInterval
        )
    }

    static func patch<T: Encodable>(
        baseURL: String,
        path: String,
        body: T,
        encoder: JSONEncoder = JSONEncoder(),
        headers: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) throws -> BaseEndpoint {
        let bodyData = try encoder.encode(body)
        return BaseEndpoint(
            baseURL: baseURL,
            path: path,
            method: .PATCH,
            headers: headers,
            body: bodyData,
            timeoutInterval: timeoutInterval
        )
    }
}

extension BaseEndpoint {
    static func withEnvironment(
        environment: APIEnvironment,
        path: String,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:],
        body: Data? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) -> BaseEndpoint {
        return BaseEndpoint(
            baseURL: environment.baseURL,
            path: path,
            method: method,
            headers: headers,
            queryParameters: queryParameters,
            body: body,
            timeoutInterval: timeoutInterval
        )
    }
}

// MARK: - API Environment

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
