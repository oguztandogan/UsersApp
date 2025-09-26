//
//  HTTPClient.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import UIKit

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        let environmentManager = EnvironmentManager.shared
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queries
        
        guard let url = urlComponents.url else {
            environmentManager.errorLog("Invalid URL: \(endpoint)")
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.timeoutInterval = environmentManager.apiTimeout
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        // Log request in debug mode
        if environmentManager.isDebugMode {
            environmentManager.debugLog("🌐 API Request: \(request.httpMethod ?? "GET") \(url)")
            if let headers = request.allHTTPHeaderFields {
                environmentManager.debugLog("📋 Headers: \(headers)")
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else {
                environmentManager.errorLog("No HTTP response received")
                return .failure(.noResponse)
            }
            
            // Log response in debug mode
            if environmentManager.isDebugMode {
                environmentManager.debugLog("📱 API Response: \(httpResponse.statusCode) for \(url)")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    environmentManager.errorLog("Failed to decode response for \(responseModel)")
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                environmentManager.warningLog("Unauthorized request to \(url)")
                return .failure(.unauthorized)
            default:
                environmentManager.errorLog("Unexpected status code: \(httpResponse.statusCode) for \(url)")
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            environmentManager.errorLog("Network error: \(error.localizedDescription)")
            return .failure(.unknown)
        }
    }
}
