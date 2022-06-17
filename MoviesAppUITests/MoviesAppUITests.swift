//
//  MoviesAppUITests.swift
//  MoviesAppUITests
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import XCTest

class MoviesAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSelectMovie() throws {
        let cell = app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Fantastic Beasts: The Secrets of Dumbledore").element
        cell.tap()
        let loaded = app.tables.staticTexts["Fantastic Beasts: The Secrets of Dumbledore"]
        XCTAssertTrue(loaded.exists)
                
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
