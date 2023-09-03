//
//  UsersListViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

class UsersListViewModel {
    weak var navigation : UserListNavigation!
    
    init(nav : UserListNavigation) {
        self.navigation = nav
    }
    
    func navigateToUserDetails(){
        navigation.navigateToUserDetails()
    }
}
protocol UserListNavigation : AnyObject {
    func navigateToUserDetails()
}
