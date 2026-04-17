import XCTest

final class LoginFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        launchApp()
    }

    private func launchApp(additionalArguments: [String] = []) {
        app = XCUIApplication()
        app.launchArguments = ["--ui-testing-reset-auth"] + additionalArguments
        app.launch()
    }

    func test_loginScreen_displaysCoreElements() {
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.textFields["loginPhoneTextField"].exists)
        XCTAssertTrue(app.secureTextFields["loginPasswordTextField"].exists)
        XCTAssertTrue(app.buttons["loginRememberMeToggle"].exists)
        XCTAssertTrue(app.buttons["loginForgotPasswordButton"].exists)
        XCTAssertTrue(app.buttons["registerDeviceButton"].exists)
        XCTAssertTrue(app.buttons["loginSubmitButton"].exists)
    }

    func test_rememberMeToggle_updatesAccessibilityValue() {
        let rememberMeButton = app.buttons["loginRememberMeToggle"]

        XCTAssertEqual(rememberMeButton.value as? String, "Unchecked")

        rememberMeButton.tap()

        XCTAssertEqual(rememberMeButton.value as? String, "Checked")
    }

    func test_quickActionsPager_swipesToSecondPage() {
        let pagerView = app.otherElements["loginQuickActionsPager"]
        let pageIndicator = app.otherElements["loginQuickActionsPageIndicator"]

        XCTAssertTrue(pagerView.waitForExistence(timeout: 2))
        XCTAssertTrue(pageIndicator.waitForExistence(timeout: 2))
        XCTAssertEqual(pageIndicator.value as? String, "Page 1 of 2")

        pagerView.swipeLeft()

        let indicatorExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "value == %@", "Page 2 of 2"),
            object: pageIndicator
        )
        XCTAssertEqual(XCTWaiter().wait(for: [indicatorExpectation], timeout: 2), .completed)
        XCTAssertTrue(app.staticTexts["Maplerad"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Insurance"].exists)
        XCTAssertTrue(app.staticTexts["NCTO Card"].exists)
    }

    func test_loginWithInvalidCredentials_showsInlineError() {
        let errorLabel = app.otherElements["loginErrorLabel"]

        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("wrong-password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(errorLabel.waitForExistence(timeout: 4))
        XCTAssertEqual(errorLabel.label, "Invalid phone number or password.")
    }

    func test_successfulLogin_navigatesToHomeAndCanLogoutFromSettings() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].waitForExistence(timeout: 4))

        app.buttons["mainTabSettingsButton"].tap()
        XCTAssertEqual(app.otherElements["mainTabBar"].value as? String, "Settings selected")
        XCTAssertTrue(app.buttons["settingsLogoutButton"].waitForExistence(timeout: 2))

        app.buttons["settingsLogoutButton"].tap()

        XCTAssertTrue(app.textFields["loginPhoneTextField"].waitForExistence(timeout: 3))
    }

    func test_authenticatedHome_displaysDashboardSections() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.otherElements["homeHeaderSection"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].exists)
        XCTAssertTrue(app.otherElements["homeExploreSection"].exists)
        XCTAssertTrue(app.otherElements["homeRecentTransactionsSection"].exists)
    }

    func test_bottomNavigation_switchesBetweenPlaceholderTabs() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].waitForExistence(timeout: 4))

        app.buttons["mainTabInvestButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableInvestScreen"].waitForExistence(timeout: 2))

        app.buttons["mainTabMenuButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableMenuScreen"].waitForExistence(timeout: 2))

        app.buttons["mainTabTransactionsButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableTransactionsScreen"].waitForExistence(timeout: 2))
    }

    func test_homeErrorLaunchArgument_showsRetryFlow() {
        app.terminate()
        launchApp(additionalArguments: ["--ui-testing-home-error"])

        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.otherElements["homeErrorState"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["homeRetryButton"].exists)

        app.buttons["homeRetryButton"].tap()

        XCTAssertTrue(app.otherElements["homeErrorState"].waitForExistence(timeout: 2))
    }

    func test_forgotPassword_pushesPlaceholderAndReturnsToLogin() {
        app.buttons["loginForgotPasswordButton"].tap()

        let navigationBar = app.navigationBars["Forgot Password"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 2))

        navigationBar.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.textFields["loginPhoneTextField"].waitForExistence(timeout: 2))
    }

    func test_registerDevice_pushesPlaceholderAndReturnsToLogin() {
        app.buttons["registerDeviceButton"].tap()

        let navigationBar = app.navigationBars["Register New Device"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 2))

        navigationBar.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.textFields["loginPhoneTextField"].waitForExistence(timeout: 2))
    }

    func test_demoRecordingWalkthrough_showcasesCoreFeatures() {
        let pagerView = app.otherElements["loginQuickActionsPager"]
        XCTAssertTrue(pagerView.waitForExistence(timeout: 2))

        pauseForRecording()
        pagerView.swipeLeft()
        XCTAssertTrue(app.staticTexts["Maplerad"].waitForExistence(timeout: 2))

        pauseForRecording()
        enterValidCredentials()
        app.buttons["loginSubmitButton"].tap()

        let homeScreen = app.otherElements["homeScreen"]
        XCTAssertTrue(homeScreen.waitForExistence(timeout: 4))
        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].exists)

        pauseForRecording()
        homeScreen.swipeUp()
        XCTAssertTrue(app.otherElements["homeExploreSection"].waitForExistence(timeout: 2))

        pauseForRecording()
        homeScreen.swipeUp()
        XCTAssertTrue(app.otherElements["homeRecentTransactionsSection"].waitForExistence(timeout: 2))

        pauseForRecording()
        homeScreen.swipeDown()
        homeScreen.swipeDown()

        pauseForRecording()
        app.buttons["mainTabInvestButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableInvestScreen"].waitForExistence(timeout: 2))

        pauseForRecording()
        app.buttons["mainTabTransactionsButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableTransactionsScreen"].waitForExistence(timeout: 2))

        pauseForRecording()
        app.buttons["mainTabMenuButton"].tap()
        XCTAssertTrue(app.otherElements["unavailableMenuScreen"].waitForExistence(timeout: 2))

        pauseForRecording()
        app.buttons["mainTabHomeButton"].tap()
        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].waitForExistence(timeout: 2))

        pauseForRecording()
        app.buttons["mainTabSettingsButton"].tap()
        let settingsScreen = app.otherElements["settingsScreen"]
        XCTAssertTrue(settingsScreen.waitForExistence(timeout: 2))

        pauseForRecording()
        let profileButton = app.buttons["settingsSectionProfile"]
        profileButton.tap()
        XCTAssertTrue(app.buttons["settingsChildPersonalInformation"].waitForExistence(timeout: 2))

        pauseForRecording()
        settingsScreen.swipeUp()
        let systemButton = app.buttons["settingsSectionSystem"]
        systemButton.tap()
        let appearanceButton = app.buttons["settingsChildAppearance"]
        XCTAssertTrue(appearanceButton.waitForExistence(timeout: 2))

        pauseForRecording()
        appearanceButton.tap()
        XCTAssertTrue(app.otherElements["settingsAppearanceScreen"].waitForExistence(timeout: 2))

        pauseForRecording()
        let darkOption = app.buttons["settingsAppearanceOptionDark"]
        darkOption.tap()
        XCTAssertEqual(darkOption.value as? String, "Selected")

        pauseForRecording()
        app.navigationBars["Appearance"].buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["settingsScreen"].waitForExistence(timeout: 2))

        pauseForRecording()
        app.buttons["settingsLogoutButton"].tap()
        XCTAssertTrue(app.textFields["loginPhoneTextField"].waitForExistence(timeout: 3))
    }

    private func enterValidCredentials() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")
    }

    private func pauseForRecording(_ duration: TimeInterval = 1.0) {
        Thread.sleep(forTimeInterval: duration)
    }
}
