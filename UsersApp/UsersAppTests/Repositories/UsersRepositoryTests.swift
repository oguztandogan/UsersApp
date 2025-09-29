//
//  UsersRepositoryTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//


import XCTest
import Cuckoo
@testable import UsersApp

final class UsersRepositoryTests: XCTestCase {
    var mockRemote: MockUsersRemoteDataSourceProtocol!
    var mockLocal: MockUsersLocalDataSourceProtocol!
    var sut: UsersRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockRemote = MockUsersRemoteDataSourceProtocol()
        mockLocal = MockUsersLocalDataSourceProtocol()
        sut = UsersRepositoryImpl(remoteDataSource: mockRemote, localDataSource: mockLocal)
    }

    func test_getUsers_setsIsSavedFromLocal() async throws {
        // Arrange
        let user = UserEntity(id: UUID(), gender: "male", name: nil, dateOfBirth: nil, phone: nil, picture: nil, nationality: nil)
        let response = UsersResponse(users: [user], info: ResponseInfo(seed: "s", results: 1, page: 1, version: "1"))

        stub(mockRemote) { stub in
            when(stub.getUsers(pageNumber: any())).thenReturn(response)
        }
        stub(mockLocal) { stub in
            when(stub.isUserSaved(withId: any())).thenReturn(true)
        }

        // Act
        let result = try await sut.getUsers(pageNumber: "1")

        // Assert
        XCTAssertTrue(result.users.first?.isSaved == true)
    }

    func test_getUsers_propagatesNetworkErrorAsDomainError() async {
        stub(mockRemote) { stub in
            when(stub.getUsers(pageNumber: any())).thenThrow(NetworkError.noData)
        }

        do {
            _ = try await sut.getUsers(pageNumber: "1")
            XCTFail("Expected DomainError")
        } catch {
            guard case .networkError = error as? DomainError else {
                XCTFail("Wrong error: \(error)")
                return
            }
        }
    }

    func test_saveUser_failure_convertsToDomainError() async {
        let entity = UserEntity(id: UUID(), gender: nil, name: nil, dateOfBirth: nil, phone: nil, picture: nil, nationality: nil)
        stub(mockLocal) { stub in
            when(stub.saveUser(any())).thenThrow(CoreDataError.saveError("fail"))
        }

        do {
            try await sut.saveUser(entity)
            XCTFail("Expected DomainError.persistenceError")
        } catch {
            guard case .persistenceError = error as? DomainError else {
                XCTFail("Wrong error: \(error)")
                return
            }
        }
    }
}
