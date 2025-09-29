//
//  UserDetailsViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Combine
import Foundation
import UIKit

class UserDetailsViewModel: BaseViewModel {
    weak var navigation: UserDetailsNavigation!

    private let saveUserUseCase: SaveUserUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol

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
        let nationalityData = LabelViewData.secondary(text: "user_details.nationality".localized(user.nationality ?? "user_details.not_specified".localized))
        let ageData = LabelViewData.secondary(text: "user_details.age".localized(user.dateOfBirth?.age?.description ?? "user_details.not_specified".localized))
        let phoneNumberData = LabelViewData.secondary(text: "user_details.phone".localized(user.phone ?? "user_details.not_specified".localized))
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
        setLoading(true)
        clearError()

        Task {
            do {
                try await deleteUserUseCase.execute(userId: user.id)
                await MainActor.run {
                    savedUsers.removeAll { $0.id == user.id }
                    setLoading(false)
                }
            } catch {
                await MainActor.run {
                    print("Error deleting user: \(error)")
                    setError("error.failed_to_remove_user".localized)
                    user.isSaved = true
                    setLoading(false)
                }
            }
        }
    }

    private func saveUser() {
        setLoading(true)
        clearError()

        Task {
            do {
                try await saveUserUseCase.execute(user)
                await MainActor.run {
                    savedUsers.append(user)
                    setLoading(false)
                }
            } catch {
                await MainActor.run {
                    print("Error saving user: \(error)")
                    setError("error.failed_to_save_user".localized)
                    user.isSaved = false
                    setLoading(false)
                }
            }
        }
    }
}
