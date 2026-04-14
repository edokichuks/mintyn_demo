import Foundation
@testable import mintyn_app

final class MockAuthService: AuthServiceProtocol {
    var result: Result<String, Error> = .success("mock-token")
    private(set) var receivedPhone: String?
    private(set) var receivedPassword: String?

    func login(phone: String, password: String) async throws -> String {
        receivedPhone = phone
        receivedPassword = password

        switch result {
        case .success(let token):
            return token
        case .failure(let error):
            throw error
        }
    }
}
