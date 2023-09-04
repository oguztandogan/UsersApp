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
    var pageNumber: Int = 1
    @Published var users: [User] = []

    init(nav: UserListNavigation,
         service: UsersService) {
        self.navigation = nav
        self.service = service
    }

    func onAppear() {
        fetchUsers(isPagination: false, isRefreshing: false)
    }

    func fetchUsers(isPagination: Bool, isRefreshing: Bool) {
        Task(priority: .background) {
            let result = await service.getUsers(pageNumber: pageNumber.description)
          switch result {
          case .success(let usersResponse):
              if isPagination {
                  pageNumber += 1
                  users += usersResponse.results
              } else {
                  pageNumber = 1
                  users = usersResponse.results
              }
          case .failure(let error):
              print(error)
          }
        }
    }

    func navigateToUserDetails(index: Int) {
        navigation.navigateToUserDetails(selectedUserData: users[index])
    }

}
