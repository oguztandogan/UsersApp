//
//  DateFormatter+Extensions.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
