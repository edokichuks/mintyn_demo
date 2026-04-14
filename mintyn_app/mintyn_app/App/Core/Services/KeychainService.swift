import Foundation
import Security

protocol AuthTokenStoreProtocol {
    func saveToken(_ token: String) throws
    func fetchToken() -> String?
    func clearToken()
}

enum KeychainError: LocalizedError, Equatable {
    case unexpectedStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .unexpectedStatus(let status):
            return "Unable to update secure storage (\(status))."
        }
    }
}

final class KeychainService: AuthTokenStoreProtocol {
    private let service: String
    private let account: String

    init(
        service: String = Bundle.main.bundleIdentifier ?? "co.chuksDev.mintyn-app",
        account: String = "auth_token"
    ) {
        self.service = service
        self.account = account
    }

    func saveToken(_ token: String) throws {
        let tokenData = Data(token.utf8)

        let attributes: [CFString: Any] = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: tokenData
        ]

        let addStatus = SecItemAdd(attributes as CFDictionary, nil)
        if addStatus == errSecSuccess {
            return
        }

        guard addStatus == errSecDuplicateItem else {
            throw KeychainError.unexpectedStatus(addStatus)
        }

        let query = baseQuery
        let updateAttributes: [CFString: Any] = [kSecValueData: tokenData]
        let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)

        guard updateStatus == errSecSuccess else {
            throw KeychainError.unexpectedStatus(updateStatus)
        }
    }

    func fetchToken() -> String? {
        var query = baseQuery
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return token
    }

    func clearToken() {
        SecItemDelete(baseQuery as CFDictionary)
    }

    private var baseQuery: [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
    }
}
