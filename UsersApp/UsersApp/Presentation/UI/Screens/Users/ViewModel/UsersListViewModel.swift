//
//  UsersListViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Combine
import Foundation

class UsersListViewModel: BaseViewModel {
    weak var navigation: UsersNavigation!

    private let getUsersUseCase: GetUsersUseCaseProtocol
    private let getSavedUsersUseCase: GetSavedUsersUseCaseProtocol
    private let saveUserUseCase: SaveUserUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol

    private let analyticsTracker: AnalyticsTrackerProtocol

    var pageNumber: Int = 1
    @Published var users: [UserEntity] = []
    @Published var savedUsers: [UserEntity] = []
    init(navigation: UsersNavigation,
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

    func createCellDataArray() -> [UserTableViewCellData] {
        return users.map { createCellData(for: $0) }
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
            isSaved: user.isSaved
        )
    }

    func fetchUsers(isPagination: Bool, isRefreshing: Bool) {
        if isPagination {
            analyticsTracker.trackUsersListPagination(pageNumber: pageNumber + 1)
        } else if isRefreshing {
            analyticsTracker.trackUsersListRefreshed()
        }

        setLoading(true)
        clearError()

        Task(priority: .background) {
            do {
                let usersResponse = try await getUsersUseCase.execute(pageNumber: pageNumber.description)
                await MainActor.run {
                    if isPagination {
                        pageNumber += 1
                        users += usersResponse.users
                    } else {
                        pageNumber = 1
                        users = usersResponse.users
                    }
                    setLoading(false)
                }
            } catch {
                await MainActor.run {
                    analyticsTracker.trackError(error, context: "fetch_users")
                    setError("error.failed_to_load_users".localized)
                    setLoading(false)
                    print("Error fetching users: \(error)")
                }
            }
        }
    }

    func fetchSavedUsers() {
        Task {
            do {
                let savedUsersResult = try await getSavedUsersUseCase.execute()
                await MainActor.run {
                    savedUsers = savedUsersResult
                    compareSavedUsersAndFetchedUsers()
                }
            } catch {
                await MainActor.run {
                    print("Error fetching saved users: \(error)")
                    compareSavedUsersAndFetchedUsers()
                }
            }
        }
    }

    func compareSavedUsersAndFetchedUsers() {
        let savedUserIds = Set(savedUsers.map { $0.id })
        for index in 0 ..< users.count {
            users[index].isSaved = savedUserIds.contains(users[index].id)
        }
    }

    func navigateToUserDetails(index: Int) {
        let user = users[index]
        analyticsTracker.trackUserDetailsOpened(userId: user.id.uuidString, source: "list_tap")
        navigation.navigateToUserDetails(with: user)
    }

    func navigateToUserDetails(for user: UserEntity) {
        analyticsTracker.trackUserDetailsOpened(userId: user.id.uuidString, source: "list_tap")
        navigation.navigateToUserDetails(with: user)
    }

    func favouriteButtonAction(index: Int) {
        let user = users[index]
        let isAdding = !user.isSaved
        analyticsTracker.trackBookmarkToggled(userId: user.id.uuidString, isAdding: isAdding, source: "user_list")
        if user.isSaved {
            users[index].isSaved = false
            deleteUser(index: index)

            if RemoteConfigManager.shared.isBookmarkSyncEnabled {
                print("🔄 Would remove from cloud: \(user.id)")
            }
        } else {
            users[index].isSaved = true
            saveUser(index: index)

            if RemoteConfigManager.shared.isBookmarkSyncEnabled {
                print("🔄 Would add to cloud: \(user.id)")
            }
        }
    }

    func favouriteButtonAction(for user: UserEntity) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            print("⚠️ User not found in current users array")
            return
        }
        favouriteButtonAction(index: index)
    }

    private func deleteUser(index: Int) {
        let userId = users[index].id
        Task {
            do {
                try await deleteUserUseCase.execute(userId: userId)
                await MainActor.run {
                    savedUsers.removeAll { $0.id == userId }
                }
            } catch {
                await MainActor.run {
                    print("Error deleting user: \(error)")

                    users[index].isSaved = true
                }
            }
        }
    }

    private func saveUser(index: Int) {
        let user = users[index]
        Task {
            do {
                try await saveUserUseCase.execute(user)
                await MainActor.run {
                    savedUsers.append(user)
                }
            } catch {
                await MainActor.run {
                    print("Error saving user: \(error)")

                    users[index].isSaved = false
                }
            }
        }
    }
}
