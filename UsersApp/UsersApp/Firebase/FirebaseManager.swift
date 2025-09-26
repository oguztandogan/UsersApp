//
//  FirebaseManager.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseRemoteConfig

protocol FirebaseManagerProtocol {
    func configure()
    func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]?)
    func setUserProperty(_ value: String?, forName name: String)
    func recordError(_ error: Error, userInfo: [String: Any]?)
    func logMessage(_ message: String)
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void)
    func getRemoteConfigValue(forKey key: String) -> RemoteConfigValue?
}

class FirebaseManager: FirebaseManagerProtocol {
    static let shared = FirebaseManager()

    private let environmentManager = EnvironmentManager.shared
    private var remoteConfig: RemoteConfig?

    private init() {}

    func configure() {
        // Firebase configuration based on environment
        guard let configFileName = getConfigFileName() else {
            environmentManager.errorLog("Firebase config file not found for environment")
            return
        }

        guard let filePath = Bundle.main.path(forResource: configFileName, ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: filePath) else {
            environmentManager.errorLog("Failed to load Firebase config from \(configFileName).plist")
            return
        }

        FirebaseApp.configure(options: options)

        // Configure services based on environment
        configureAnalytics()
        configureCrashlytics()
        configureRemoteConfig()

        environmentManager.infoLog("🔥 Firebase configured for \(environmentManager.currentEnvironment.rawValue)")
    }

    private func getConfigFileName() -> String? {
        // For now, use single Firebase config for all environments
        return "GoogleService-Info"
    }

    private func configureAnalytics() {
        guard environmentManager.enableAnalytics else {
            Analytics.setAnalyticsCollectionEnabled(false)
            environmentManager.debugLog("📊 Analytics disabled for \(environmentManager.currentEnvironment.rawValue)")
            return
        }

        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setUserProperty(environmentManager.currentEnvironment.rawValue, forName: "environment")
        environmentManager.infoLog("📊 Analytics enabled")
    }

    private func configureCrashlytics() {
        // Enable Crashlytics only in QA and Production
        let shouldEnable = environmentManager.currentEnvironment != .development
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(shouldEnable)

        if shouldEnable {
            Crashlytics.crashlytics().setUserID("user_\(environmentManager.currentEnvironment.rawValue)")
            Crashlytics.crashlytics().setCustomValue(
                environmentManager.currentEnvironment.rawValue,
                forKey: "environment"
            )
            environmentManager.infoLog("💥 Crashlytics enabled")
        } else {
            environmentManager.debugLog("💥 Crashlytics disabled for Development")
        }
    }

    private func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        // Different fetch intervals for different environments
        switch environmentManager.currentEnvironment {
        case .development:
            settings.minimumFetchInterval = 0 // Immediate for testing
        case .qa:
            settings.minimumFetchInterval = 300 // 5 minutes
        case .production:
            settings.minimumFetchInterval = 3600 // 1 hour
        }

        remoteConfig?.configSettings = settings

        // Set default values
        setRemoteConfigDefaults()

        environmentManager.infoLog("🏃‍♂️ Remote Config configured")
    }

    private func setRemoteConfigDefaults() {
        let defaults: [String: NSObject] = [
            "dark_mode_enabled": false as NSObject,
            "bookmark_sync_enabled": false as NSObject,
            "debug_menu_enabled": environmentManager.showDebugMenu as NSObject,
            "api_timeout_seconds": environmentManager.apiTimeout as NSObject,
            "feature_user_profiles": false as NSObject,
            "max_bookmarks_count": 100 as NSObject
        ]

        remoteConfig?.setDefaults(defaults)
    }
}

// MARK: - Analytics
extension FirebaseManager {
    func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        guard environmentManager.enableAnalytics else { return }

        var params = parameters ?? [:]
        params["environment"] = environmentManager.currentEnvironment.rawValue

        Analytics.logEvent(event.rawValue, parameters: params)

        if environmentManager.isDebugMode {
            environmentManager.debugLog("📊 Analytics Event: \(event.rawValue) with params: \(params)")
        }
    }

    func setUserProperty(_ value: String?, forName name: String) {
        guard environmentManager.enableAnalytics else { return }

        Analytics.setUserProperty(value, forName: name)
        environmentManager.debugLog("👤 User Property Set: \(name) = \(value ?? "nil")")
    }
}

// MARK: - Crashlytics
extension FirebaseManager {
    func recordError(_ error: Error, userInfo: [String: Any]? = nil) {
        var combinedUserInfo = userInfo ?? [:]
        combinedUserInfo["environment"] = environmentManager.currentEnvironment.rawValue

        Crashlytics.crashlytics().record(error: error, userInfo: combinedUserInfo)
        environmentManager.errorLog("💥 Error recorded: \(error.localizedDescription)")
    }

    func logMessage(_ message: String) {
        Crashlytics.crashlytics().log(message)

        if environmentManager.isDebugMode {
            environmentManager.debugLog("📝 Crashlytics Log: \(message)")
        }
    }
}

// MARK: - Remote Config
extension FirebaseManager {
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
        remoteConfig?.fetch { [weak self] _, error in
            if let error = error {
                self?.environmentManager.errorLog("Remote Config fetch failed: \(error.localizedDescription)")
                completion(false)
                return
            }

            self?.remoteConfig?.activate { _, _ in
                self?.environmentManager.infoLog("🏃‍♂️ Remote Config activated")
                completion(true)
            }
        }
    }

    func getRemoteConfigValue(forKey key: String) -> RemoteConfigValue? {
        return remoteConfig?.configValue(forKey: key)
    }
}

// MARK: - Analytics Events
enum AnalyticsEvent: String, CaseIterable {
    case appLaunched = "app_launched"
    case listViewed = "list_viewed"
    case userDetailsOpened = "user_details_opened"
    case bookmarkToggled = "bookmark_toggled"
    case bookmarkAdded = "bookmark_added"
    case bookmarkRemoved = "bookmark_removed"
    case usersListRefreshed = "users_list_refreshed"
    case usersListPaginated = "users_list_paginated"
    case errorOccurred = "error_occurred"
    case debugMenuOpened = "debug_menu_opened"
    case environmentSwitched = "environment_switched"

    var description: String {
        switch self {
        case .appLaunched: return "App launched"
        case .listViewed: return "Users list viewed"
        case .userDetailsOpened: return "User details opened"
        case .bookmarkToggled: return "Bookmark toggled"
        case .bookmarkAdded: return "Bookmark added"
        case .bookmarkRemoved: return "Bookmark removed"
        case .usersListRefreshed: return "Users list refreshed"
        case .usersListPaginated: return "Users list paginated"
        case .errorOccurred: return "Error occurred"
        case .debugMenuOpened: return "Debug menu opened"
        case .environmentSwitched: return "Environment switched"
        }
    }
}
