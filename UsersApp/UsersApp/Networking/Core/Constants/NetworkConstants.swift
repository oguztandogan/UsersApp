//
//  NetworkConstants.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Network-related constants and configuration
enum NetworkConstants {
    
    // MARK: - API Configuration
    enum API {
        static var baseURL: String {
            return Environment.current.baseURL
        }
        static let version = "v1"
        static var defaultTimeout: TimeInterval {
            return Environment.current.apiTimeout
        }
        static let uploadTimeout: TimeInterval = 60.0
        static let downloadTimeout: TimeInterval = 120.0
        
        // Common endpoints
        enum Endpoints {
            static let users = "/api"
            static let userDetail = "/api/user"
        }
    }
    
    // MARK: - HTTP Headers
    enum Headers {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let authorization = "Authorization"
        static let userAgent = "User-Agent"
        static let requestId = "X-Request-ID"
        static let apiKey = "X-API-Key"
        static let clientVersion = "X-Client-Version"
        
        // Content types
        enum ContentType {
            static let json = "application/json"
            static let formURLEncoded = "application/x-www-form-urlencoded"
            static let multipartFormData = "multipart/form-data"
            static let textPlain = "text/plain"
        }
        
        // Accept types
        enum Accept {
            static let json = "application/json"
            static let xml = "application/xml"
            static let any = "*/*"
        }
    }
    
    // MARK: - HTTP Status Codes
    enum StatusCode {
        // Success
        static let ok = 200
        static let created = 201
        static let accepted = 202
        static let noContent = 204
        
        // Redirection
        static let movedPermanently = 301
        static let found = 302
        static let notModified = 304
        
        // Client Errors
        static let badRequest = 400
        static let unauthorized = 401
        static let forbidden = 403
        static let notFound = 404
        static let methodNotAllowed = 405
        static let conflict = 409
        static let unprocessableEntity = 422
        static let tooManyRequests = 429
        
        // Server Errors
        static let internalServerError = 500
        static let badGateway = 502
        static let serviceUnavailable = 503
        static let gatewayTimeout = 504
    }
    
    // MARK: - Request Configuration
    enum Request {
        static let maxRetryCount = 3
        static let retryDelay: TimeInterval = 1.0
        static let maxConcurrentRequests = 4
        static let cacheSize = 10 * 1024 * 1024 // 10MB
        
        // Body size limits
        static let maxBodySize = 50 * 1024 * 1024 // 50MB
        static let maxLogBodySize = 1024 // 1KB for logging
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let networkUnavailable = "Network connection is not available"
        static let requestTimeout = "Request timed out"
        static let invalidResponse = "Invalid response received"
        static let decodingFailed = "Failed to decode response"
        static let encodingFailed = "Failed to encode request"
        static let unauthorized = "Authentication required"
        static let forbidden = "Access denied"
        static let notFound = "Resource not found"
        static let serverError = "Server error occurred"
        static let unknown = "An unknown error occurred"
    }
    
    // MARK: - Cache Configuration
    enum Cache {
        static let defaultAge: TimeInterval = 300 // 5 minutes
        static let maxAge: TimeInterval = 3600 // 1 hour
        static let diskCapacity = 100 * 1024 * 1024 // 100MB
        static let memoryCapacity = 20 * 1024 * 1024 // 20MB
    }
    
    // MARK: - User Agent
    static var defaultUserAgent: String {
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "UsersApp"
        
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let device = "iOS" // Could be made dynamic based on platform
        
        return "\(appName)/\(bundleVersion) (\(buildNumber)) \(device) \(osVersion)"
    }
    
    // MARK: - Environment Detection
    static var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
