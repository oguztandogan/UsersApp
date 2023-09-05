//
//  UserDetailsViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import UIKit
import Combine

protocol UserDetailsNavigation: AnyObject {
    func goBackToHome()
}

class UserDetailsViewModel {
    weak var navigation: UserDetailsNavigation!
    var coreDataService: CoreDataService
    @Published var user: User
    @Published var savedUsers = [SavedUser]()

    init(nav: UserDetailsNavigation,
         user: User,
         coreDataService: CoreDataService) {
        self.navigation = nav
        self.user = user
        self.coreDataService = coreDataService
    }

    func getContentViewData() -> UserDetailsContentViewData {
        let usernameData = InformationItemLabelData(
            title: "Full Name: ",
            text: user.fullName,
            backgroundColor: .purple,
            textColor: .white,
            titleFontSize: 17,
            textFontSize: 15
        )
        let nationalityDaya = InformationItemLabelData(
            title: "Nationality: ",
            text: user.nationality ?? "Not specified",
            backgroundColor: .purple,
            textColor: .white,
            titleFontSize: 17,
            textFontSize: 15
        )
        let ageData = InformationItemLabelData(
            title: "Age: ",
            text: user.dateOfBirth?.age?.description ?? "Not specified",
            backgroundColor: .purple,
            textColor: .white,
            titleFontSize: 17,
            textFontSize: 15
        )
        let phoneNumberData = InformationItemLabelData(
            title: "Phone Number: ",
            text: user.phone ?? "Not specified",
            backgroundColor: .purple,
            textColor: .white,
            titleFontSize: 17,
            textFontSize: 15
        )
        let contentViewData = UserDetailsContentViewData(
            imageUrl: user.picture?.large ?? "",
            username: usernameData,
            nationality: nationalityDaya,
            age: ageData,
            phoneNumber: phoneNumberData
        )
        return contentViewData
    }

    func favouriteButtonAction() {
        if user.isSaved {
            user.isSaved = false
            Task {
                await self.deleteUser()
            }
        } else {
            user.isSaved = true
            Task {
                await self.saveUser()
            }
        }
    }

    func deleteUser() async {
        if let matchingItem = savedUsers.first(where: { $0.id == user.uuid }) {
            do {
                try await coreDataService.deleteItem(deletedTask: matchingItem)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveUser() async {
        let managedContext = coreDataService.viewContext
        user.isSaved = true
        let newUser = SavedUser(context: managedContext)
        newUser.id = user.uuid
        newUser.userName = user.fullName
        newUser.userAge = user.dateOfBirth?.age?.description
        newUser.userNationality = user.nationality
        newUser.userPictureUrl = user.picture?.medium
        self.savedUsers.append(newUser)
        do {
            try await coreDataService.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}
