//
//  SaveUserUseCaseTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class SaveUserUseCaseTests: XCTestCase {
    var mockRepository: MockUsersRepository!
    var sut: SaveUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUsersRepository()
        sut = SaveUserUseCase(repository: mockRepository)
    }

    func test_execute_callsRepository() async throws {
        // Arrange
        let user = UserEntity(id: UUID(), gender: nil, name: nil,
                              dateOfBirth: nil, phone: nil,
                              picture: nil, nationality: nil)
        stub(mockRepository) { stub in
            when(stub.saveUser(any())).thenDoNothing()
        }

        // Act
        try await sut.execute(user)

        // Assert
        verify(mockRepository).saveUser(equal(to: user))
    }

    func test_execute_propagatesError() async {
        let user = UserEntity(id: UUID(), gender: nil, name: nil,
                              dateOfBirth: nil, phone: nil,
                              picture: nil, nationality: nil)
        stub(mockRepository) { stub in
            when(stub.saveUser(any())).thenThrow(DomainError.persistenceError("fail"))
        }

        do {
            try await sut.execute(user)
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is DomainError)
        }
    }
}
