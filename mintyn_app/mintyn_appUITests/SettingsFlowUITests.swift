import XCTest

final class SettingsFlowUITests: XCTestCase {
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

    func test_settingsScreen_expandsProfileSection() {
        login()

        app.buttons["mainTabSettingsButton"].tap()

        XCTAssertTrue(app.otherElements["settingsScreen"].waitForExistence(timeout: 2))

        let profileButton = app.buttons["settingsSectionProfile"]
        profileButton.tap()

        XCTAssertEqual(profileButton.value as? String, "Expanded")
        XCTAssertTrue(app.buttons["settingsChildPersonalInformation"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["settingsChildNextOfKin"].exists)
    }

    func test_helpAndSupportAccordion_collapsesProfileSection() {
        login()

        app.buttons["mainTabSettingsButton"].tap()

        let profileButton = app.buttons["settingsSectionProfile"]
        let helpButton = app.buttons["settingsSectionHelpAndSupport"]

        profileButton.tap()
        XCTAssertTrue(app.buttons["settingsChildPersonalInformation"].waitForExistence(timeout: 2))

        helpButton.tap()

        XCTAssertEqual(helpButton.value as? String, "Expanded")
        XCTAssertEqual(profileButton.value as? String, "Collapsed")
        XCTAssertTrue(app.buttons["settingsChildFrequentlyAskedQuestions"].waitForExistence(timeout: 2))
    }

    func test_appearanceScreen_selectsDarkMode() {
        login()

        app.buttons["mainTabSettingsButton"].tap()
        app.buttons["settingsSectionSystem"].tap()

        let appearanceButton = app.buttons["settingsChildAppearance"]
        XCTAssertTrue(appearanceButton.waitForExistence(timeout: 2))

        appearanceButton.tap()

        XCTAssertTrue(app.otherElements["settingsAppearanceScreen"].waitForExistence(timeout: 2))

        let darkOption = app.buttons["settingsAppearanceOptionDark"]
        let systemOption = app.buttons["settingsAppearanceOptionSystem"]

        darkOption.tap()

        XCTAssertEqual(darkOption.value as? String, "Selected")
        XCTAssertEqual(systemOption.value as? String, "Not selected")
    }

    private func login() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.otherElements["homeQuickAccessSection"].waitForExistence(timeout: 4))
    }
}
