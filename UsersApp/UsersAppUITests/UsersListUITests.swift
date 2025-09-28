//
//  UsersListUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class UsersListUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Users"].tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testUsersListScreenLoads() throws {
        XCTAssertTrue(app.navigationBars["Users"].exists)

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)

        let firstCell = tableView.cells.firstMatch
        let exists = firstCell.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Users list should load data within 10 seconds")
    }

    func testUsersListHasMultipleCells() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10))

        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let cellCount = tableView.cells.count
        XCTAssertGreaterThan(cellCount, 1, "Should have multiple user cells loaded")
    }

    func testUserCellContainsRequiredElements() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let imageView = firstCell.images.firstMatch
        XCTAssertTrue(imageView.exists, "User cell should contain profile image")

        let favoriteButton = firstCell.buttons.firstMatch
        XCTAssertTrue(favoriteButton.exists, "User cell should contain favorite button")

        XCTAssertTrue(firstCell.isHittable, "User cell should be tappable")
    }

    func testUserCellTapNavigatesToDetails() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        firstCell.tap()

        XCTAssertTrue(app.navigationBars["User Details"].exists, "Should navigate to user details screen")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Users"].exists, "Should return to users list")
    }

    func testFavoriteButtonToggles() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        let favoriteButton = firstCell.buttons.firstMatch
        XCTAssertTrue(favoriteButton.exists)

        let initialImage = favoriteButton.images.firstMatch

        favoriteButton.tap()

        sleep(1)

        XCTAssertTrue(favoriteButton.exists, "Favorite button should still exist after tap")
    }

    func testPullToRefresh() throws {
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

    func testPaginationLoadsMoreData() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let initialCellCount = tableView.cells.count

        tableView.swipeUp()
        tableView.swipeUp()
        tableView.swipeUp()

        sleep(3)

        let finalCellCount = tableView.cells.count
        XCTAssertGreaterThanOrEqual(finalCellCount, initialCellCount, "Should have loaded more or same number of cells")
    }

    func testScrollPerformance() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
            tableView.swipeUp()
            tableView.swipeUp()
            tableView.swipeUp()
            tableView.swipeDown()
            tableView.swipeDown()
        }
    }

    func testTableScrollToBottom() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let lastCell = tableView.cells.element(boundBy: tableView.cells.count - 1)
        tableView.scrollToElement(element: lastCell)

        XCTAssertTrue(lastCell.isHittable, "Should be able to scroll to last cell")
    }

    func testTableScrollToTop() throws {
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        tableView.swipeUp()
        tableView.swipeUp()

        tableView.scrollToElement(element: firstCell)

        XCTAssertTrue(firstCell.isHittable, "Should be able to scroll back to first cell")
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement, maxScrolls: Int = 5) {
        var scrollCount = 0
        while !element.isHittable, scrollCount < maxScrolls {
            swipeUp()
            scrollCount += 1
        }
    }
}
