//
//  UserDetailsViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import UIKit
import Combine

protocol UserDetailsNavigation : AnyObject {
    func goBackToHome()
}

class UserDetailsViewModel {
    weak var navigation: UserDetailsNavigation!
    @Published var user: User

    init(nav: UserDetailsNavigation,
         user: User) {
        self.navigation = nav
        self.user = user
    }
}
