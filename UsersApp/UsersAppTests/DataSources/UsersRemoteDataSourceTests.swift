//
//  UsersRemoteDataSourceTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class UsersRemoteDataSourceTests: XCTestCase {
    var mockNetwork: MockUsersNetworkServiceProtocol!
    var sut: UsersRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockNetwork = MockUsersNetworkServiceProtocol()
        sut = UsersRemoteDataSource(networkService: mockNetwork)
    }

    func test_getUsers_success() async throws {
        let response = UsersResponse(users: [], info: ResponseInfo(seed: "s", results: 1, page: 1, version: "1"))
        stub(mockNetwork) { stub in
            when(stub.getUsers(page: any(), results: any())).thenReturn(response)
        }

        let result = try await sut.getUsers(pageNumber: "1")

        XCTAssertEqual(result.info.page, 1)
        verify(mockNetwork).getUsers(page: any(), results: any())
    }

    func test_getUsers_failure() async {
        stub(mockNetwork) { stub in
            when(stub.getUsers(page: any(), results: any())).thenThrow(NetworkError.noData)
        }

        do {
            _ = try await sut.getUsers(pageNumber: "1")
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
