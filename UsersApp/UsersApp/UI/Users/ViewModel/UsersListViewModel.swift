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
class UsersListViewModel: BaseViewModel {
    weak var navigation: UserListNavigation!
    var service: UsersServiceable
    var pageNumber: Int = 1
    @Published var users: [User] = []
    @Published var savedUsers = [SavedUser]()

    init(nav: UserListNavigation,
         service: UsersServiceable) {
        self.navigation = nav
        self.service = service
    }

    func onAppear() {
        fetchUsers(isPagination: false, isRefreshing: false)
    }

    func viewWillAppear() {
        fetchSavedUsers()
    }

    func setCellData(index: Int) -> UserTableViewCellData {
        let usernameData = InformationItemLabelData(
            title: users[index].fullName,
            text: "",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let nationalityData = InformationItemLabelData(
            title: "Nationality:",
            text: users[index].nationality ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let ageData = InformationItemLabelData(
            title: "Age:",
            text: users[index].dateOfBirth?.age?.description ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let imageUrl = users[index].picture?.medium ?? "Not specified"
        let isSaved = users[index].isSaved
        let cellData = UserTableViewCellData(
            imageUrl: imageUrl,
            userNameData: usernameData,
            ageData: ageData,
            nationalityData: nationalityData,
            isSaved: isSaved
        )
        return cellData
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

    func fetchSavedUsers() {
        do {
            savedUsers = try coreDataService.fetchSavedItems()
        } catch {
            print("asdf")
        }
            compareSavedUsersAndFetchedUsers()
    }

    func compareSavedUsersAndFetchedUsers() {
        for user in 0..<users.count {
            let matchingUUIDs = savedUsers.map { $0.id }
            users[user].isSaved = matchingUUIDs.contains(users[user].uuid)
        }
    }

    func navigateToUserDetails(index: Int) {
        navigation.navigateToUserDetails(selectedUserData: users[index])
    }

    func favouriteButtonAction(index: Int) {
        if users[index].isSaved {
            users[index].isSaved = false
            self.deleteUser(index: index)
        } else {
            users[index].isSaved = true
            self.saveUser(index: index)
        }
    }

    func deleteUser(index: Int) {
        if let matchingItem = savedUsers.first(where: { $0.id == users[index].uuid }) {
            do {
                try coreDataService.deleteItem(deletedTask: matchingItem)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveUser(index: Int) {
        let managedContext = coreDataService.viewContext
        users[index].isSaved = true
         managedContext.perform {
            let newUser = SavedUser(context: managedContext)
             newUser.id = self.users[index].uuid
             newUser.userName = self.users[index].fullName
             newUser.userAge = self.users[index].dateOfBirth?.age?.description
             newUser.userNationality = self.users[index].nationality
             newUser.userPictureUrl = self.users[index].picture?.medium
            self.savedUsers.append(newUser)
            do {
                try self.coreDataService.saveContext()
            } catch {
                print(error.localizedDescription)
            }
        }

    }

}
