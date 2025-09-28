//
//  LabelViewData.swift
//  UsersApp
//
//  Created by UsersApp on 28.09.2025.
//

import UIKit

struct LabelViewData {
    let text: String?
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let numberOfLines: Int
    let backgroundColor: UIColor?
    
    // MARK: - Initializer
    init(text: String? = nil,
         textColor: UIColor = .appOnSurface,
         font: UIFont = UIFont.systemFont(ofSize: 16),
         textAlignment: NSTextAlignment = .left,
         numberOfLines: Int = 1,
         backgroundColor: UIColor? = nil) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Predefined Styles
extension LabelViewData {
    
    /// Primary text style (for user names, titles)
    static func primary(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appOnSurface,
            font: UIFont.systemFont(ofSize: 16, weight: .black),
            textAlignment: .left,
            numberOfLines: 1
        )
    }
    
    /// Secondary text style (for job titles, subtitles)
    static func secondary(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appOnSurfaceVariant,
            font: UIFont.systemFont(ofSize: 14, weight: .regular),
            textAlignment: .left,
            numberOfLines: 1
        )
    }
    
    /// Caption text style (for small text)
    static func caption(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appOnSurfaceVariant,
            font: UIFont.systemFont(ofSize: 12, weight: .regular),
            textAlignment: .left,
            numberOfLines: 1
        )
    }
    
    /// Large title style
    static func largeTitle(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appOnSurface,
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            textAlignment: .left,
            numberOfLines: 1
        )
    }
    
    /// Error text style
    static func error(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appError,
            font: UIFont.systemFont(ofSize: 14, weight: .medium),
            textAlignment: .left,
            numberOfLines: 0
        )
    }
    
    /// Primary accent style
    static func accent(text: String? = nil) -> LabelViewData {
        return LabelViewData(
            text: text,
            textColor: .appPrimary,
            font: UIFont.systemFont(ofSize: 16, weight: .medium),
            textAlignment: .left,
            numberOfLines: 1
        )
    }
}
