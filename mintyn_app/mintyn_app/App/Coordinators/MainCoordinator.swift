import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var onLogout: (() -> Void)?
    private let tokenStore: AuthTokenStoreProtocol

    init(
        navigationController: UINavigationController,
        tokenStore: AuthTokenStoreProtocol = KeychainService()
    ) {
        self.navigationController = navigationController
        self.tokenStore = tokenStore
    }

    func start() {
        let homeViewController = HomeViewController()
        homeViewController.onLogoutRequested = { [weak self] in
            self?.tokenStore.clearToken()
            self?.onLogout?()
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([homeViewController], animated: true)
    }
}
