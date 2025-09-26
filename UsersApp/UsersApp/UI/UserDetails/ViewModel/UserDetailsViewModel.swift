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

class UserDetailsViewModel: BaseViewModel {
    weak var navigation: UserDetailsNavigation!

    // Use Cases
    private let saveUserUseCase: SaveUserUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol

    // State
    @Published var user: UserEntity
    @Published var savedUsers: [UserEntity] = []

    init(navigation: UserDetailsNavigation,
         user: UserEntity,
         saveUserUseCase: SaveUserUseCaseProtocol,
         deleteUserUseCase: DeleteUserUseCaseProtocol,
         getSavedUsersUseCase: GetSavedUsersUseCaseProtocol) {
        self.navigation = navigation
        self.user = user
        self.saveUserUseCase = saveUserUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.getSavedUsersUseCase = getSavedUsersUseCase
        super.init()
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
        let nationalityData = InformationItemLabelData(
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
            nationality: nationalityData,
            age: ageData,
            phoneNumber: phoneNumberData
        )
        return contentViewData
    }

    func favouriteButtonAction() {
        if user.isSaved {
            user.isSaved = false
            deleteUser()
        } else {
            user.isSaved = true
            saveUser()
        }
    }

    private func deleteUser() {
        Task {
            let result = await deleteUserUseCase.execute(userId: user.id)

            await MainActor.run {
                switch result {
                case .success:
                    // Remove from saved users array
                    savedUsers.removeAll { $0.id == user.id }
                case .failure(let error):
                    print("Error deleting user: \(error)")
                    // Revert the UI state
                    user.isSaved = true
                }
            }
        }
    }

    private func saveUser() {
        Task {
            let result = await saveUserUseCase.execute(user)

            await MainActor.run {
                switch result {
                case .success:
                    // Add to saved users array
                    savedUsers.append(user)
                case .failure(let error):
                    print("Error saving user: \(error)")
                    // Revert the UI state
                    user.isSaved = false
                }
            }
        }
    }
}
