//
//  UsersListViewModelTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class UsersListViewModelTests: XCTestCase {
    var mockNavigation: MockUsersNavigation!
    var mockGetUsers: MockGetUsersUseCaseProtocol!
    var mockGetSavedUsers: MockGetSavedUsersUseCaseProtocol!
    var mockSaveUser: MockSaveUserUseCaseProtocol!
    var mockDeleteUser: MockDeleteUserUseCaseProtocol!
    var sut: UsersListViewModel!

    override func setUp() {
        super.setUp()
        mockNavigation = MockUsersNavigation()
        mockGetUsers = MockGetUsersUseCaseProtocol()
        mockGetSavedUsers = MockGetSavedUsersUseCaseProtocol()
        mockSaveUser = MockSaveUserUseCaseProtocol()
        mockDeleteUser = MockDeleteUserUseCaseProtocol()

        sut = UsersListViewModel(
            navigation: mockNavigation,
            getUsersUseCase: mockGetUsers,
            getSavedUsersUseCase: mockGetSavedUsers,
            saveUserUseCase: mockSaveUser,
            deleteUserUseCase: mockDeleteUser
        )
    }

    func test_onAppear_fetchesUsers() async throws {
        // Arrange
        let response = UsersResponse(users: [UserEntity(id: UUID(),
                                                        gender: nil,
                                                        name: nil,
                                                        dateOfBirth: nil,
                                                        phone: nil,
                                                        picture: nil,
                                                        nationality: nil)],
                                     info: ResponseInfo(seed: nil, results: 1, page: 1, version: nil))
        stub(mockGetUsers) { stub in
            when(stub.execute(pageNumber: any())).thenReturn(response)
        }

        // Act
        sut.onAppear()
        try await Task.sleep(nanoseconds: 200_000_000) // küçük delay

        // Assert
        XCTAssertEqual(sut.users.count, 1)
        verify(mockGetUsers).execute(pageNumber: any())
    }

    func test_fetchUsers_paginationAppendsUsers() async throws {
        let firstUser = UserEntity(id: UUID(), gender: nil, name: nil,
                                   dateOfBirth: nil, phone: nil, picture: nil,
                                   nationality: nil)
        let secondUser = UserEntity(id: UUID(), gender: nil, name: nil,
                                    dateOfBirth: nil, phone: nil, picture: nil,
                                    nationality: nil)

        let firstResponse = UsersResponse(users: [firstUser],
                                          info: ResponseInfo(seed: nil, results: 1, page: 1, version: nil))
        let secondResponse = UsersResponse(users: [secondUser],
                                           info: ResponseInfo(seed: nil, results: 1, page: 2, version: nil))

        stub(mockGetUsers) { stub in
            when(stub.execute(pageNumber: equal(to: "1"))).thenReturn(firstResponse)
            when(stub.execute(pageNumber: equal(to: "2"))).thenReturn(secondResponse)
        }

        // İlk fetch
        let exp1 = expectation(description: "First fetch done")
        let cancellable1 = sut.$users.dropFirst().sink { _ in exp1.fulfill() }
        sut.fetchUsers(isPagination: false, isRefreshing: false)
        await fulfillment(of: [exp1], timeout: 1.0)
        cancellable1.cancel()

        XCTAssertEqual(sut.users.count, 1)

        // Pagination
        let exp2 = expectation(description: "Pagination fetch done")
        let cancellable2 = sut.$users.dropFirst(1).sink { _ in exp2.fulfill() }
        sut.fetchUsers(isPagination: true, isRefreshing: false)
        await fulfillment(of: [exp2], timeout: 2.0) // timeout'u 2 yap
        cancellable2.cancel()

        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.pageNumber, 2)
    }

    func test_fetchSavedUsers_setsSavedUsersAndUpdatesFlags() async throws {
        let id = UUID()
        let user = UserEntity(
            id: id,
            gender: nil,
            name: nil,
            dateOfBirth: nil,
            phone: nil,
            picture: nil,
            nationality: nil
        )
        sut.users = [user]

        let savedUser = UserEntity(
            id: id,
            gender: nil,
            name: nil,
            dateOfBirth: nil,
            phone: nil,
            picture: nil,
            nationality: nil,
            isSaved: true
        )

        stub(mockGetSavedUsers) { stub in
            when(stub.execute()).thenReturn([savedUser])
        }

        sut.fetchSavedUsers()
        try await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertTrue(sut.users.first?.isSaved == true)
        XCTAssertEqual(sut.savedUsers.count, 1)
    }

    func test_favouriteButtonAction_addsUser() async throws {
        let user = UserEntity(id: UUID(), gender: nil, name: nil,
                              dateOfBirth: nil, phone: nil, picture: nil,
                              nationality: nil, isSaved: false)
        sut.users = [user]

        stub(mockSaveUser) { stub in
            when(stub.execute(any())).thenDoNothing()
        }

        sut.favouriteButtonAction(index: 0)
        try await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertTrue(sut.users.first?.isSaved == true)
        XCTAssertEqual(sut.savedUsers.count, 1)
        verify(mockSaveUser).execute(any())
    }

    func test_favouriteButtonAction_removesUser() async throws {
        let user = UserEntity(id: UUID(), gender: nil, name: nil,
                              dateOfBirth: nil, phone: nil, picture: nil,
                              nationality: nil, isSaved: true)
        sut.users = [user]
        sut.savedUsers = [user]

        stub(mockDeleteUser) { stub in
            when(stub.execute(userId: any())).thenDoNothing()
        }

        sut.favouriteButtonAction(index: 0)
        try await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertTrue(sut.users.first?.isSaved == false)
        XCTAssertEqual(sut.savedUsers.count, 0)
        verify(mockDeleteUser).execute(userId: equal(to: user.id))
    }
}
