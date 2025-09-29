//
//  GetSavedUsersUseCaseTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class GetSavedUsersUseCaseTests: XCTestCase {
    var mockRepository: MockUsersRepository!
    var sut: GetSavedUsersUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUsersRepository()
        sut = GetSavedUsersUseCase(repository: mockRepository)
    }

    func test_execute_returnsUsers() async throws {
        let users = [UserEntity(id: UUID(), gender: nil, name: nil,
                                dateOfBirth: nil, phone: nil,
                                picture: nil, nationality: nil)]
        stub(mockRepository) { stub in
            when(stub.getSavedUsers()).thenReturn(users)
        }

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        verify(mockRepository).getSavedUsers()
    }

    func test_execute_propagatesError() async {
        stub(mockRepository) { stub in
            when(stub.getSavedUsers()).thenThrow(DomainError.persistenceError("fail"))
        }

        do {
            _ = try await sut.execute()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is DomainError)
        }
    }
}
