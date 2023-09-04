//
//  UsersListViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Combine

protocol UserListNavigation: AnyObject {
    func navigateToUserDetails(selectedUserData: User)
}
class UsersListViewModel {
    weak var navigation: UserListNavigation!
    var service: UsersService
    @Published var users: [User] = []

    init(nav: UserListNavigation,
         service: UsersService) {
        self.navigation = nav
        self.service = service
    }

    func onAppear() {
        Task(priority: .background) {
          let result = await service.getUsers()
          switch result {
          case .success(let usersResponse):
              users = usersResponse.results
          case .failure(let error):
              print(error)
          }
        }
    }

    func navigateToUserDetails(index: Int) {
        navigation.navigateToUserDetails(selectedUserData: users[index])
    }

}
