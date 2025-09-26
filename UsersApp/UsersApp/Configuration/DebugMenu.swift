//
//  DebugMenu.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import UIKit

class DebugMenu {
    static let shared = DebugMenu()
    private init() {}

    func presentDebugMenu(from viewController: UIViewController) {
        guard EnvironmentManager.shared.showDebugMenu else { return }

        let alertController = UIAlertController(
            title: "🛠️ Debug Menu",
            message: "Development Tools",
            preferredStyle: .actionSheet
        )

        // Environment Info
        alertController.addAction(UIAlertAction(title: "📋 Environment Info", style: .default) { _ in
            self.showEnvironmentInfo(from: viewController)
        })

        // Network Logs
        alertController.addAction(UIAlertAction(title: "🌐 Network Logs", style: .default) { _ in
            self.showNetworkLogs(from: viewController)
        })

        // Clear Cache
        alertController.addAction(UIAlertAction(title: "🗑️ Clear Cache", style: .destructive) { _ in
            self.clearCache()
        })

        // Switch Environment (simulated)
        alertController.addAction(UIAlertAction(title: "🔄 Environment Switcher", style: .default) { _ in
            self.showEnvironmentSwitcher(from: viewController)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // For iPad
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                       y: viewController.view.bounds.midY,
                                       width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        viewController.present(alertController, animated: true)
    }

    private func showEnvironmentInfo(from viewController: UIViewController) {
        let environmentManager = EnvironmentManager.shared
        let envInfo = environmentManager.getEnvironmentInfo()

        var message = ""
        for (key, value) in envInfo.sorted(by: { $0.key < $1.key }) {
            message += "\(key): \(value)\n"
        }

        let alert = UIAlertController(
            title: "Environment Info",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        viewController.present(alert, animated: true)
    }

    private func showNetworkLogs(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Network Logs",
            message: "Network logging is enabled in debug mode.\nCheck console for detailed logs.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        viewController.present(alert, animated: true)
    }

    private func clearCache() {
        // Clear URLSession cache
        URLCache.shared.removeAllCachedResponses()

        // Clear UserDefaults (be careful in production)
        if EnvironmentManager.shared.currentEnvironment == .development {
            let defaults = UserDefaults.standard
            defaults.dictionaryRepresentation().keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        }

        EnvironmentManager.shared.infoLog("🗑️ Cache cleared")
    }

    private func showEnvironmentSwitcher(from viewController: UIViewController) {
        // swiftlint:disable:next line_length
        let message = "Current: \(EnvironmentManager.shared.currentEnvironment.rawValue)\n\nNote: Environment is determined at build time."
        let alert = UIAlertController(
            title: "Environment Switcher",
            message: message,
            preferredStyle: .alert
        )

        for environment in Environment.allCases {
            let isCurrentEnv = environment == EnvironmentManager.shared.currentEnvironment
            let title = isCurrentEnv ? "✓ \(environment.rawValue)" : environment.rawValue

            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                let message = "Environment switching requires rebuilding the app with different build configuration." // swiftlint:disable:this line_length
                let infoAlert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                infoAlert.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.present(infoAlert, animated: true)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        viewController.present(alert, animated: true)
    }
}

// MARK: - UIViewController Extension for Debug Menu
extension UIViewController {
    @objc func presentDebugMenu() {
        DebugMenu.shared.presentDebugMenu(from: self)
    }

    func addDebugMenuGesture() {
        guard EnvironmentManager.shared.showDebugMenu else { return }

        // Triple tap gesture to show debug menu
        let tripleTouch = UITapGestureRecognizer(target: self, action: #selector(presentDebugMenu))
        tripleTouch.numberOfTapsRequired = 3
        tripleTouch.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tripleTouch)
    }
}
