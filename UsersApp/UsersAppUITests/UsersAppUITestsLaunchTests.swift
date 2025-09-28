//
//  UsersAppUITestsLaunchTests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class UsersAppUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchWithUsersTab() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Users"].tap()

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10))
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Users Tab Launch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchWithBookmarksTab() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Bookmarks"].tap()

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Bookmarks Tab Launch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
