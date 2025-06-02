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
    
    func testLogoutAndLoginFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Ensure we are logged in
        let optionsMenuButton = app.buttons["OptionsMenu"]
        XCTAssertTrue(optionsMenuButton.waitForExistence(timeout: 5), "Options menu button should be present")
        
        // Access the OptionsMenu
        optionsMenuButton.tap()
        
        // Tap on "Logout"
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5), "Logout button should be present in OptionsMenu")
        logoutButton.tap()
        
        // Verify we are on the login screen
        let loginView = app.otherElements["LoginView"]
        XCTAssertTrue(loginView.exists, "LoginView should appear after logging out")
        
        let loginWithEmailButton = app.buttons["Sign in with email"]
        
        XCTAssertTrue(loginWithEmailButton.exists, "Login button should be present on LoginView")
        loginWithEmailButton.tap()
        
        // Perform login
        let emailField = app.textFields["Enter your email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "Email field should be present on LoginView")
        
        // Input credentials (replace with your test credentials)
        emailField.tap()
        emailField.typeText("lancedesi@msn.com")
        
        
        let nextButton = app.buttons["Next"]
        
        XCTAssertTrue(nextButton.exists, "Next button should be present on LoginView")
        nextButton.tap()
        
        let passwordField = app.secureTextFields["Enter your password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Password field should be present on LoginView")
        
        passwordField.tap()
        passwordField.typeText("Integtests1!")
        
        let signInButton = app.buttons["Sign in"]
        
        XCTAssertTrue(signInButton.exists, "Sign in button should be present on LoginView")
        signInButton.tap()
        
        let uploadPageView = app.otherElements["Background"]
        XCTAssertTrue(uploadPageView.waitForExistence(timeout: 5), "UploadPageView should load successfully")
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
        XCTAssertEqual(toolbarTitle.label, "FlightLogScan", "Toolbar title should match 'FlightLogScan'")
        
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
        
        // Verify ImagePresentationView is dismissed when the X button is tapped
        let imagePresentationViewCancel = app.descendants(matching: .any).matching(identifier: "ImagePresentationView").element(boundBy: 1)
        XCTAssertTrue(imagePresentationViewCancel.exists, "The second ImagePresentationView should be visible")
        imagePresentationViewCancel.tap()
        sleep(2)
        XCTAssertFalse(displayedImage.exists, "Image should no longer be displayed")
        
        carouselValidImage.tap()
        
        // Verify the selected image is displayed in ImagePresentationView
        XCTAssertTrue(displayedImage.waitForExistence(timeout: 10), "Selected image should be displayed again in ImagePresentationView")
        
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
        
        let carouselInvalidImage = app.buttons["carouselButton1"]
        XCTAssertTrue(carouselInvalidImage.exists, "carouselButton should exist on the UploadPageView")
        carouselInvalidImage.tap()
        
        // Verify the "Error detected" alert appears
        let errorAlert = app.alerts["Error detected:"]
        XCTAssertTrue(errorAlert.waitForExistence(timeout: 10), "Error detected alert should appear")
        
        // Verify "Close" button exists in the alert
        XCTAssertTrue(errorAlert.buttons["Close"].exists, "Close button should exist in the Error detected alert")
        
        // Tap the "Close" button and verify the alert disappears
        errorAlert.buttons["Close"].tap()
        XCTAssertFalse(errorAlert.exists, "Error detected alert should disappear after tapping Close")
    }
}
