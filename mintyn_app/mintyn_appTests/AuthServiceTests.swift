import XCTest
@testable import mintyn_app

final class AuthServiceTests: XCTestCase {
    func test_login_withAdditionalAcceptedDemoPhones_returnsToken() async throws {
        let sut = AuthService(loginDelayNanoseconds: 0)

        for phone in ["8141584265", "8000000000"] {
            let token = try await sut.login(phone: phone, password: AuthService.demoPassword)
            XCTAssertEqual(token, "mintyn-demo-token")
        }
    }

    func test_login_withUnsupportedPhone_throwsInvalidCredentials() async {
        let sut = AuthService(loginDelayNanoseconds: 0)

        await XCTAssertThrowsErrorAsync(try await sut.login(phone: "7012345678", password: AuthService.demoPassword)) { error in
            XCTAssertEqual(error as? AuthError, .invalidCredentials)
        }
    }
}

private func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure () async throws -> T,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTFail("Expected expression to throw an error.", file: file, line: line)
    } catch {
        errorHandler(error)
    }
}
