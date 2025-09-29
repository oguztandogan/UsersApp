//
//  String+Localization.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

extension String {
    /// Returns the localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    /// Returns the localized version of the string with arguments
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
