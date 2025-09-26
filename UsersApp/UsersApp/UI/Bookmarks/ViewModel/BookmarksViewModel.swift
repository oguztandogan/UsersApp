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

    // State
    @Published var savedUsers: [UserEntity] = []

    init(navigation: BookmarksNavigation,
         getSavedUsersUseCase: GetSavedUsersUseCaseProtocol,
         deleteUserUseCase: DeleteUserUseCaseProtocol) {
        self.navigation = navigation
        self.getSavedUsersUseCase = getSavedUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        super.init()
    }

    func onAppear() {
        fetchSavedUsers()
    }

    private func fetchSavedUsers() {
        Task {
            let result = await getSavedUsersUseCase.execute()

            await MainActor.run {
                switch result {
                case .success(let users):
                    savedUsers = users
                case .failure(let error):
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

        let result = await deleteUserUseCase.execute(userId: userId)

        await MainActor.run {
            switch result {
            case .success:
                savedUsers.remove(at: index)
            case .failure(let error):
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
