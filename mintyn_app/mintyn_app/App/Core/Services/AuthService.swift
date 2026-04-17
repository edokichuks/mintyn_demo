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
    static let demoPassword = "password"
    static let acceptedDemoPhones: Set<String> = [
        "8021234567",
        "8141584265",
        "8000000000",
        "7000000000",
        "9000000000"
    ]

    private let loginDelayNanoseconds: UInt64

    init(loginDelayNanoseconds: UInt64 = AppLaunchArguments.isUITesting ? 150_000_000 : 1_200_000_000) {
        self.loginDelayNanoseconds = loginDelayNanoseconds
    }

    func login(phone: String, password: String) async throws -> String {
        if loginDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: loginDelayNanoseconds)
        }

        guard Self.acceptedDemoPhones.contains(phone), password == Self.demoPassword else {
            throw AuthError.invalidCredentials
        }

        return "mintyn-demo-token"
    }
}
