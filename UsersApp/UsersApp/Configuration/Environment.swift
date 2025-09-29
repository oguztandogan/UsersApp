//
//  Environment.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

enum Environment: String, CaseIterable {
    case development = "Development"
    case staging = "QA"
    case production = "Production"

    static var current: Environment {
        #if DEV
            return .development
        #elseif QA
            return .staging
        #else
            return .production
        #endif
    }

    // MARK: - Environment Configuration

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

    var appName: String {
        switch self {
        case .development:
            return "UsersApp Dev"
        case .staging:
            return "UsersApp QA"
        case .production:
            return "UsersApp"
        }
    }

    var bundleIdentifier: String {
        switch self {
        case .development:
            return "com.oguztandogan.usersapp.dev"
        case .staging:
            return "com.oguztandogan.usersapp.qa"
        case .production:
            return "com.oguztandogan.usersapp"
        }
    }

    var logLevel: LogLevel {
        switch self {
        case .development:
            return .debug
        case .staging:
            return .info
        case .production:
            return .error
        }
    }

    var isDebugMode: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }

    var showDebugMenu: Bool {
        switch self {
        case .development:
            return true
        case .staging, .production:
            return false
        }
    }

    var enableAnalytics: Bool {
        switch self {
        case .development:
            return false
        case .staging:
            return true
        case .production:
            return true
        }
    }

    var apiTimeout: TimeInterval {
        if let timeoutString = Bundle.main.object(forInfoDictionaryKey: "API_TIMEOUT") as? String,
           let timeout = TimeInterval(timeoutString) {
            return timeout
        }
        return 30.0
    }
}

enum LogLevel: Int, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    var description: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}
