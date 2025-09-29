//
//  EnvironmentManager.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol EnvironmentManagerProtocol {
    var currentEnvironment: Environment { get }
    var baseURL: String { get }
    var appName: String { get }
    var bundleIdentifier: String { get }
    var isDebugMode: Bool { get }
    var showDebugMenu: Bool { get }
    var enableAnalytics: Bool { get }
    var apiTimeout: TimeInterval { get }
    var logLevel: LogLevel { get }
    func log(_ message: String, level: LogLevel)
    func debugLog(_ message: String)
    func infoLog(_ message: String)
    func warningLog(_ message: String)
    func errorLog(_ message: String)
}

class EnvironmentManager: EnvironmentManagerProtocol {
    static let shared = EnvironmentManager()
    private init() {
        setupEnvironment()
    }

    let currentEnvironment = Environment.current
    var baseURL: String {
        return currentEnvironment.baseURL
    }

    var appName: String {
        return currentEnvironment.appName
    }

    var bundleIdentifier: String {
        return currentEnvironment.bundleIdentifier
    }

    var isDebugMode: Bool {
        return currentEnvironment.isDebugMode
    }

    var showDebugMenu: Bool {
        return currentEnvironment.showDebugMenu
    }

    var enableAnalytics: Bool {
        return currentEnvironment.enableAnalytics
    }

    var apiTimeout: TimeInterval {
        return currentEnvironment.apiTimeout
    }

    var logLevel: LogLevel {
        return currentEnvironment.logLevel
    }

    private func setupEnvironment() {
        print("🏗️ Environment Setup:")
        print("   Environment: \(currentEnvironment.rawValue)")
        print("   Base URL: \(baseURL)")
        print("   Bundle ID: \(bundleIdentifier)")
        print("   Debug Mode: \(isDebugMode)")
        print("   Log Level: \(logLevel.description)")
    }

    func log(_ message: String, level: LogLevel) {
        guard level.rawValue >= logLevel.rawValue else { return }
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        let logMessage = "[\(timestamp)] [\(level.description)] \(message)"
        print(logMessage)

        if currentEnvironment == .production, level == .error {}
    }

    func debugLog(_ message: String) {
        log(message, level: .debug)
    }

    func infoLog(_ message: String) {
        log(message, level: .info)
    }

    func warningLog(_ message: String) {
        log(message, level: .warning)
    }

    func errorLog(_ message: String) {
        log(message, level: .error)
    }
}

extension EnvironmentManager {
    func getEnvironmentInfo() -> [String: Any] {
        return [
            "environment": currentEnvironment.rawValue,
            "baseURL": baseURL,
            "appName": appName,
            "bundleIdentifier": bundleIdentifier,
            "isDebugMode": isDebugMode,
            "showDebugMenu": showDebugMenu,
            "enableAnalytics": enableAnalytics,
            "apiTimeout": apiTimeout,
            "logLevel": logLevel.description,
            "buildConfiguration": getBuildConfiguration()
        ]
    }

    private func getBuildConfiguration() -> String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
}
