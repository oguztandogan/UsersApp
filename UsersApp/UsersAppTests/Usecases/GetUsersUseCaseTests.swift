//
//  GetUsersUseCaseTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp


final class GetUsersUseCaseTests: XCTestCase {
    var mockRepository: MockUsersRepository!
    var sut: GetUsersUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUsersRepository()
        sut = GetUsersUseCase(repository: mockRepository)
    }

    func test_execute_returnsResponse() async throws {
        // Arrange
        let response = UsersResponse(users: [], info: ResponseInfo(seed: "s", results: 1, page: 1, version: "1"))
        stub(mockRepository) { stub in
            when(stub.getUsers(pageNumber: any())).thenReturn(response)
        }

        // Act
        let result = try await sut.execute(pageNumber: "1")

        // Assert
        XCTAssertEqual(result.info.page, 1)
        verify(mockRepository).getUsers(pageNumber: equal(to: "1"))
    }

    func test_execute_propagatesError() async {
        stub(mockRepository) { stub in
            when(stub.getUsers(pageNumber: any())).thenThrow(DomainError.networkError("fail"))
        }

        do {
            _ = try await sut.execute(pageNumber: "1")
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is DomainError)
        }
    }
}
