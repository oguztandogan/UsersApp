//
//  UserInteractionUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class UserInteractionUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testUserCellTapInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        firstCell.tap()

        XCTAssertTrue(app.navigationBars["User Details"].exists, "Should navigate to user details on cell tap")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Users"].exists, "Should return to users list")
    }

    func testFavoriteButtonInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let favoriteButton = firstCell.buttons.firstMatch
        XCTAssertTrue(favoriteButton.exists, "Favorite button should exist")

        favoriteButton.tap()

        XCTAssertTrue(favoriteButton.exists, "Favorite button should still exist after tap")
    }

    func testPullToRefreshInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: end)

        sleep(2)

        XCTAssertTrue(tableView.exists, "Table should still exist after refresh")
        XCTAssertTrue(firstCell.exists, "First cell should still exist after refresh")
    }

    func testScrollInteraction() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        tableView.swipeUp()
        tableView.swipeDown()
        tableView.swipeUp()
        tableView.swipeUp()

        XCTAssertTrue(tableView.exists, "Table should still exist after scrolling")
    }

    func testTabBarInteraction() throws {
        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.waitForExistence(timeout: 5), "Users tab should exist")
        usersTab.tap()

        let usersNavBar = app.navigationBars["Users"]
        XCTAssertTrue(usersNavBar.waitForExistence(timeout: 5), "Users navigation bar should appear")

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.waitForExistence(timeout: 5), "Bookmarks tab should exist")
        bookmarksTab.tap()

        let bookmarksNavBar = app.navigationBars["Bookmarks"]
        XCTAssertTrue(bookmarksNavBar.waitForExistence(timeout: 5), "Bookmarks navigation bar should appear")

        usersTab.tap()
        XCTAssertTrue(usersNavBar.waitForExistence(timeout: 3), "Should navigate to Users")
        bookmarksTab.tap()
        XCTAssertTrue(bookmarksNavBar.waitForExistence(timeout: 3), "Should navigate to Bookmarks")
        usersTab.tap()
        XCTAssertTrue(usersNavBar.waitForExistence(timeout: 3), "Should navigate back to Users")

        XCTAssertTrue(usersNavBar.exists, "Should be on Users screen after rapid switching")
    }

    func testNavigationBackInteraction() throws {
        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Back button should exist")
        backButton.tap()

        XCTAssertTrue(app.navigationBars["Users"].exists, "Should navigate back to Users list")
    }

    func testSwipeBackInteraction() throws {
        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        start.press(forDuration: 0.1, thenDragTo: end)

        XCTAssertTrue(app.navigationBars["Users"].exists, "Should navigate back with swipe gesture")
    }

    func testInteractionPerformance() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
            tableView.swipeUp()

            sleep(1)
            tableView.swipeDown()

            sleep(1)
            let favoriteButton = firstCell.buttons.firstMatch
            if favoriteButton.exists, favoriteButton.isHittable {
                favoriteButton.tap()

                usleep(500_000)
            }
        }
    }

    func testAccessibilityInteractions() throws {
        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        XCTAssertTrue(firstCell.isHittable, "First cell should be accessible")
        let favoriteButton = firstCell.buttons.firstMatch
        if favoriteButton.exists {
            XCTAssertTrue(favoriteButton.isHittable, "Favorite button should be accessible")
        }

        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.isHittable, "Users tab should be accessible")
    }
}
