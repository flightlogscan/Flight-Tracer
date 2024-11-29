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

    func testImagePresentationAndSelection() throws {
        // Verify UploadPageView is loaded
        let uploadPageView = app.otherElements["Background"]
        XCTAssertTrue(uploadPageView.waitForExistence(timeout: 5), "UploadPageView should load successfully")
        
        // Ensure ImageHintsView is displayed
        let imageHintsView = app.descendants(matching: .any)["ImageHintsView"]
        XCTAssertTrue(imageHintsView.waitForExistence(timeout: 10), "ImageHintsView should exist on UploadPageView")
        
        // Verify OptionsMenu is accessible
        let optionsMenu = app.buttons["OptionsMenu"]
        XCTAssertTrue(optionsMenu.waitForExistence(timeout: 5), "OptionsMenu should be present in the toolbar")
        // optionsMenu.tap()
        
        // Verify toolbar title
        let toolbarTitle = app.staticTexts["ToolbarTitle"]
        XCTAssertTrue(toolbarTitle.waitForExistence(timeout: 5), "ToolbarTitle should be visible")
        XCTAssertEqual(toolbarTitle.label, "Flight Log Tracer", "Toolbar title should match 'Flight Log Tracer'")
        
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
        XCTAssertTrue(displayedImage.waitForExistence(timeout: 10), "Selected image should be displayed in ImagePresentationView")
        
        // Cancel button
//        sleep(5)
//        let cancelButton = app.buttons["ImagePresentationView"]
//        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
//        
//        cancelButton.tap()
        
        // Verify ScanView is present
        let scanButton = app.buttons["ScanView"]
        XCTAssertTrue(scanButton.waitForExistence(timeout: 5), "Scan button should exist in ScanView")
        
        // Simulate tapping the scan button
        scanButton.tap()
        
        // Verify navigation to LogSwiperView
        // TODO: Check some of the actual data here?
        let logSwiperView = app.descendants(matching: .any)["LogSwiperView"]
        XCTAssertTrue(logSwiperView.waitForExistence(timeout: 10), "LogSwiperView should appear after scanning")
        
        // Verify "Download CSV" button exists
        let downloadCSVButton = app.buttons["DownloadView"]
        XCTAssertTrue(downloadCSVButton.exists, "Download CSV button should exist")

        // Verify "xmark" button exists and interact with it
        let xmarkButton = app.buttons["xmark"]
        XCTAssertTrue(xmarkButton.exists, "xmark button should exist in the toolbar")
        
        // Step 1: Tap the "xmark" button and verify "Delete Log?" alert
        xmarkButton.tap()
        let deleteLogAlert = app.alerts["Delete Log?"]
        XCTAssertTrue(deleteLogAlert.waitForExistence(timeout: 5), "Delete Log? alert should appear after tapping xmark")
        
        // Verify the alert has both "Cancel" and "Delete" options
        XCTAssertTrue(deleteLogAlert.buttons["Cancel"].exists, "Cancel option should exist in the Delete Log alert")
        XCTAssertTrue(deleteLogAlert.buttons["Delete"].exists, "Delete option should exist in the Delete Log alert")

        // Step 2: Tap "Cancel" and verify the alert disappears
        deleteLogAlert.buttons["Cancel"].tap()
        XCTAssertFalse(deleteLogAlert.exists, "Delete Log? alert should disappear after tapping Cancel")
        
        // Step 3: Repeat and tap "Delete"
        xmarkButton.tap()
        XCTAssertTrue(deleteLogAlert.waitForExistence(timeout: 5), "Delete Log? alert should reappear after tapping xmark again")
        deleteLogAlert.buttons["Delete"].tap()
        
        sleep(5)

        // Verify navigation back after deleting the log
        XCTAssertFalse(logSwiperView.exists, "LogSwiperView should no longer exist after deleting the log")
        
        // Verify ImagePresentationView exists
        XCTAssertTrue(imagePresentationView.waitForExistence(timeout: 5), "ImagePresentationView should be visible")
    }
    
    // Select invalid image test case
    
    // Press cancel button
    
    // Log out and back in
}
