import XCTest
@testable import mintyn_app

@MainActor
final class LoginViewModelTests: XCTestCase {
    private var sut: LoginViewModel!
    private var mockAuthService: MockAuthService!
    private var mockTokenStore: MockTokenStore!

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        mockTokenStore = MockTokenStore()
        sut = LoginViewModel(authService: mockAuthService, tokenStore: mockTokenStore)
    }

    override func tearDown() {
        sut = nil
        mockAuthService = nil
        mockTokenStore = nil
        super.tearDown()
    }

    func test_updatePhone_withMalformedNumber_keepsLoginDisabled() {
        sut.updatePhone("12345")
        sut.updatePassword("password")

        XCTAssertFalse(sut.currentState.isLoginEnabled)
    }

    func test_updatePhone_withExtraDigits_truncatesToTenLocalDigits() {
        sut.updatePhone("+234802123456789")

        XCTAssertEqual(sut.currentState.phoneText, "802 123 4567")
    }

    func test_normalizePhone_withFormattedInput_returnsTenDigitLocalNumber() {
        let normalizedPhone = LoginViewModel.normalizePhone("802 123 4567")

        XCTAssertEqual(normalizedPhone, "8021234567")
    }

    func test_normalizePhone_withAdditionalDemoNumbers_returnsTenDigitLocalNumber() {
        XCTAssertEqual(LoginViewModel.normalizePhone("08141584265"), "8141584265")
        XCTAssertEqual(LoginViewModel.normalizePhone("08000000000"), "8000000000")
    }

    func test_togglePasswordVisibility_updatesViewState() {
        XCTAssertTrue(sut.currentState.isPasswordHidden)

        sut.togglePasswordVisibility()

        XCTAssertFalse(sut.currentState.isPasswordHidden)
    }

    func test_toggleRememberMe_updatesViewState() {
        XCTAssertFalse(sut.currentState.isRememberMeSelected)

        sut.toggleRememberMe()

        XCTAssertTrue(sut.currentState.isRememberMeSelected)
    }

    func test_submit_withEmptyFields_showsValidationError() {
        sut.submit()

        XCTAssertEqual(sut.currentState.errorMessage, "Enter your phone number and password to continue.")
    }

    func test_submit_withValidCredentialsAndRememberMeOn_persistsTokenAndCallsSuccess() async {
        let successExpectation = expectation(description: "Login success callback fired")
        sut.onLoginSuccess = {
            successExpectation.fulfill()
        }

        sut.updatePhone("+234 802 123 4567")
        sut.updatePassword("password")
        sut.toggleRememberMe()

        sut.submit()

        await fulfillment(of: [successExpectation], timeout: 1)

        XCTAssertEqual(mockAuthService.receivedPhone, "8021234567")
        XCTAssertEqual(mockAuthService.receivedPassword, "password")
        XCTAssertEqual(mockTokenStore.savedToken, "mock-token")
        XCTAssertEqual(mockTokenStore.clearTokenCallCount, 0)
        XCTAssertNil(sut.currentState.errorMessage)
    }

    func test_submit_withValidCredentialsAndRememberMeOff_clearsPersistedTokenAndCallsSuccess() async {
        let successExpectation = expectation(description: "Login success callback fired")
        sut.onLoginSuccess = {
            successExpectation.fulfill()
        }

        mockTokenStore.fetchTokenValue = "existing-token"

        sut.updatePhone("08021234567")
        sut.updatePassword("password")

        sut.submit()

        await fulfillment(of: [successExpectation], timeout: 1)

        XCTAssertEqual(mockTokenStore.clearTokenCallCount, 1)
        XCTAssertNil(mockTokenStore.savedToken)
    }

    func test_submit_withInvalidCredentials_clearsLoadingAndShowsAuthError() async {
        let failureExpectation = expectation(description: "Auth failure propagated")
        mockAuthService.result = .failure(AuthError.invalidCredentials)
        sut.onStateChange = { state in
            if state.errorMessage == "Invalid phone number or password.", !state.isLoading {
                failureExpectation.fulfill()
            }
        }

        sut.updatePhone("8021234567")
        sut.updatePassword("wrong-password")

        sut.submit()

        await fulfillment(of: [failureExpectation], timeout: 1)

        XCTAssertFalse(sut.currentState.isLoading)
        XCTAssertEqual(sut.currentState.errorMessage, "Invalid phone number or password.")
    }
}
