import Foundation

protocol AuthServiceProtocol {
    func login(phone: String, password: String) async throws -> String
}

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid phone number or password."
        }
    }
}

final class AuthService: AuthServiceProtocol {
    func login(phone: String, password: String) async throws -> String {
        try await Task.sleep(nanoseconds: AppLaunchArguments.isUITesting ? 150_000_000 : 1_200_000_000)

        guard phone == "8021234567", password == "password" else {
            throw AuthError.invalidCredentials
        }

        return "mintyn-demo-token"
    }
}
