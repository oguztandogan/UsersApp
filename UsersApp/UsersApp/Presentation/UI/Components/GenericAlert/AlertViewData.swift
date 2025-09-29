//
//  AlertViewData.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

struct AlertViewData {
    let title: String?
    let subtitle: String?
    let buttonTitle: String
    let action: (() -> Void)?
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?

    init(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String = "button.ok".localized,
        action: (() -> Void)? = nil,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.action = action
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
    }
}
