//
//  TabConfiguration.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import Foundation
import UIKit

protocol TabConfigurable {
    var title: String { get }
    var iconName: String { get }
    var selectedIconName: String? { get }
    var badgeValue: String? { get }
    var isEnabled: Bool { get }
}

struct TabConfiguration: TabConfigurable {
    let title: String
    let iconName: String
    let selectedIconName: String?
    let badgeValue: String?
    let isEnabled: Bool
    let coordinatorFactory: (UINavigationController) -> Coordinator
    init(title: String,
         iconName: String,
         selectedIconName: String? = nil,
         badgeValue: String? = nil,
         isEnabled: Bool = true,
         coordinatorFactory: @escaping (UINavigationController) -> Coordinator) {
        self.title = title
        self.iconName = iconName
        self.selectedIconName = selectedIconName
        self.badgeValue = badgeValue
        self.isEnabled = isEnabled
        self.coordinatorFactory = coordinatorFactory
    }
}
