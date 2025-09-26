//
//  UsersListViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Combine

protocol UserListNavigation: AnyObject {
    func navigateToUserDetails(selectedUserData: UserEntity)
}

class UsersListViewModel: BaseViewModel {
    weak var navigation: UserListNavigation!
    
    // Use Cases
    private let getUsersUseCase: GetUsersUseCaseProtocol
    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol
    private let saveUserUseCase: SaveUserUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    
    // Analytics
    private let analyticsTracker: AnalyticsTrackerProtocol
    
    // State
    var pageNumber: Int = 1
    @Published var users: [UserEntity] = []
    @Published var savedUsers: [UserEntity] = []

    init(navigation: UserListNavigation,
         getUsersUseCase: GetUsersUseCaseProtocol,
         getSavedUsersUseCase: GetSavedUsersUseCaseProtocol,
         saveUserUseCase: SaveUserUseCaseProtocol,
         deleteUserUseCase: DeleteUserUseCaseProtocol,
         analyticsTracker: AnalyticsTrackerProtocol = AnalyticsTracker()) {
        self.navigation = navigation
        self.getUsersUseCase = getUsersUseCase
        self.getSavedUsersUseCase = getSavedUsersUseCase
        self.saveUserUseCase = saveUserUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.analyticsTracker = analyticsTracker
        super.init()
    }

    func onAppear() {
        analyticsTracker.trackUsersListViewed(source: "app_launch")
        fetchUsers(isPagination: false, isRefreshing: false)
    }

    func viewWillAppear() {
        fetchSavedUsers()
    }

    func setCellData(index: Int) -> UserTableViewCellData {
        let user = users[index]

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
        let isSaved = user.isSaved

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
        if isPagination {
            analyticsTracker.trackUsersListPagination(pageNumber: pageNumber + 1)
        } else if isRefreshing {
            analyticsTracker.trackUsersListRefreshed()
        }
        
        Task(priority: .background) {
            let result = await getUsersUseCase.execute(pageNumber: pageNumber.description)

            await MainActor.run {
                switch result {
                case .success(let usersResponse):
                    if isPagination {
                        pageNumber += 1
                        users += usersResponse.users
                    } else {
                        pageNumber = 1
                        users = usersResponse.users
                    }
                case .failure(let error):
                    analyticsTracker.trackError(error, context: "fetch_users")
                    print("Error fetching users: \(error)")
                }
            }
        }
    }

    func fetchSavedUsers() {
        Task {
            let result = await getSavedUsersUseCase.execute()

            await MainActor.run {
                switch result {
                case .success(let savedUsersResult):
                    savedUsers = savedUsersResult
                case .failure(let error):
                    print("Error fetching saved users: \(error)")
                }
                compareSavedUsersAndFetchedUsers()
            }
        }
    }

    func compareSavedUsersAndFetchedUsers() {
        let savedUserIds = Set(savedUsers.map { $0.id })
        for index in 0..<users.count {
            users[index].isSaved = savedUserIds.contains(users[index].id)
        }
    }

    func navigateToUserDetails(index: Int) {
        let user = users[index]
        analyticsTracker.trackUserDetailsOpened(userId: user.id.uuidString, source: "list_tap")
        navigation.navigateToUserDetails(selectedUserData: user)
    }

    func favouriteButtonAction(index: Int) {
        let user = users[index]
        let isAdding = !user.isSaved
        
        analyticsTracker.trackBookmarkToggled(userId: user.id.uuidString, isAdding: isAdding, source: "user_list")
        
        if user.isSaved {
            users[index].isSaved = false
            deleteUser(index: index)
            
            // Remove from cloud if sync enabled
            if RemoteConfigManager.shared.isBookmarkSyncEnabled {
                // TODO: Cloud sync removal
                print("🔄 Would remove from cloud: \(user.id)")
            }
        } else {
            users[index].isSaved = true
            saveUser(index: index)
            
            // Add to cloud if sync enabled  
            if RemoteConfigManager.shared.isBookmarkSyncEnabled {
                // TODO: Cloud sync addition
                print("🔄 Would add to cloud: \(user.id)")
            }
        }
    }

    private func deleteUser(index: Int) {
        let userId = users[index].id

        Task {
            let result = await deleteUserUseCase.execute(userId: userId)

            await MainActor.run {
                switch result {
                case .success:
                    // Remove from saved users array
                    savedUsers.removeAll { $0.id == userId }
                case .failure(let error):
                    print("Error deleting user: \(error)")
                    // Revert the UI state
                    users[index].isSaved = true
                }
            }
        }
    }

    private func saveUser(index: Int) {
        let user = users[index]

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
                    users[index].isSaved = false
                }
            }
        }
    }
}
