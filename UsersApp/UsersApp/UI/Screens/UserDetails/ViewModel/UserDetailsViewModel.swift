//
//  UserDetailsViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import UIKit
import Combine

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
        let usernameData = LabelViewData.largeTitle(text: user.fullName)
        let nationalityData = LabelViewData.secondary(text: "Nationality: \(user.nationality ?? "Not specified")")
        let ageData = LabelViewData.secondary(text: "Age: \(user.dateOfBirth?.age?.description ?? "Not specified")")
        let phoneNumberData = LabelViewData.secondary(text: "Phone: \(user.phone ?? "Not specified")")
        
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
            do {
                try await deleteUserUseCase.execute(userId: user.id)
                
                await MainActor.run {
                    // Remove from saved users array
                    savedUsers.removeAll { $0.id == user.id }
                }
            } catch {
                await MainActor.run {
                    print("Error deleting user: \(error)")
                    // Revert the UI state
                    user.isSaved = true
                }
            }
        }
    }

    private func saveUser() {
        Task {
            do {
                try await saveUserUseCase.execute(user)
                
                await MainActor.run {
                    // Add to saved users array
                    savedUsers.append(user)
                }
            } catch {
                await MainActor.run {
                    print("Error saving user: \(error)")
                    // Revert the UI state
                    user.isSaved = false
                }
            }
        }
    }
}
