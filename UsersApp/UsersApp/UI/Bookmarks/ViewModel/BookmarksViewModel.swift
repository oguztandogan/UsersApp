//
//  BookmarksViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import CoreData

protocol BookmarksNavigation: AnyObject {}

class BookmarksViewModel: BaseViewModel {
    weak var navigation: BookmarksNavigation!
    @Published var users: [User] = []
    @Published var savedUsers = [SavedUser]()

    init(nav: BookmarksNavigation) {
        self.navigation = nav
    }

    func onAppear() {

        do {
            savedUsers = try coreDataService.fetchSavedItems()
        } catch {
            print("asdf")
        }
    }

    func favouriteButtonAction(index: Int) {
        Task {
            self.deleteUser(index: index)
        }
    }

    func deleteUser(index: Int) {
        do {
            try coreDataService.deleteItem(deletedTask: savedUsers[index])
            savedUsers.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }

    func setCellData(index: Int) -> UserTableViewCellData {
        let usernameData = InformationItemLabelData(
            title: savedUsers[index].userName ?? "Not specified",
            text: "",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let nationalityData = InformationItemLabelData(
            title: "Nationality:",
            text: savedUsers[index].userNationality ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let ageData = InformationItemLabelData(
            title: "Age:",
            text: savedUsers[index].userAge ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let imageUrl = savedUsers[index].userPictureUrl ?? "Not specified"
        let cellData = UserTableViewCellData(
            imageUrl: imageUrl,
            userNameData: usernameData,
            ageData: ageData,
            nationalityData: nationalityData,
            isSaved: true
        )
        return cellData
    }
}
