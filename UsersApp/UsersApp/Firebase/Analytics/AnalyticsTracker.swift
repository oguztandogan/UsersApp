//
//  AnalyticsTracker.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol AnalyticsTrackerProtocol {
    func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]?)
    func trackScreenView(_ screenName: String, screenClass: String?)
    func trackUserAction(_ action: UserAction, context: String?)
    func trackError(_ error: Error, context: String?)
    func setUserProperty(_ value: String?, forName name: String)

    // Users List Analytics
    func trackUsersListViewed(source: String)
    func trackUsersListRefreshed()
    func trackUsersListPagination(pageNumber: Int)

    // User Details Analytics
    func trackUserDetailsOpened(userId: String, source: String)

    // Bookmark Analytics
    func trackBookmarkToggled(userId: String, isAdding: Bool, source: String)

    // App Lifecycle Analytics
    func trackAppLaunched()
}

class AnalyticsTracker: AnalyticsTrackerProtocol {
    private let firebaseManager: FirebaseManagerProtocol
    private let environmentManager: EnvironmentManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared,
         environmentManager: EnvironmentManagerProtocol = EnvironmentManager.shared) {
        self.firebaseManager = firebaseManager
        self.environmentManager = environmentManager
    }

    func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        var enrichedParams = parameters ?? [:]
        enrichedParams["timestamp"] = Date().timeIntervalSince1970
        enrichedParams["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        firebaseManager.logEvent(event, parameters: enrichedParams)
        environmentManager.debugLog("📊 Tracked: \(event.description)")
    }

    func trackScreenView(_ screenName: String, screenClass: String? = nil) {
        let parameters: [String: Any] = [
            "screen_name": screenName,
            "screen_class": screenClass ?? screenName
        ]

        trackEvent(.listViewed, parameters: parameters)
    }

    func trackUserAction(_ action: UserAction, context: String? = nil) {
        let parameters: [String: Any] = [
            "action": action.rawValue,
            "context": context ?? "unknown"
        ]

        trackEvent(action.analyticsEvent, parameters: parameters)
    }

    func trackError(_ error: Error, context: String? = nil) {
        let parameters: [String: Any] = [
            "error_description": error.localizedDescription,
            "error_domain": (error as NSError).domain,
            "error_code": (error as NSError).code,
            "context": context ?? "unknown"
        ]

        trackEvent(.errorOccurred, parameters: parameters)
        firebaseManager.recordError(error, userInfo: parameters)
    }

    func setUserProperty(_ value: String?, forName name: String) {
        firebaseManager.setUserProperty(value, forName: name)
    }
}

// MARK: - User Actions
enum UserAction: String, CaseIterable {
    case userDetailsTapped = "user_details_tapped"
    case bookmarkTapped = "bookmark_tapped"
    case refreshPulled = "refresh_pulled"
    case paginationTriggered = "pagination_triggered"
    case debugMenuOpened = "debug_menu_opened"
    case environmentChanged = "environment_changed"

    var analyticsEvent: AnalyticsEvent {
        switch self {
        case .userDetailsTapped:
            return .userDetailsOpened
        case .bookmarkTapped:
            return .bookmarkToggled
        case .refreshPulled:
            return .usersListRefreshed
        case .paginationTriggered:
            return .usersListPaginated
        case .debugMenuOpened:
            return .debugMenuOpened
        case .environmentChanged:
            return .environmentSwitched
        }
    }
}

// MARK: - Analytics Extension for ViewModels
extension AnalyticsTracker {

    // MARK: - Users List Analytics
    func trackUsersListViewed(source: String) {
        trackEvent(.listViewed, parameters: ["source": source])
    }

    func trackUsersListRefreshed() {
        trackUserAction(.refreshPulled, context: "users_list")
    }

    func trackUsersListPagination(pageNumber: Int) {
        trackUserAction(.paginationTriggered, context: "page_\(pageNumber)")
    }

    // MARK: - User Details Analytics
    func trackUserDetailsOpened(userId: String, source: String) {
        let parameters: [String: Any] = [
            "user_id": userId,
            "source": source
        ]
        trackEvent(.userDetailsOpened, parameters: parameters)
    }

    // MARK: - Bookmark Analytics
    func trackBookmarkToggled(userId: String, isAdding: Bool, source: String) {
        let event: AnalyticsEvent = isAdding ? .bookmarkAdded : .bookmarkRemoved
        let parameters: [String: Any] = [
            "user_id": userId,
            "source": source,
            "action": isAdding ? "add" : "remove"
        ]
        trackEvent(event, parameters: parameters)
    }

    // MARK: - App Lifecycle Analytics
    func trackAppLaunched() {
        let parameters: [String: Any] = [
            "environment": environmentManager.currentEnvironment.rawValue,
            "first_launch": isFirstLaunch()
        ]
        trackEvent(.appLaunched, parameters: parameters)
    }

    private func isFirstLaunch() -> Bool {
        let key = "has_launched_before"
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: key)
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: key)
        }
        return !hasLaunchedBefore
    }
}
