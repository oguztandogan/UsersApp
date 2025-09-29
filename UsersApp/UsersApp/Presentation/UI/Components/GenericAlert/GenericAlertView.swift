//
//  GenericAlertView.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit

final class GenericAlertView {
    static func createAlertController(with data: AlertViewData) -> UIAlertController {
        let alert = UIAlertController(
            title: data.title,
            message: data.subtitle,
            preferredStyle: .alert
        )

        let primaryAction = UIAlertAction(title: data.buttonTitle, style: .default) { _ in
            data.action?()
        }
        alert.addAction(primaryAction)

        if let secondaryTitle = data.secondaryButtonTitle {
            let secondaryAction = UIAlertAction(title: secondaryTitle, style: .cancel) { _ in
                data.secondaryAction?()
            }
            alert.addAction(secondaryAction)
        }
        return alert
    }
}
