import XCTest

// This is meant to be the single "end to end" test file across all core functionality
// There is a bit of one-time setup here because interacting with system-level prompts via XCTest is tricky
// 1. Log in
// 2. Allow limited access to two photos, the first one valid and the second one invalid
// 3. Rerun the tests
// One last important note: XCTest is only able to verify what is directly in the viewport
// This means if too many photos are present in the carousel, it won't be able to see the "photo library" options
// Implementing scrolling is tricky but possible and may be worth adding later on
final class Flight_TracerUITestsE2E: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testNavigationToUploadPage() throws {
        // Verify UploadPageView is loaded
        let uploadPageView = app.otherElements["Background"]
        XCTAssertTrue(uploadPageView.waitForExistence(timeout: 5), "UploadPageView should load successfully")
    }

    func testImageHintsViewExists() throws {
        // Ensure ImageHintsView is displayed
        let imageHintsView = app.descendants(matching: .any)["ImageHintsView"]
        XCTAssertTrue(imageHintsView.waitForExistence(timeout: 10), "ImageHintsView should exist on UploadPageView")
    }

    func testImagePresentationAndSelection() throws {
        // Verify ImagePresentationView exists
        let imagePresentationView = app.descendants(matching: .any)["ImagePresentationView"]
        XCTAssertTrue(imagePresentationView.waitForExistence(timeout: 5), "ImagePresentationView should be visible")
        
        // Verify PhotoCarouselView exists
        let photoCarouselView = app.descendants(matching: .any)["PhotoCarouselView"]
        XCTAssertTrue(photoCarouselView.exists, "PhotoCarouselView should exist on the UploadPageView")
        
        // Verify photo picker button exists
        let photoPickerButton = app.buttons["PhotoPickerButton"]
        XCTAssertTrue(photoPickerButton.exists, "Photo picker button should exist")
        
        let carouselValidImage = app.buttons["carouselButton0"]
        XCTAssertTrue(carouselValidImage.exists, "carouselButton should exist on the UploadPageView")
        carouselValidImage.tap()
        
        // Verify the selected image is displayed in ImagePresentationView
        let displayedImage = imagePresentationView.images.firstMatch
        XCTAssertTrue(displayedImage.waitForExistence(timeout: 5), "Selected image should be displayed in ImagePresentationView")
        
        // Cancel button
//        sleep(5)
//        let cancelButton = app.buttons["ImagePresentationView"]
//        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
//        
//        cancelButton.tap()
        
        sleep(2)
        // Verify ScanView is present
        let scanButton = app.buttons["ScanView"]
        XCTAssertTrue(scanButton.exists, "Scan button should exist in ScanView")
        
        // Simulate tapping the scan button
        scanButton.tap()
        
        // Verify navigation to LogSwiperView
        // TODO: Check some of the actual data here?
        let logSwiperView = app.descendants(matching: .any)["LogSwiperView"]
        XCTAssertTrue(logSwiperView.waitForExistence(timeout: 10), "LogSwiperView should appear after scanning")
    }
    
    // Select invalid image test case
    
    // Press cancel button
    
    // Log out and back in

    func testOptionsMenuAccessibility() throws {
        // Verify OptionsMenu is accessible
        sleep(5)
        let optionsMenu = app.buttons["OptionsMenu"]
        XCTAssertTrue(optionsMenu.exists, "OptionsMenu should be present in the toolbar")
        optionsMenu.tap()
    }

    func testToolbarTitleDisplayed() throws {
        // Verify toolbar title
        let toolbarTitle = app.staticTexts["ToolbarTitle"]
        XCTAssertTrue(toolbarTitle.exists, "ToolbarTitle should be visible")
        XCTAssertEqual(toolbarTitle.label, "Flight Log Tracer", "Toolbar title should match 'Flight Log Tracer'")
    }
}
