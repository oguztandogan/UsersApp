//
//  UserDetailsUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class UserDetailsUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testUserDetailsScreenLoads() throws {
        XCTAssertTrue(app.navigationBars["User Details"].exists, "User Details navigation bar should be visible")

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Back button should be visible")
    }

    func testUserDetailsContentExists() throws {
        sleep(2)

        let contentView = app.otherElements.firstMatch
        XCTAssertTrue(contentView.exists, "User details content should be visible")
    }

    func testBackNavigation() throws {
        XCTAssertTrue(app.navigationBars["User Details"].exists)

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        XCTAssertTrue(app.navigationBars["Users"].exists, "Should navigate back to Users list")
    }

    func testSwipeBackNavigation() throws {
        XCTAssertTrue(app.navigationBars["User Details"].exists)

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        start.press(forDuration: 0.1, thenDragTo: end)

        XCTAssertTrue(app.navigationBars["Users"].exists, "Should navigate back to Users list with swipe gesture")
    }

    func testUserDetailsScreenOrientation() throws {
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(app.navigationBars["User Details"].exists, "Should work in portrait orientation")

        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(app.navigationBars["User Details"].exists, "Should work in landscape orientation")

        XCUIDevice.shared.orientation = .portrait
    }

    func testUserDetailsAccessibility() throws {
        XCTAssertTrue(app.navigationBars["User Details"].isHittable, "Navigation bar should be accessible")

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.isHittable, "Back button should be accessible")
    }

    func testUserDetailsPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            backButton.tap()
            let tableView = app.tables.firstMatch
            let firstCell = tableView.cells.firstMatch
            firstCell.tap()
        }
    }

    func testMultipleUserDetailsNavigation() throws {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        let tableView = app.tables.firstMatch

        let firstCell = tableView.cells.firstMatch
        firstCell.tap()
        XCTAssertTrue(app.navigationBars["User Details"].exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()

        if tableView.cells.count > 1 {
            let secondCell = tableView.cells.element(boundBy: 1)
            secondCell.tap()
            XCTAssertTrue(app.navigationBars["User Details"].exists)
        }
    }

    func testUserDetailsScreenStability() throws {
        for _ in 0 ..< 3 {
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            backButton.tap()

            XCTAssertTrue(app.navigationBars["Users"].exists)

            let tableView = app.tables.firstMatch
            let firstCell = tableView.cells.firstMatch
            firstCell.tap()

            XCTAssertTrue(app.navigationBars["User Details"].exists)
        }
    }
}
