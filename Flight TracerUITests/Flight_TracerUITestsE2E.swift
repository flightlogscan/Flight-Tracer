import XCTest

final class UploadPageViewUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Stop immediately when a failure occurs
        continueAfterFailure = false
        app.launch()
    }

    func testImagePickerButton() {
        // Assuming there's a button that opens the Photos Picker
        let photoPickerButton = app.buttons["Select Image"]
        
        // Assert the button exists
        XCTAssertTrue(photoPickerButton.exists, "Photo picker button should exist")
        
        // Tap the button
        photoPickerButton.tap()
        
        // Assert that PhotosPicker opens (this may depend on your implementation)
        let photosPickerView = app.otherElements["PhotosPicker"]
        XCTAssertTrue(photosPickerView.waitForExistence(timeout: 5), "PhotosPicker should appear after tapping the button")
    }
    
    func testOptionsMenuAndScanButton() {
        // Assuming there's an options menu button and a scan button
        let optionsMenuButton = app.buttons["Options"]
        
        // Assert the options menu button exists and tap it
        XCTAssertTrue(optionsMenuButton.exists, "Options menu button should exist")
        optionsMenuButton.tap()
        
        // Select a specific option if needed
        let apiOptionButton = app.buttons["API Option"] // Replace with actual option name
        XCTAssertTrue(apiOptionButton.exists, "API option should exist in the options menu")
        apiOptionButton.tap()
        
        // Assert the option was selected or a relevant change was made
        let scanButton = app.buttons["Start Scan"]
        XCTAssertTrue(scanButton.exists, "Scan button should exist after selecting an option")
        
        // Simulate tapping the scan button
        scanButton.tap()
        
        // Assert that scan navigation happens
        let logSwiperView = app.otherElements["LogSwiperView"]
        XCTAssertTrue(logSwiperView.waitForExistence(timeout: 5), "LogSwiperView should appear after tapping Start Scan")
    }
    
    func testNavigationToLogSwiperView() {
        // Enable the condition for navigation
        let scanToggle = app.switches["AllowScanToggle"]
        
        // Assert that toggle exists and enable it
        XCTAssertTrue(scanToggle.exists, "Allow Scan toggle should exist")
        scanToggle.tap()
        
        // Tap on the scan button to trigger navigation
        let scanButton = app.buttons["Start Scan"]
        XCTAssertTrue(scanButton.exists, "Start Scan button should exist")
        scanButton.tap()
        
        // Verify that we navigated to LogSwiperView
        let logSwiperView = app.otherElements["LogSwiperView"]
        XCTAssertTrue(logSwiperView.waitForExistence(timeout: 5), "Navigating to LogSwiperView should succeed")
    }
}
