//
//  RemoteConfigManager.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import FirebaseRemoteConfig
import Foundation

protocol RemoteConfigManagerProtocol {
    func fetchAndActivate(completion: @escaping (Bool) -> Void)
    func getValue<T>(for key: RemoteConfigKey, defaultValue: T) -> T
    func getBoolValue(for key: RemoteConfigKey) -> Bool
    func getStringValue(for key: RemoteConfigKey) -> String
    func getIntValue(for key: RemoteConfigKey) -> Int
    func getDoubleValue(for key: RemoteConfigKey) -> Double

    var isDarkModeEnabled: Bool { get }
    var isDebugMenuEnabled: Bool { get }
    var showWelcomeMessage: Bool { get }
    var isBookmarkSyncEnabled: Bool { get }
    var isUserProfilesEnabled: Bool { get }
    var isPushNotificationsEnabled: Bool { get }
    var isMaintenanceModeEnabled: Bool { get }
    var isForceUpdateRequired: Bool { get }
    var apiTimeoutSeconds: Double { get }
    var maxBookmarksCount: Int { get }
}

class RemoteConfigManager: RemoteConfigManagerProtocol {
    static let shared = RemoteConfigManager()
    private let firebaseManager: FirebaseManagerProtocol
    private let environmentManager: EnvironmentManagerProtocol
    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared,
         environmentManager: EnvironmentManagerProtocol = EnvironmentManager.shared) {
        self.firebaseManager = firebaseManager
        self.environmentManager = environmentManager
    }

    func fetchAndActivate(completion: @escaping (Bool) -> Void) {
        firebaseManager.fetchRemoteConfig { [weak self] success in
            if success {
                self?.environmentManager.infoLog("🏃‍♂️ Remote Config fetched and activated")
            } else {
                self?.environmentManager.errorLog("🏃‍♂️ Remote Config fetch failed")
            }
            completion(success)
        }
    }

    func getValue<T>(for key: RemoteConfigKey, defaultValue: T) -> T {
        guard let configValue = firebaseManager.getRemoteConfigValue(forKey: key.rawValue) else {
            return defaultValue
        }
        switch defaultValue {
        case is Bool:
            return configValue.boolValue as? T ?? defaultValue
        case is String:
            return configValue.stringValue as? T ?? defaultValue
        case is Int:
            return Int(configValue.numberValue.intValue) as? T ?? defaultValue
        case is Double:
            return configValue.numberValue.doubleValue as? T ?? defaultValue
        default:
            return defaultValue
        }
    }

    func getBoolValue(for key: RemoteConfigKey) -> Bool {
        return getValue(for: key, defaultValue: key.defaultBoolValue)
    }

    func getStringValue(for key: RemoteConfigKey) -> String {
        return getValue(for: key, defaultValue: key.defaultStringValue)
    }

    func getIntValue(for key: RemoteConfigKey) -> Int {
        return getValue(for: key, defaultValue: key.defaultIntValue)
    }

    func getDoubleValue(for key: RemoteConfigKey) -> Double {
        return getValue(for: key, defaultValue: key.defaultDoubleValue)
    }
}

enum RemoteConfigKey: String, CaseIterable {
    case darkModeEnabled = "dark_mode_enabled"
    case bookmarkSyncEnabled = "bookmark_sync_enabled"
    case debugMenuEnabled = "debug_menu_enabled"
    case apiTimeoutSeconds = "api_timeout_seconds"
    case featureUserProfiles = "feature_user_profiles"
    case maxBookmarksCount = "max_bookmarks_count"
    case showWelcomeMessage = "show_welcome_message"
    case enablePushNotifications = "enable_push_notifications"
    case maintenanceMode = "maintenance_mode"
    case forceUpdateRequired = "force_update_required"
    var defaultBoolValue: Bool {
        switch self {
        case .darkModeEnabled:
            return false
        case .bookmarkSyncEnabled:
            return false
        case .debugMenuEnabled:
            return EnvironmentManager.shared.showDebugMenu
        case .featureUserProfiles:
            return false
        case .showWelcomeMessage:
            return true
        case .enablePushNotifications:
            return true
        case .maintenanceMode:
            return false
        case .forceUpdateRequired:
            return false
        default:
            return false
        }
    }

    var defaultStringValue: String {
        switch self {
        default:
            return ""
        }
    }

    var defaultIntValue: Int {
        switch self {
        case .maxBookmarksCount:
            return 100
        default:
            return 0
        }
    }

    var defaultDoubleValue: Double {
        switch self {
        case .apiTimeoutSeconds:
            return EnvironmentManager.shared.apiTimeout
        default:
            return 0.0
        }
    }

    var description: String {
        switch self {
        case .darkModeEnabled:
            return "Enable dark mode theme"
        case .bookmarkSyncEnabled:
            return "Enable bookmark synchronization"
        case .debugMenuEnabled:
            return "Show debug menu"
        case .apiTimeoutSeconds:
            return "API request timeout in seconds"
        case .featureUserProfiles:
            return "Enable user profiles feature"
        case .maxBookmarksCount:
            return "Maximum number of bookmarks allowed"
        case .showWelcomeMessage:
            return "Show welcome message to new users"
        case .enablePushNotifications:
            return "Enable push notifications"
        case .maintenanceMode:
            return "App maintenance mode"
        case .forceUpdateRequired:
            return "Force app update required"
        }
    }
}

extension RemoteConfigManager {
    var isDarkModeEnabled: Bool {
        getBoolValue(for: .darkModeEnabled)
    }

    var isDebugMenuEnabled: Bool {
        getBoolValue(for: .debugMenuEnabled)
    }

    var showWelcomeMessage: Bool {
        getBoolValue(for: .showWelcomeMessage)
    }

    var isBookmarkSyncEnabled: Bool {
        getBoolValue(for: .bookmarkSyncEnabled)
    }

    var isUserProfilesEnabled: Bool {
        getBoolValue(for: .featureUserProfiles)
    }

    var isPushNotificationsEnabled: Bool {
        getBoolValue(for: .enablePushNotifications)
    }

    var isMaintenanceModeEnabled: Bool {
        getBoolValue(for: .maintenanceMode)
    }

    var isForceUpdateRequired: Bool {
        getBoolValue(for: .forceUpdateRequired)
    }

    var apiTimeoutSeconds: Double {
        getDoubleValue(for: .apiTimeoutSeconds)
    }

    var maxBookmarksCount: Int {
        getIntValue(for: .maxBookmarksCount)
    }
}

extension RemoteConfigManager {
    func getAllRemoteConfigValues() -> [String: Any] {
        var values: [String: Any] = [:]
        for key in RemoteConfigKey.allCases {
            if let configValue = firebaseManager.getRemoteConfigValue(forKey: key.rawValue) {
                values[key.rawValue] = configValue.stringValue
            }
        }
        return values
    }

    func printAllRemoteConfigValues() {
        let values = getAllRemoteConfigValues()
        environmentManager.debugLog("🏃‍♂️ Remote Config Values:")
        for (key, value) in values.sorted(by: { $0.key < $1.key }) {
            environmentManager.debugLog("   \(key): \(value)")
        }
    }
}
