//
//  Expose_BankUITests.swift
//  Expose-BankUITests
//
//  Created by Caio on 2022-05-05.
//

import XCTest
@testable import Expose_Bank

class Expose_BankUITests: XCTestCase {

    let app = XCUIApplication()
    let timeout: TimeInterval = 3

    override func setUpWithError() throws {
        try super.setUpWithError()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testConciergeLoadsWithoutConnection() throws {
        let tablesQuery = app.tables

        XCTAssertEqual(tablesQuery.cells.count, 5)

        XCTAssertTrue(tablesQuery.staticTexts["Touch here to Connect"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Nothing to show here"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Picked for you"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["See All"].exists)
    }

    func testConciergeLoadsWithoutConnectionAndOpensSeeAll() throws {

        let tablesQuery = app.tables

        XCTAssertEqual(tablesQuery.cells.count, 5)

        XCTAssertTrue(tablesQuery.staticTexts["Touch here to Connect"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Nothing to show here"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Picked for you"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["See All"].exists)

        tablesQuery.staticTexts["See All"].tap()

        XCTAssertTrue(app.staticTexts["Nothing to show here"].exists)
        XCTAssertTrue(app.staticTexts["Try pulling to refresh or check back again soon."].exists)
    }
}
