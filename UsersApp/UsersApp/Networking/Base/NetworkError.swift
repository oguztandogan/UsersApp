//
//  NetworkError.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Comprehensive error type for networking operations
/// Conforms to Sendable for Swift 6 thread safety
enum NetworkError: Error, Sendable, LocalizedError, CustomStringConvertible {
    case invalidURL(String)
    case noData
    case decodingError(DecodingError)
    case encodingError(EncodingError)
    case httpError(HTTPStatusCode, Data?)
    case networkUnavailable
    case timeout
    case cancelled
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int, String?)
    case unknown(Error)

    // MARK: - HTTPStatusCode
    enum HTTPStatusCode: Int, Sendable {
        case success = 200
        case created = 201
        case noContent = 204
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case methodNotAllowed = 405
        case conflict = 409
        case unprocessableEntity = 422
        case tooManyRequests = 429
        case internalServerError = 500
        case badGateway = 502
        case serviceUnavailable = 503
        case gatewayTimeout = 504

        var isSuccess: Bool {
            return 200...299 ~= rawValue
        }

        var isClientError: Bool {
            return 400...499 ~= rawValue
        }

        var isServerError: Bool {
            return 500...599 ~= rawValue
        }
    }

    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .httpError(let statusCode, _):
            return "HTTP error with status code: \(statusCode.rawValue)"
        case .networkUnavailable:
            return "Network is unavailable"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request was cancelled"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message ?? "Unknown error")"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }

    // MARK: - CustomStringConvertible
    var description: String {
        return errorDescription ?? "Unknown network error"
    }

    // MARK: - Convenience Initializers
    static func from(httpStatusCode: Int, data: Data? = nil) -> NetworkError {
        guard let statusCode = HTTPStatusCode(rawValue: httpStatusCode) else {
            return .serverError(httpStatusCode, "Unknown status code")
        }

        switch statusCode {
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .notFound:
            return .notFound
        default:
            if statusCode.isClientError || statusCode.isServerError {
                return .httpError(statusCode, data)
            } else {
                return .serverError(httpStatusCode, "Unexpected status code")
            }
        }
    }

    static func from(urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .networkUnavailable
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .badURL:
            return .invalidURL(urlError.localizedDescription)
        default:
            return .unknown(urlError)
        }
    }

    // MARK: - Helper Properties
    var isRetryable: Bool {
        switch self {
        case .networkUnavailable, .timeout, .serverError:
            return true
        case .httpError(let statusCode, _):
            return statusCode.rawValue >= 500
        default:
            return false
        }
    }

    var statusCode: Int? {
        switch self {
        case .httpError(let statusCode, _):
            return statusCode.rawValue
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .serverError(let code, _):
            return code
        default:
            return nil
        }
    }
}
