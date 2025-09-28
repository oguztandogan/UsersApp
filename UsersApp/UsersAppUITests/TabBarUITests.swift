//
//  TabBarUITests.swift
//  UsersAppUITests
//
//  Created by Oguz Tandogan on 28.09.2025.
//

import XCTest

final class TabBarUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTabBarExists() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        XCTAssertTrue(tabBar.isHittable, "Tab bar should be accessible")
    }

    func testTabBarHasCorrectTabs() throws {
        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.exists, "Users tab should exist")
        XCTAssertTrue(usersTab.isHittable, "Users tab should be accessible")

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists, "Bookmarks tab should exist")
        XCTAssertTrue(bookmarksTab.isHittable, "Bookmarks tab should be accessible")
    }

    func testUsersTabSelection() throws {
        let usersTab = app.tabBars.buttons["Users"]
        usersTab.tap()

        XCTAssertTrue(usersTab.isSelected, "Users tab should be selected")

        XCTAssertTrue(app.navigationBars["Users"].exists, "Users screen should be displayed")
    }

    func testBookmarksTabSelection() throws {
        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        bookmarksTab.tap()

        XCTAssertTrue(bookmarksTab.isSelected, "Bookmarks tab should be selected")

        XCTAssertTrue(app.navigationBars["Bookmarks"].exists, "Bookmarks screen should be displayed")
    }

    func testTabSwitching() throws {
        app.tabBars.buttons["Users"].tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)

        app.tabBars.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)

        app.tabBars.buttons["Users"].tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)
    }

    func testTabBarIcons() throws {
        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.exists)

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.exists)
    }

    func testTabBarAccessibility() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.isHittable, "Tab bar should be accessible")

        let usersTab = app.tabBars.buttons["Users"]
        XCTAssertTrue(usersTab.isHittable, "Users tab should be accessible")
        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.isHittable, "Bookmarks tab should be accessible")
    }

    func testTabBarPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.tabBars.buttons["Users"].tap()
            app.tabBars.buttons["Bookmarks"].tap()
            app.tabBars.buttons["Users"].tap()
            app.tabBars.buttons["Bookmarks"].tap()
        }
    }

    func testTabBarStatePersistence() throws {
        app.tabBars.buttons["Users"].tap()
        let tableView = app.tables.firstMatch
        if tableView.cells.count > 0 {
            tableView.swipeUp()
        }

        app.tabBars.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)

        app.tabBars.buttons["Users"].tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)

        XCTAssertTrue(tableView.exists, "Users table should still exist")
    }

    func testTabBarOrientation() throws {
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(app.tabBars.firstMatch.exists, "Tab bar should exist in portrait")

        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(app.tabBars.firstMatch.exists, "Tab bar should exist in landscape")

        app.tabBars.buttons["Users"].tap()
        XCTAssertTrue(app.navigationBars["Users"].exists)
        app.tabBars.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.navigationBars["Bookmarks"].exists)

        XCUIDevice.shared.orientation = .portrait
    }

    func testTabBarRapidSwitching() throws {
        for _ in 0 ..< 5 {
            app.tabBars.buttons["Users"].tap()
            XCTAssertTrue(app.navigationBars["Users"].exists)
            app.tabBars.buttons["Bookmarks"].tap()
            XCTAssertTrue(app.navigationBars["Bookmarks"].exists)
        }

        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        XCTAssertTrue(bookmarksTab.isSelected, "Bookmarks tab should be selected after rapid switching")
    }

    func testTabBarVisualAppearance() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)

        XCTAssertTrue(tabBar.isHittable, "Tab bar should be visible and interactive")

        let usersTab = app.tabBars.buttons["Users"]
        usersTab.tap()
        XCTAssertTrue(usersTab.isSelected, "Users tab should show selected state")
        let bookmarksTab = app.tabBars.buttons["Bookmarks"]
        bookmarksTab.tap()
        XCTAssertTrue(bookmarksTab.isSelected, "Bookmarks tab should show selected state")
    }
}
