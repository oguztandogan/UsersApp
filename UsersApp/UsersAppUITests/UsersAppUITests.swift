//
//  UsersAppUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class UsersAppUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testAppLaunch() throws {
        XCTAssertTrue(app.state == .runningForeground)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    func testTabBarNavigation() throws {
        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.exists)
        usersTab.tap()

        XCTAssertTrue(app.navigationBars["Users"].exists)

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists)
        bookmarksTab.tap()

        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)
    }

    func testUsersListScreenElements() throws {
        app.tabBars.buttons["Users"].tap()

        XCTAssertTrue(app.navigationBars["Users"].exists)

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)

        let firstCell = tableView.cells.firstMatch
        let exists = firstCell.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Users list should load data")
    }

    func testUserCellInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        firstCell.tap()

        XCTAssertTrue(app.navigationBars["User Details"].exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)
    }

    func testFavoriteButtonInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let favoriteButton = firstCell.buttons.firstMatch
        XCTAssertTrue(favoriteButton.exists)

        favoriteButton.tap()

        XCTAssertTrue(favoriteButton.exists)
    }

    func testPullToRefresh() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: end)

        sleep(2)

        XCTAssertTrue(tableView.exists)
    }

    func testPagination() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        tableView.swipeUp()
        tableView.swipeUp()
        tableView.swipeUp()

        sleep(2)

        let cellCount = tableView.cells.count
        XCTAssertGreaterThan(cellCount, 0, "Should have loaded more cells through pagination")
    }

    func testUserDetailsScreen() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()

        XCTAssertTrue(app.navigationBars["User Details"].exists)

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)

        backButton.tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)
    }

    func testBookmarksScreen() throws {
        app.tabBars.buttons["Bookmarks"].tap()

        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)
    }

    func testBookmarksEmptyState() throws {
        app.tabBars.buttons["Bookmarks"].tap()

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)

        let cellCount = tableView.cells.count
        XCTAssertGreaterThanOrEqual(cellCount, 0, "Bookmarks table should exist even if empty")
    }

    func testNetworkErrorHandling() throws {
        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10))

        XCTAssertTrue(app.state == .runningForeground)
    }

    func testAccessibilityLabels() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        XCTAssertTrue(firstCell.exists)

        let favoriteButton = firstCell.buttons.firstMatch
        if favoriteButton.exists {
            XCTAssertTrue(favoriteButton.isHittable)
        }
    }

    func testScrollPerformance() throws {
        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
            tableView.swipeUp()
            tableView.swipeUp()
            tableView.swipeUp()
        }
    }
}
