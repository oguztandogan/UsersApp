//
//  SceneDelegate.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        setupAppCoordinator()

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}

private extension SceneDelegate {
    func setupAppCoordinator() {
        guard let window = window else { return }

        let navigationController = UINavigationController()

        appCoordinator = AppCoordinator(navigationController: navigationController, window: window)

        appCoordinator?.start()
    }
}
