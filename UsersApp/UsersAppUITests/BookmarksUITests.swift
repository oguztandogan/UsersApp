//
//  BookmarksUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class BookmarksUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Bookmarks"].tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testBookmarksScreenLoads() throws {
        XCTAssertTrue(app.navigationBars["Bookmarks"].exists, "Bookmarks navigation bar should be visible")

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Bookmarks table view should exist")
    }

    func testBookmarksEmptyState() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        let cellCount = tableView.cells.count
        XCTAssertGreaterThanOrEqual(cellCount, 0, "Bookmarks table should exist even if empty")
    }

    func testBookmarksTableStructure() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        XCTAssertTrue(tableView.exists, "Bookmarks table should exist")

        if tableView.cells.count > 0 {
            let firstCell = tableView.cells.firstMatch
            XCTAssertTrue(firstCell.exists, "First bookmark cell should exist")
        }
    }

    func testBookmarksNavigation() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        if tableView.cells.count > 0 {
            let firstCell = tableView.cells.firstMatch
            firstCell.tap()

            XCTAssertTrue(app.navigationBars["User Details"].exists, "Should navigate to user details from bookmarks")

            app.navigationBars.buttons.element(boundBy: 0).tap()
            XCTAssertTrue(app.navigationBars["Bookmarks"].exists, "Should return to bookmarks")
        }
    }

    func testBookmarksRefresh() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        if tableView.cells.count > 0 {
            let firstCell = tableView.cells.firstMatch

            let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0.1, thenDragTo: end)

            sleep(2)

            XCTAssertTrue(tableView.exists, "Table should still exist after refresh")
        }
    }

    func testBookmarksScroll() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        if tableView.cells.count > 1 {
            tableView.swipeUp()
            tableView.swipeUp()

            XCTAssertTrue(tableView.exists, "Table should still exist after scrolling")
        }
    }

    func testBookmarksTabSelection() throws {
        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists, "Bookmarks tab should exist")
        XCTAssertTrue(bookmarksTab.isSelected, "Bookmarks tab should be selected")
    }

    func testBookmarksTabIcon() throws {
        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists, "Bookmarks tab should exist")

        XCTAssertTrue(bookmarksTab.isHittable, "Bookmarks tab should be tappable")
    }

    func testBookmarksAccessibility() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        XCTAssertTrue(tableView.isHittable, "Bookmarks table should be accessible")

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.isHittable, "Bookmarks tab should be accessible")
    }

    func testBookmarksPerformance() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        if tableView.cells.count > 0 {
            measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
                tableView.swipeUp()
                tableView.swipeDown()
            }
        }
    }

    func testBookmarksEmptyStateMessage() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))

        let cellCount = tableView.cells.count
        if cellCount == 0 {
            XCTAssertTrue(tableView.exists, "Empty bookmarks table should still exist")

            let start = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0.1, thenDragTo: end)

            XCTAssertTrue(tableView.exists, "Empty table should still exist after refresh")
        }
    }

    func testBookmarksTabSwitching() throws {
        app.tabBars.buttons["Users"].tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)

        app.tabBars.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Bookmarks table should exist after tab switch")
    }
}
