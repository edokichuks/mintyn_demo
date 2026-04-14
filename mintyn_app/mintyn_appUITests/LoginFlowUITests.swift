import XCTest

final class LoginFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--ui-testing-reset-auth"]
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

    func test_loginWithInvalidCredentials_showsInlineError() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("wrong-password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.staticTexts["loginErrorLabel"].waitForExistence(timeout: 3))
        XCTAssertEqual(app.staticTexts["loginErrorLabel"].label, "Invalid phone number or password.")
    }

    func test_successfulLogin_navigatesToHomeAndCanLogout() {
        app.textFields["loginPhoneTextField"].tap()
        app.textFields["loginPhoneTextField"].typeText("8021234567")

        app.secureTextFields["loginPasswordTextField"].tap()
        app.secureTextFields["loginPasswordTextField"].typeText("password")

        app.buttons["loginSubmitButton"].tap()

        XCTAssertTrue(app.staticTexts["homeTitleLabel"].waitForExistence(timeout: 4))

        app.buttons["homeLogoutButton"].tap()

        XCTAssertTrue(app.textFields["loginPhoneTextField"].waitForExistence(timeout: 3))
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
}
