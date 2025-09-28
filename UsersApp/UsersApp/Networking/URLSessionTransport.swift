//
//  URLSessionTransport.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

final class URLSessionTransport: NetworkTransportProtocol, Sendable {
    private let session: URLSession
    private let configuration: URLSessionConfiguration

    init(configuration: URLSessionConfiguration = .default) {
        self.configuration = configuration
        session = URLSession(configuration: configuration)
    }

    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            return (data, response)
        } catch let urlError as URLError {
            throw NetworkError.from(urlError: urlError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    deinit {
        session.invalidateAndCancel()
    }
}

extension URLSessionTransport {
    static func `default`() -> URLSessionTransport {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        config.requestCachePolicy = .useProtocolCachePolicy
        config.httpMaximumConnectionsPerHost = 4
        return URLSessionTransport(configuration: config)
    }

    static func background(identifier: String) -> URLSessionTransport {
        let config = URLSessionConfiguration.background(withIdentifier: identifier)
        config.timeoutIntervalForRequest = 60.0
        config.timeoutIntervalForResource = 300.0
        config.isDiscretionary = false
        config.shouldUseExtendedBackgroundIdleMode = true
        return URLSessionTransport(configuration: config)
    }

    static func ephemeral() -> URLSessionTransport {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 30.0
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSessionTransport(configuration: config)
    }

    static func withTimeout(request: TimeInterval, resource: TimeInterval) -> URLSessionTransport {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = request
        config.timeoutIntervalForResource = resource
        return URLSessionTransport(configuration: config)
    }
}
