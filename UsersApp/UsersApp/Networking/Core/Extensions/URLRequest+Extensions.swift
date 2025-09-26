//
//  URLRequest+Extensions.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

// MARK: - URLRequest Extensions for Networking
extension URLRequest {
    
    /// Creates a URLRequest with timeout and common headers
    static func create(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        body: Data? = nil,
        timeoutInterval: TimeInterval = 30.0
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        request.httpBody = body
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    /// Adds authorization header to the request
    mutating func addAuthorization(token: String, scheme: String = "Bearer") {
        setValue("\(scheme) \(token)", forHTTPHeaderField: "Authorization")
    }
    
    /// Adds user agent header
    mutating func addUserAgent(_ userAgent: String) {
        setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    /// Adds request ID header for tracking
    mutating func addRequestId(_ requestId: String) {
        setValue(requestId, forHTTPHeaderField: "X-Request-ID")
    }
    
    /// Returns a copy of the request with modified headers
    func withHeaders(_ headers: [String: String]) -> URLRequest {
        var request = self
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    /// Returns a copy of the request with modified timeout
    func withTimeout(_ timeout: TimeInterval) -> URLRequest {
        var request = self
        request.timeoutInterval = timeout
        return request
    }
    
    /// Returns a copy of the request with modified body
    func withBody(_ body: Data?) -> URLRequest {
        var request = self
        request.httpBody = body
        return request
    }
}

// MARK: - URLRequest Debugging
extension URLRequest {
    
    /// Returns a formatted string representation of the request for debugging
    var debugDescription: String {
        var components: [String] = []
        
        // Method and URL
        let method = httpMethod ?? "GET"
        let url = self.url?.absoluteString ?? "unknown"
        components.append("\(method) \(url)")
        
        // Headers
        if let headers = allHTTPHeaderFields, !headers.isEmpty {
            components.append("Headers:")
            for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
                components.append("  \(key): \(value)")
            }
        }
        
        // Body
        if let body = httpBody, !body.isEmpty {
            if let bodyString = String(data: body, encoding: .utf8) {
                components.append("Body:")
                components.append(bodyString)
            } else {
                components.append("Body: <Binary data: \(body.count) bytes>")
            }
        }
        
        // Timeout
        components.append("Timeout: \(timeoutInterval)s")
        
        return components.joined(separator: "\n")
    }
    
    /// Returns the request size in bytes
    var estimatedSize: Int {
        var size = 0
        
        // URL size
        if let url = url?.absoluteString {
            size += url.utf8.count
        }
        
        // Headers size
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                size += key.utf8.count + value.utf8.count + 4 // +4 for ": " and "\r\n"
            }
        }
        
        // Body size
        if let body = httpBody {
            size += body.count
        }
        
        return size
    }
}
