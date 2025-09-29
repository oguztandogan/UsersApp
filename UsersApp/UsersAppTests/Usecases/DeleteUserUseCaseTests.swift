//
//  DeleteUserUseCaseTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class DeleteUserUseCaseTests: XCTestCase {
    var mockRepository: MockUsersRepository!
    var sut: DeleteUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUsersRepository()
        sut = DeleteUserUseCase(repository: mockRepository)
    }

    func test_execute_callsRepository() async throws {
        let userId = UUID()
        stub(mockRepository) { stub in
            when(stub.deleteUser(withId: any())).thenDoNothing()
        }

        try await sut.execute(userId: userId)

        verify(mockRepository).deleteUser(withId: equal(to: userId))
    }

    func test_execute_propagatesError() async {
        let userId = UUID()
        stub(mockRepository) { stub in
            when(stub.deleteUser(withId: any())).thenThrow(DomainError.persistenceError("fail"))
        }

        do {
            try await sut.execute(userId: userId)
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is DomainError)
        }
    }
}
