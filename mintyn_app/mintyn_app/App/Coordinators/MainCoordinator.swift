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
        let homeViewModel = HomeViewModel(dashboardService: HomeDashboardService())
        let homeViewController = HomeViewController(viewModel: homeViewModel)

        let investViewController = UnavailableFeatureViewController(
            featureTitle: "Invest",
            messageText: "Screen not available in this demo yet.",
            symbolName: "chart.bar.doc.horizontal"
        )
        let menuViewController = UnavailableFeatureViewController(
            featureTitle: "Menu",
            messageText: "Screen not available in this demo yet.",
            symbolName: "square.grid.2x2"
        )
        let transactionsViewController = UnavailableFeatureViewController(
            featureTitle: "Transactions",
            messageText: "Screen not available in this demo yet.",
            symbolName: "list.bullet.rectangle"
        )
        let settingsViewController = UnavailableFeatureViewController(
            featureTitle: "Settings",
            messageText: "Screen not available in this demo yet.",
            symbolName: "gearshape.2",
            actionTitle: "Logout",
            actionAccessibilityIdentifier: "settingsLogoutButton"
        )
        settingsViewController.onActionRequested = { [weak self] in
            self?.tokenStore.clearToken()
            self?.onLogout?()
        }

        let mainTabsViewController = MainTabsViewController(
            viewControllers: [
                .home: homeViewController,
                .invest: investViewController,
                .menu: menuViewController,
                .transactions: transactionsViewController,
                .settings: settingsViewController
            ]
        )

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([mainTabsViewController], animated: true)
    }
}
