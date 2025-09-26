//
//  AppDelegate.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 2.09.2023.
//

import UIKit
import CoreData
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Setup Environment
        setupEnvironment()
        
        // Configure Swinject Dependencies
        DependencyContainer.shared.configureDependencies()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationCon, window: window!)
        appCoordinator?.start()
        window!.makeKeyAndVisible()
        return true
    }
    
    private func setupEnvironment() {
        let environmentManager = EnvironmentManager.shared
        environmentManager.infoLog("🚀 App launching with environment: \(environmentManager.currentEnvironment.rawValue)")
        
        // Log environment info in debug mode
        if environmentManager.isDebugMode {
            let envInfo = environmentManager.getEnvironmentInfo()
            environmentManager.debugLog("🔧 Environment Configuration:")
            for (key, value) in envInfo {
                environmentManager.debugLog("   \(key): \(value)")
            }
        }
    }
}
