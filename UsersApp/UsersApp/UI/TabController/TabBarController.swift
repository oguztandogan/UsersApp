//
//  TabBarController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        UITabBar.appearance().barTintColor = .blue
        tabBar.tintColor = .brown
    }
}
