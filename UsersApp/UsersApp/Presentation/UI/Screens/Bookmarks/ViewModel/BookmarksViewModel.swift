//
//  BookmarksViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import CoreData
import Foundation

class BookmarksViewModel: BaseViewModel {
    weak var navigation: BookmarksNavigation!

    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol

    private let analyticsTracker: AnalyticsTrackerProtocol

    @Published var savedUsers: [UserEntity] = []
    init(navigation: BookmarksNavigation,
         getSavedUsersUseCase: GetSavedUsersUseCaseProtocol,
         deleteUserUseCase: DeleteUserUseCaseProtocol,
         analyticsTracker: AnalyticsTrackerProtocol = AnalyticsTracker()) {
        self.navigation = navigation
        self.getSavedUsersUseCase = getSavedUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.analyticsTracker = analyticsTracker
        super.init()
    }

    func onAppear() {
        analyticsTracker.trackScreenView("Bookmarks", screenClass: "BookmarksViewModel")
        fetchSavedUsers()
    }

    func createCellDataArray() -> [UserTableViewCellData] {
        return savedUsers.map { createCellData(for: $0) }
    }

    private func createCellData(for user: UserEntity) -> UserTableViewCellData {
        let usernameData = LabelViewData.primary(text: user.fullName)
        let nationalityData = LabelViewData.secondary(text: "Nationality: \(user.nationality ?? "Not specified")")
        let ageData = LabelViewData.secondary(text: "Age: \(user.dateOfBirth?.age?.description ?? "Not specified")")
        return UserTableViewCellData(
            imageUrl: user.picture?.medium ?? "",
            userNameData: usernameData,
            ageData: ageData,
            nationalityData: nationalityData,
            isSaved: true
        )
    }

    private func fetchSavedUsers() {
        Task {
            do {
                let users = try await getSavedUsersUseCase.execute()
                await MainActor.run {
                    savedUsers = users
                }
            } catch {
                await MainActor.run {
                    print("Error fetching saved users: \(error)")
                }
            }
        }
    }

    func favouriteButtonAction(index: Int) {
        Task {
            await deleteUser(index: index)
        }
    }

    func favouriteButtonAction(for user: UserEntity) {
        guard let index = savedUsers.firstIndex(where: { $0.id == user.id }) else {
            print("⚠️ User not found in saved users array")
            return
        }
        favouriteButtonAction(index: index)
    }

    func deleteUser(index: Int) async {
        let userId = savedUsers[index].id
        do {
            try await deleteUserUseCase.execute(userId: userId)
            _ = await MainActor.run {
                savedUsers.remove(at: index)
            }
        } catch {
            print("Error deleting user: \(error)")
        }
    }
}
