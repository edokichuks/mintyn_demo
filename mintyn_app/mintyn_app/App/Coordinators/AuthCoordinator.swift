import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var onAuthenticationComplete: (() -> Void)?
    private let authService: AuthServiceProtocol
    private let tokenStore: AuthTokenStoreProtocol

    init(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol = AuthService(),
        tokenStore: AuthTokenStoreProtocol = KeychainService()
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.tokenStore = tokenStore
    }

    func start() {
        let viewModel = LoginViewModel(authService: authService, tokenStore: tokenStore)
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.onLoginSuccess = { [weak self] in
            self?.onAuthenticationComplete?()
        }
        loginVC.onForgotPasswordRequested = { [weak self] in
            self?.showPlaceholder(
                title: "Forgot Password",
                message: "Password recovery is not implemented in this demo. Use the mock credentials to continue exploring the authenticated flow.",
                symbolName: "questionmark.circle"
            )
        }
        loginVC.onRegisterDeviceRequested = { [weak self] in
            self?.showPlaceholder(
                title: "Register New Device",
                message: "Device registration is represented by this placeholder screen in the demo. Return to login to continue with the mocked authentication flow.",
                symbolName: "iphone.gen3"
            )
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([loginVC], animated: false)
    }

    private func showPlaceholder(title: String, message: String, symbolName: String) {
        let placeholderViewController = InfoPlaceholderViewController(
            titleText: title,
            messageText: message,
            symbolName: symbolName
        )
        navigationController.pushViewController(placeholderViewController, animated: true)
    }
}
