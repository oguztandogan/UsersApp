//
//  ColorAssets.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import UIKit

enum ColorAssets {
    
    typealias Value = UIColor
    
    case russianViolet
    case violetCrayola
    case fuschiaCrayola
    case persianPink
    case congoPink
    
    var value: UIColor {
        switch self {
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
