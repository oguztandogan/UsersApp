//
//  BaseViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit
import Pulse
import PulseUI

class BaseViewController: UIViewController {

    private var isShakeEnabled: Bool {
        return EnvironmentManager.shared.currentEnvironment != .production
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        return isShakeEnabled
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard isShakeEnabled else { return }
        if motion == .motionShake {
            handleShakeGesture()
        }
    }

    private func handleShakeGesture() {
        guard isShakeEnabled else { return }
        EnvironmentManager.shared.debugLog("📱 Shake gesture detected - Opening Pulse Console")
        presentPulseConsole()
    }

    private func presentPulseConsole() {
        let pulseViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: pulseViewController)
        customizePulseAppearance(navigationController)
        present(navigationController, animated: true)
    }

    private func customizePulseAppearance(_ navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = .appPrimary

        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(closePulseConsole)
        )
        navigationController.topViewController?.navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func closePulseConsole() {
        dismiss(animated: true)
    }

    #if DEBUG
    private func addShakeIndicator() {
        let indicatorLabel = UILabel()
        indicatorLabel.text = "Shake to open Pulse Console"
        indicatorLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        indicatorLabel.textColor = .appOnSurfaceVariant
        indicatorLabel.alpha = 0.6
        indicatorLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(indicatorLabel)

        NSLayoutConstraint.activate([
            indicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5) {
                indicatorLabel.alpha = 0
            } completion: { _ in
                indicatorLabel.removeFromSuperview()
            }
        }
    }
    #endif
}

extension BaseViewController {
    private var shouldShowPulseConsole: Bool {
        return EnvironmentManager.shared.currentEnvironment != .production
    }

    private var currentEnvironment: Environment {
        return EnvironmentManager.shared.currentEnvironment
    }
}
