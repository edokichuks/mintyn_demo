import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let tokenStore: AuthTokenStoreProtocol

    init(
        navigationController: UINavigationController,
        tokenStore: AuthTokenStoreProtocol = KeychainService()
    ) {
        self.navigationController = navigationController
        self.tokenStore = tokenStore
    }

    func start() {
        if AppLaunchArguments.shouldResetPersistedAuth {
            tokenStore.clearToken()
        }

        if tokenStore.fetchToken() != nil {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            tokenStore: tokenStore
        )
        authCoordinator.onAuthenticationComplete = { [weak self] in
            self?.showMainFlow()
        }
        childCoordinators = [authCoordinator]
        authCoordinator.start()
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            tokenStore: tokenStore
        )
        mainCoordinator.onLogout = { [weak self] in
            self?.showAuthFlow()
        }
        childCoordinators = [mainCoordinator]
        mainCoordinator.start()
    }
}
