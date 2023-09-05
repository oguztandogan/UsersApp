//
//  UsersListTests.swift
//  UsersAppTests
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import Foundation
import XCTest
@testable import UsersApp

class UsersListViewModelTests: XCTestCase {

    var viewModel: UsersListViewModel!

    override func setUp() {
        super.setUp()
        let usersServiceMock = UsersServiceMock()
        viewModel = UsersListViewModel(nav: MockUserListNavigation(), service: usersServiceMock)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    func testOnAppear() {
        viewModel.onAppear()
        XCTAssertEqual(viewModel.pageNumber, 1)
    }

    func testFetchUsers() {
        let expectation = XCTestExpectation(description: "Fetch Users")
        viewModel.pageNumber = 1
        viewModel.fetchUsers(isPagination: true, isRefreshing: false)

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.users[0].name?.first, "Aria")
        XCTAssertEqual(viewModel.users.count, 25)
    }
}

class MockUserListNavigation: UserListNavigation {
    func navigateToUserDetails(selectedUserData: User) {
        //
    }
}
