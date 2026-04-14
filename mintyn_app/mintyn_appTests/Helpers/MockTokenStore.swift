import Foundation
@testable import mintyn_app

final class MockTokenStore: AuthTokenStoreProtocol {
    var savedToken: String?
    var fetchTokenValue: String?
    var saveError: Error?
    private(set) var clearTokenCallCount = 0

    func saveToken(_ token: String) throws {
        if let saveError {
            throw saveError
        }

        savedToken = token
        fetchTokenValue = token
    }

    func fetchToken() -> String? {
        fetchTokenValue
    }

    func clearToken() {
        clearTokenCallCount += 1
        fetchTokenValue = nil
    }
}
