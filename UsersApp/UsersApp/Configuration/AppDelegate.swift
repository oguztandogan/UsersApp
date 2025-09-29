//
//  AppDelegate.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 2.09.2023.
//

import CoreData
import FirebaseCore
import Swinject
import UIKit
import Pulse
import PulseProxy

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupEnvironment()
#if DEV || QA
        setupNetworkDebugger()
#endif
        DependencyContainer.shared.configureDependencies()

        return true
    }

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}

    private func setupEnvironment() {
        let environmentManager = EnvironmentManager.shared
        environmentManager.infoLog(
            "🚀 App launching with environment: \(environmentManager.currentEnvironment.rawValue)"
        )

        FirebaseManager.shared.configure()

        RemoteConfigManager.shared.fetchAndActivate { success in
            if success {
                environmentManager.infoLog("🏃‍♂️ Remote Config loaded successfully")
            } else {
                environmentManager.warningLog("🏃‍♂️ Remote Config failed to load, using defaults")
            }
        }

        AnalyticsTracker().trackAppLaunched()
        if environmentManager.isDebugMode {
            let envInfo = environmentManager.getEnvironmentInfo()
            environmentManager.debugLog("🔧 Environment Configuration:")
            for (key, value) in envInfo {
                environmentManager.debugLog("   \(key): \(value)")
            }
        }
    }

#if DEV || QA
    private func setupNetworkDebugger() {
        var configuration = Pulse.NetworkLogger.Configuration()
        configuration.excludedHosts = [
            "https://firebaselogging-pa.googleapis.com"
        ]
        configuration.excludedURLs = [
            "https://firebaselogging-pa.googleapis.com/v1/firelog/legacy/batchlog"
        ]
        configuration.sensitiveHeaders = [
            "Authorization",
            "Access-Token"
        ]
        configuration.sensitiveQueryItems = [
            "password"
        ]
        configuration.sensitiveDataFields = [
            "password"
        ]

        let logger = Pulse.NetworkLogger(configuration: configuration)
        Pulse.NetworkLogger.shared = logger
        Pulse.NetworkLogger.enableProxy()
    }
#endif
}
