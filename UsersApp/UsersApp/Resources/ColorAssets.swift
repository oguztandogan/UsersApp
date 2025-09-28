//
//  ColorAssets.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import UIKit

// MARK: - Semantic Colors
/// Semantic color system for the UsersApp
/// Colors automatically adapt to light/dark mode and provide semantic meaning
enum ColorAssets {
    
    typealias Value = UIColor
    
    // MARK: - Primary Colors
    case primary
    case onPrimary
    
    // MARK: - Secondary Colors
    case secondary
    case onSecondary
    
    // MARK: - Background & Surface
    case background
    case surface
    case onSurface
    case onSurfaceVariant
    
    // MARK: - Error Colors
    case error
    case onError
    
    // MARK: - Divider / Border
    case outline
    
    // MARK: - UI Components
    case searchBarBackground
    
    // MARK: - Legacy Colors (Deprecated - use semantic colors instead)
    case primaryBackground
    case secondaryBackground
    case primaryText
    case secondaryText
    case accent
    case success
    case warning
    
    // MARK: - Legacy Colors (Deprecated - use semantic colors instead)
    case russianViolet
    case violetCrayola
    case fuschiaCrayola
    case persianPink
    case congoPink
    
    var value: UIColor {
        switch self {
        // MARK: - New Semantic Colors
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
            
        // MARK: - Legacy Colors (Deprecated)
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
            
        // MARK: - Legacy Colors (Deprecated)
        case .russianViolet:
            return #colorLiteral(red: 0.2666666667, green: 0.06666666667, blue: 0.3176470588, alpha: 1)
        case .violetCrayola:
            return #colorLiteral(red: 0.5333333333, green: 0.2117647059, blue: 0.4666666667, alpha: 1)
        case .fuschiaCrayola:
            return #colorLiteral(red: 0.7921568627, green: 0.3803921569, blue: 0.7647058824, alpha: 1)
        case .persianPink:
            return #colorLiteral(red: 0.9333333333, green: 0.5215686275, blue: 0.7098039216, alpha: 1)
        case .congoPink:
            return #colorLiteral(red: 1, green: 0.5843137255, blue: 0.5490196078, alpha: 1)
        }
    }
}

// MARK: - Convenience Extensions
extension UIColor {
    /// New semantic color system
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
    
    /// Legacy colors (Deprecated - use new semantic colors)
    @available(*, deprecated, message: "Use appBackground instead")
    static var appPrimaryBackground: UIColor { ColorAssets.primaryBackground.value }
    @available(*, deprecated, message: "Use appSurface instead")
    static var appSecondaryBackground: UIColor { ColorAssets.secondaryBackground.value }
    @available(*, deprecated, message: "Use appOnSurface instead")
    static var appPrimaryText: UIColor { ColorAssets.primaryText.value }
    @available(*, deprecated, message: "Use appOnSurfaceVariant instead")
    static var appSecondaryText: UIColor { ColorAssets.secondaryText.value }
    @available(*, deprecated, message: "Use appPrimary instead")
    static var appAccent: UIColor { ColorAssets.accent.value }
    @available(*, deprecated, message: "Use appSecondary instead")
    static var appSuccess: UIColor { ColorAssets.success.value }
    @available(*, deprecated, message: "Use appropriate semantic color")
    static var appWarning: UIColor { ColorAssets.warning.value }
}
