//
//  GreyrockTests.swift
//  GreyrockTests
//
//  Created by ian norstad on 9/22/24.
//


// Testing objectives:
// how can we validate when an amount of time has been selected for the app?
// what happens when no time is selected? (should we have a default?)
// how can we check when an app has been selected by a user?
// what happens when no app is selected?
// how can we verify that the screen will go back to normal once the social media app is closed?


import XCTest
@testable import Greyrock

class SocialUsageViewModelTests: XCTestCase {
    var viewModel: SocialUsageViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SocialUsageViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSettingTimeLimit() {
        let newTimeLimit: Double = 30
        viewModel.model.timeLimit = newTimeLimit
        XCTAssertEqual(viewModel.model.timeLimit, newTimeLimit, "The time limit should be set to \(newTimeLimit)")
    }
    
    // test: start monitoring without selecting apps
    func testStartMonitoringWithoutApps() {
        viewModel.startTrackingSelectedApps()
        XCTAssertFalse(viewModel.isTimeExceeded, "isTimeExceeded should be false if no apps are selected.")
    }
    
    // Test: Time limit exceeded when the timeSpent is greater than timeLimit
        func testTimeLimitExceeded() {
            // Arrange
            viewModel.model.timeLimit = 5
            viewModel.model.timeSpent = 6
            
            // Act
            viewModel.startTrackingSelectedApps()
            
            // Assert
            XCTAssertTrue(viewModel.isTimeExceeded, "isTimeExceeded should be true when timeSpent exceeds timeLimit.")
        }

        // Test: Screen time authorization request
        func testScreenTimeAuthorization() async {
            let expectation = self.expectation(description: "Authorization Request")

            // Mock the authorization in ScreenTimeManager
            ScreenTimeManager.shared.requestScreenTimeAuthorization { authorized in
                // Assert
                XCTAssertTrue(authorized, "Authorization should be granted.")
                expectation.fulfill()
            }

            await fulfillment(of: [expectation], timeout: 5.0)
        }
    }
