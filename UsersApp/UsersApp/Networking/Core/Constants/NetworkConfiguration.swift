//
//  NetworkConfiguration.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 27.09.2025.
//

import Foundation

struct NetworkConfiguration: Sendable {
    let baseURL: String
    let timeout: TimeInterval
    let maxRetries: Int
    let enableLogging: Bool
    let enableMetrics: Bool
    let cachePolicy: URLRequest.CachePolicy
    
    init(
        baseURL: String = NetworkConstants.API.baseURL,
        timeout: TimeInterval = NetworkConstants.API.defaultTimeout,
        maxRetries: Int = NetworkConstants.Request.maxRetryCount,
        enableLogging: Bool = NetworkConstants.isDebugMode,
        enableMetrics: Bool = true,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.maxRetries = maxRetries
        self.enableLogging = enableLogging
        self.enableMetrics = enableMetrics
        self.cachePolicy = cachePolicy
    }
    
    // MARK: - Predefined Configurations
    static let `default` = NetworkConfiguration()
    
    static let development = NetworkConfiguration(
        enableLogging: true,
        enableMetrics: true
    )
    
    static let production = NetworkConfiguration(
        maxRetries: 2,
        enableLogging: false,
        enableMetrics: true
    )
    
    static let testing = NetworkConfiguration(
        baseURL: "https://mock.api.com",
        timeout: 10.0,
        maxRetries: 1,
        enableLogging: true,
        enableMetrics: false,
        cachePolicy: .reloadIgnoringLocalCacheData
    )
}
