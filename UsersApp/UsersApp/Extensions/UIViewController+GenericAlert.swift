//
//  UIViewController+GenericAlert.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit

extension UIViewController {
    func showGenericAlert(data: AlertViewData) {
        let alertController = GenericAlertView.createAlertController(with: data)
        present(alertController, animated: true)
    }

    func showSuccessAlert(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String = "button.ok".localized,
        action: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            action: action
        )
        showGenericAlert(data: data)
    }

    func showWarningAlert(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String = "button.ok".localized,
        action: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            action: action
        )
        showGenericAlert(data: data)
    }

    func showErrorAlert(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String = "button.ok".localized,
        action: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            action: action
        )
        showGenericAlert(data: data)
    }

    func showInfoAlert(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String = "button.ok".localized,
        action: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            action: action
        )
        showGenericAlert(data: data)
    }

    func showErrorAlertWithRetry(
        title: String? = nil,
        subtitle: String? = nil,
        retryTitle: String = "button.retry".localized,
        cancelTitle: String = "button.cancel".localized,
        retryAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: retryTitle,
            action: retryAction,
            secondaryButtonTitle: cancelTitle,
            secondaryAction: cancelAction
        )
        showGenericAlert(data: data)
    }

    func showWarningAlertWithConfirm(
        title: String? = nil,
        subtitle: String? = nil,
        confirmTitle: String = "button.confirm".localized,
        cancelTitle: String = "button.cancel".localized,
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let data = AlertViewData(
            title: title,
            subtitle: subtitle,
            buttonTitle: confirmTitle,
            action: confirmAction,
            secondaryButtonTitle: cancelTitle,
            secondaryAction: cancelAction
        )
        showGenericAlert(data: data)
    }
}
