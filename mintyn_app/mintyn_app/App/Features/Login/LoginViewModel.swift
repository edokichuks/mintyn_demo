import Foundation

struct LoginViewState: Equatable {
    let phoneText: String
    let isPasswordHidden: Bool
    let isRememberMeSelected: Bool
    let isLoginEnabled: Bool
    let isLoading: Bool
    let errorMessage: String?
}

@MainActor
final class LoginViewModel {
    static let localPhoneDigitsCount = 10

    var onStateChange: ((LoginViewState) -> Void)?
    var onLoginSuccess: (() -> Void)?

    private let authService: AuthServiceProtocol
    private let tokenStore: AuthTokenStoreProtocol

    private var phoneText = ""
    private var passwordText = ""
    private var isPasswordHidden = true
    private var isRememberMeSelected = false
    private var isLoading = false
    private var errorMessage: String?
    private var loginTask: Task<Void, Never>?

    init(
        authService: AuthServiceProtocol,
        tokenStore: AuthTokenStoreProtocol
    ) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    deinit {
        loginTask?.cancel()
    }

    var currentState: LoginViewState {
        LoginViewState(
            phoneText: phoneText,
            isPasswordHidden: isPasswordHidden,
            isRememberMeSelected: isRememberMeSelected,
            isLoginEnabled: isFormSubmittable,
            isLoading: isLoading,
            errorMessage: errorMessage
        )
    }

    func updatePhone(_ value: String) {
        phoneText = Self.formatPhoneInput(value)
        clearErrorIfNeeded()
        publishState()
    }

    func updatePassword(_ value: String) {
        passwordText = value
        clearErrorIfNeeded()
        publishState()
    }

    func toggleRememberMe() {
        isRememberMeSelected.toggle()
        publishState()
    }

    func togglePasswordVisibility() {
        isPasswordHidden.toggle()
        publishState()
    }

    func submit() {
        guard !isLoading else { return }

        let trimmedPassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phoneText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Enter your phone number and password to continue."
            publishState()
            return
        }

        guard let normalizedPhone = Self.normalizePhone(phoneText) else {
            errorMessage = "Enter a valid 10-digit Nigerian phone number."
            publishState()
            return
        }

        errorMessage = nil
        isLoading = true
        publishState()

        loginTask?.cancel()
        loginTask = Task { [weak self] in
            guard let self else { return }

            do {
                let token = try await authService.login(phone: normalizedPhone, password: trimmedPassword)

                if isRememberMeSelected {
                    try tokenStore.saveToken(token)
                } else {
                    tokenStore.clearToken()
                }

                guard !Task.isCancelled else { return }
                isLoading = false
                publishState()
                onLoginSuccess?()
            } catch let error as AuthError {
                guard !Task.isCancelled else { return }
                isLoading = false
                errorMessage = error.errorDescription
                publishState()
            } catch let error as KeychainError {
                guard !Task.isCancelled else { return }
                isLoading = false
                errorMessage = error.errorDescription
                publishState()
            } catch {
                guard !Task.isCancelled else { return }
                isLoading = false
                errorMessage = "Something went wrong. Please try again."
                publishState()
            }
        }
    }

    static func normalizePhone(_ rawValue: String) -> String? {
        let localDigits = sanitizedLocalPhoneDigits(from: rawValue)
        return localDigits.count == localPhoneDigitsCount ? localDigits : nil
    }

    static func formatPhoneInput(_ rawValue: String) -> String {
        let localDigits = sanitizedLocalPhoneDigits(from: rawValue)
        let groups = [3, 3, 4]

        var formattedParts = [String]()
        var startIndex = localDigits.startIndex

        for groupLength in groups where startIndex < localDigits.endIndex {
            let endIndex = localDigits.index(startIndex, offsetBy: groupLength, limitedBy: localDigits.endIndex) ?? localDigits.endIndex
            formattedParts.append(String(localDigits[startIndex..<endIndex]))
            startIndex = endIndex
        }

        return formattedParts.joined(separator: " ")
    }

    static func sanitizedLocalPhoneDigits(from rawValue: String) -> String {
        var digitsOnly = rawValue.filter(\.isNumber)

        if digitsOnly.hasPrefix("234") {
            digitsOnly = String(digitsOnly.dropFirst(3))
        } else if digitsOnly.hasPrefix("0") {
            digitsOnly = String(digitsOnly.dropFirst())
        }

        return String(digitsOnly.prefix(localPhoneDigitsCount))
    }

    private var isFormSubmittable: Bool {
        !isLoading && Self.normalizePhone(phoneText) != nil && !passwordText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func clearErrorIfNeeded() {
        if errorMessage != nil {
            errorMessage = nil
        }
    }

    private func publishState() {
        onStateChange?(currentState)
    }
}
