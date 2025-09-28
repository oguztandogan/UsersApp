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

    // Use Cases
    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    
    // Analytics
    private let analyticsTracker: AnalyticsTrackerProtocol

    // State
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

    func deleteUser(index: Int) async {
        let userId = savedUsers[index].id

        do {
            try await deleteUserUseCase.execute(userId: userId)
            
            await MainActor.run {
                savedUsers.remove(at: index)
            }
        } catch {
            await MainActor.run {
                print("Error deleting user: \(error)")
            }
        }
    }

    func setCellData(index: Int) -> UserTableViewCellData {
        let user = savedUsers[index]

        let usernameData = InformationItemLabelData(
            title: user.fullName,
            text: "",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let nationalityData = InformationItemLabelData(
            title: "Nationality:",
            text: user.nationality ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let ageData = InformationItemLabelData(
            title: "Age:",
            text: user.dateOfBirth?.age?.description ?? "Not specified",
            backgroundColor: .white,
            textColor: .purple,
            titleFontSize: 13,
            textFontSize: 12
        )
        let imageUrl = user.picture?.medium ?? "Not specified"

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
