//
//  NetworkClientProtocol.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Main networking protocol that defines the interface for making API requests
/// This protocol is Sendable to ensure thread safety in Swift 6
protocol NetworkClientProtocol: Sendable {
    /// Performs a network request and returns the decoded response
    /// - Parameters:
    ///   - endpoint: The endpoint configuration
    ///   - responseType: The type to decode the response into
    /// - Returns: The decoded response or throws an error
    func request<T: Decodable & Sendable>(
        endpoint: EndpointProtocol,
        responseType: T.Type
    ) async throws -> T

    /// Performs a network request without expecting a response body
    /// - Parameter endpoint: The endpoint configuration
    /// - Throws: NetworkError if the request fails
    func requestVoid(endpoint: EndpointProtocol) async throws
}

/// Protocol for transport layer abstraction
/// Allows for easy testing and different implementations (URLSession, Mock, etc.)
protocol NetworkTransportProtocol: Sendable {
    /// Performs the actual network request
    /// - Parameter request: The URLRequest to execute
    /// - Returns: Data and URLResponse tuple
    /// - Throws: Error if the request fails
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
}

/// Protocol for request/response interceptors
/// Allows for middleware-like functionality (auth, logging, etc.)
protocol InterceptorProtocol: Sendable {
    /// Intercepts and potentially modifies a request before it's sent
    /// - Parameter request: The original request
    /// - Returns: The potentially modified request
    func intercept(request: URLRequest) async throws -> URLRequest

    /// Intercepts and potentially modifies a response after it's received
    /// - Parameters:
    ///   - data: The response data
    ///   - response: The URLResponse
    ///   - request: The original request
    /// - Returns: The potentially modified data
    func intercept(data: Data, response: URLResponse, for request: URLRequest) async throws -> Data
}

/// Protocol defining an API endpoint
protocol EndpointProtocol: Sendable {
    /// The base URL for the endpoint
    var baseURL: String { get }
    /// The path component of the URL
    var path: String { get }
    /// The HTTP method to use
    var method: HTTPMethod { get }
    /// HTTP headers to include in the request
    var headers: [String: String] { get }
    /// Query parameters to include in the URL
    var queryParameters: [String: String] { get }
    /// The request body (if any)
    var body: Data? { get }
    /// Request timeout interval
    var timeoutInterval: TimeInterval { get }
}

/// Extension providing default implementations for EndpointProtocol
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

    var timeoutInterval: TimeInterval {
        30.0
    }

    /// Builds the complete URL for the endpoint
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
