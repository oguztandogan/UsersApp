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

final class MockTransport: NetworkTransportProtocol, Sendable {
    private let mockResponses: [String: (Data, URLResponse)]
    init(mockResponses: [String: (Data, URLResponse)] = [:]) {
        self.mockResponses = mockResponses
    }

    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url?.absoluteString,
              let mockResponse = mockResponses[url]
        else {
            throw NetworkError.notFound
        }

        try await Task.sleep(nanoseconds: 100_000_000)
        return mockResponse
    }
}

final class NetworkMonitorTransport: NetworkTransportProtocol, Sendable {
    private let baseTransport: NetworkTransportProtocol
    private let monitor: NetworkMonitor
    init(baseTransport: NetworkTransportProtocol, monitor: NetworkMonitor) {
        self.baseTransport = baseTransport
        self.monitor = monitor
    }

    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let startTime = Date()
        monitor.requestStarted(request)
        do {
            let result = try await baseTransport.performRequest(request)
            let duration = Date().timeIntervalSince(startTime)
            monitor.requestCompleted(request, duration: duration, response: result.1)
            return result
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            monitor.requestFailed(request, duration: duration, error: error)
            throw error
        }
    }
}

protocol NetworkMonitor: Sendable {
    func requestStarted(_ request: URLRequest)
    func requestCompleted(
        _ request: URLRequest,
        duration: TimeInterval,
        response: URLResponse
    )
    func requestFailed(
        _ request: URLRequest,
        duration: TimeInterval,
        error: Error
    )
}

final class DefaultNetworkMonitor: NetworkMonitor, Sendable {
    private let logger: Logger
    init(logger: Logger = DefaultLogger()) {
        self.logger = logger
    }

    func requestStarted(_ request: URLRequest) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "unknown"
        logger.log("🌐 Network request started: \(method) \(url)")
    }

    func requestCompleted(
        _: URLRequest,
        duration: TimeInterval,
        response: URLResponse
    ) {
        if let httpResponse = response as? HTTPURLResponse {
            let durationString = String(format: "%.2f", duration)
            logger.log("✅ Network request completed: \(httpResponse.statusCode) in \(durationString)s")
        }
    }

    func requestFailed(
        _: URLRequest,
        duration: TimeInterval,
        error: Error
    ) {
        let durationString = String(format: "%.2f", duration)
        logger.log("❌ Network request failed: \(error.localizedDescription) after \(durationString)s")
    }
}

protocol Logger: Sendable {
    func log(_ message: String)
}

final class DefaultLogger: Logger, Sendable {
    func log(_ message: String) {
        print("[\(Date())] \(message)")
    }
}
