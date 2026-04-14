import XCTest
@testable import mintyn_app

final class KeychainServiceTests: XCTestCase {
    private var sut: KeychainService!

    override func setUp() {
        super.setUp()
        sut = KeychainService(
            service: "mintyn-demo-tests.\(UUID().uuidString)",
            account: "auth_token_test"
        )
    }

    override func tearDown() {
        sut.clearToken()
        sut = nil
        super.tearDown()
    }

    func test_saveToken_fetchTokenAndClearToken_roundTripsSuccessfully() throws {
        XCTAssertNil(sut.fetchToken())

        try sut.saveToken("demo-token")

        XCTAssertEqual(sut.fetchToken(), "demo-token")

        sut.clearToken()

        XCTAssertNil(sut.fetchToken())
    }

    func test_saveToken_whenCalledTwice_updatesExistingValue() throws {
        try sut.saveToken("first-token")
        try sut.saveToken("updated-token")

        XCTAssertEqual(sut.fetchToken(), "updated-token")
    }
}
