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
        phoneText = value
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
        let digitsOnly = rawValue.filter(\.isNumber)

        if digitsOnly.count == 13, digitsOnly.hasPrefix("234") {
            return String(digitsOnly.dropFirst(3))
        }

        if digitsOnly.count == 11, digitsOnly.hasPrefix("0") {
            return String(digitsOnly.dropFirst())
        }

        if digitsOnly.count == 10 {
            return digitsOnly
        }

        return nil
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
