//
//  TabNavigationData.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

struct TabNavigationData: NavigationData {
    let tabIndex: Int
    let shouldAnimate: Bool
    init(tabIndex: Int, shouldAnimate: Bool = false) {
        self.tabIndex = tabIndex
        self.shouldAnimate = shouldAnimate
    }
}
