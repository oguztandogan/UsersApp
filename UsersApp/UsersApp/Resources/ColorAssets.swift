//
//  ColorAssets.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import UIKit

enum ColorAssets {
    typealias Value = UIColor

    case primary
    case onPrimary

    case secondary
    case onSecondary

    case background
    case surface
    case onSurface
    case onSurfaceVariant

    case error
    case onError

    case outline

    case searchBarBackground

    case primaryBackground
    case secondaryBackground
    case primaryText
    case secondaryText
    case accent
    case success
    case warning
    var value: UIColor {
        switch self {
        case .primary:
            return UIColor(named: "AccentColor") ?? UIColor.systemBlue
        case .onPrimary:
            return UIColor(named: "OnPrimaryColor") ?? UIColor.white
        case .secondary:
            return UIColor(named: "SuccessColor") ?? UIColor.systemGreen
        case .onSecondary:
            return UIColor(named: "OnSecondaryColor") ?? UIColor.white
        case .background:
            return UIColor(named: "PrimaryBackgroundColor") ?? UIColor.systemBackground
        case .surface:
            return UIColor(named: "SurfaceColor") ?? UIColor.systemGroupedBackground
        case .onSurface:
            return UIColor(named: "PrimaryTextColor") ?? UIColor.label
        case .onSurfaceVariant:
            return UIColor(named: "SecondaryTextColor") ?? UIColor.secondaryLabel
        case .error:
            return UIColor(named: "ErrorColor") ?? UIColor.systemRed
        case .onError:
            return UIColor(named: "OnErrorColor") ?? UIColor.white
        case .outline:
            return UIColor(named: "OutlineColor") ?? UIColor.separator
        case .searchBarBackground:
            return UIColor(named: "SearchBarBackgroundColor") ?? UIColor.systemGray6
        case .primaryBackground:
            return UIColor(named: "PrimaryBackgroundColor") ?? UIColor.systemBackground
        case .secondaryBackground:
            return UIColor(named: "SecondaryBackgroundColor") ?? UIColor.secondarySystemBackground
        case .primaryText:
            return UIColor(named: "PrimaryTextColor") ?? UIColor.label
        case .secondaryText:
            return UIColor(named: "SecondaryTextColor") ?? UIColor.secondaryLabel
        case .accent:
            return UIColor(named: "AccentColor") ?? UIColor.systemPurple
        case .success:
            return UIColor(named: "SuccessColor") ?? UIColor.systemGreen
        case .warning:
            return UIColor(named: "WarningColor") ?? UIColor.systemOrange
        }
    }
}

extension UIColor {
    static var appPrimary: UIColor { ColorAssets.primary.value }
    static var appOnPrimary: UIColor { ColorAssets.onPrimary.value }
    static var appSecondary: UIColor { ColorAssets.secondary.value }
    static var appOnSecondary: UIColor { ColorAssets.onSecondary.value }
    static var appBackground: UIColor { ColorAssets.background.value }
    static var appSurface: UIColor { ColorAssets.surface.value }
    static var appOnSurface: UIColor { ColorAssets.onSurface.value }
    static var appOnSurfaceVariant: UIColor { ColorAssets.onSurfaceVariant.value }
    static var appError: UIColor { ColorAssets.error.value }
    static var appOnError: UIColor { ColorAssets.onError.value }
    static var appOutline: UIColor { ColorAssets.outline.value }
    static var appSearchBarBackground: UIColor { ColorAssets.searchBarBackground.value }
}
