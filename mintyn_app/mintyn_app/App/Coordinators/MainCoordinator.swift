import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var onLogout: (() -> Void)?
    private let tokenStore: AuthTokenStoreProtocol
    private let appearanceService: AppAppearanceServing

    init(
        navigationController: UINavigationController,
        tokenStore: AuthTokenStoreProtocol = KeychainService(),
        appearanceService: AppAppearanceServing = AppAppearanceService()
    ) {
        self.navigationController = navigationController
        self.tokenStore = tokenStore
        self.appearanceService = appearanceService
    }

    func start() {
        let homeViewModel = HomeViewModel(dashboardService: HomeDashboardService())
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let settingsViewModel = SettingsViewModel(contentProvider: SettingsContentProvider())
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)

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
        settingsViewController.onLogoutRequested = { [weak self] in
            self?.tokenStore.clearToken()
            self?.onLogout?()
        }
        settingsViewController.onDestinationRequested = { [weak self] destination in
            self?.handleSettingsDestination(destination)
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

    private func handleSettingsDestination(_ destination: SettingsDestination) {
        switch destination {
        case .section(let sectionID):
            let detail = makeSettingsDetailController(
                title: sectionID.title,
                message: message(for: sectionID),
                symbolName: sectionID.symbolName ?? "gearshape"
            )
            navigationController.pushViewController(detail, animated: true)
        case .child(.appearance):
            showAppearanceSettings()
        case .child(let childID):
            let detail = makeSettingsDetailController(
                title: childID.title,
                message: message(for: childID),
                symbolName: symbolName(for: childID)
            )
            navigationController.pushViewController(detail, animated: true)
        }
    }

    private func showAppearanceSettings() {
        let viewModel = SettingsAppearanceViewModel(appearanceService: appearanceService)
        let viewController = SettingsAppearanceViewController(viewModel: viewModel)
        viewController.onAppearanceSelected = { [weak self] appearance in
            self?.appearanceService.apply(appearance, to: self?.navigationController.view.window)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeSettingsDetailController(
        title: String,
        message: String,
        symbolName: String
    ) -> SettingsDetailViewController {
        SettingsDetailViewController(
            titleText: title,
            messageText: message,
            symbolName: symbolName
        )
    }

    private func message(for sectionID: SettingsSectionID) -> String {
        switch sectionID {
        case .accountManagement:
            return "Manage your account limits, linked profiles, and everyday account preferences from this section."
        case .referrals:
            return "Track referral activity, review rewards, and keep up with your referral performance here."
        case .legal:
            return "Review the legal terms, disclosures, and policy documents that apply to your Mintyn profile."
        case .createBusinessAccount:
            return "Start the business account setup flow and review the requirements needed to move from personal banking."
        case .profile, .helpAndSupport, .system, .logout:
            return "This setting opens inside the expanded list on the main settings screen."
        }
    }

    private func message(for childID: SettingsChildID) -> String {
        switch childID {
        case .personalInformation:
            return "Review and update your personal profile details exactly as they appear on your account."
        case .employmentInformation:
            return "Keep your employment details up to date so your account information stays complete."
        case .identificationInformation:
            return "Manage the IDs and verification records that support your profile and account limits."
        case .addressInformation:
            return "View the address details tied to your profile and confirm that your contact information is current."
        case .nextOfKin:
            return "Maintain the next-of-kin contact attached to your account for support and compliance scenarios."
        case .frequentlyAskedQuestions:
            return "Browse common questions and answers covering core Mintyn features and account support."
        case .helpCenter:
            return "Open the help center to find guided support articles and product assistance."
        case .chatWithUs:
            return "Start a direct conversation with the support team when you need help with your account."
        case .rateUs:
            return "Tell the team how the experience feels and help improve the product with your rating."
        case .socialMedia:
            return "See the official social channels where Mintyn shares product updates, support, and news."
        case .tellUsWhatYouWant:
            return "Share product ideas, requests, and feedback about the features you want to see next."
        case .autoLogoff:
            return "Control how long the app stays active before it signs you out automatically for security."
        case .appearance:
            return "Choose whether Mintyn follows the system theme or always uses light or dark appearance."
        }
    }

    private func symbolName(for childID: SettingsChildID) -> String {
        switch childID {
        case .personalInformation:
            return "person.text.rectangle"
        case .employmentInformation:
            return "briefcase"
        case .identificationInformation:
            return "person.text.rectangle.fill"
        case .addressInformation:
            return "house"
        case .nextOfKin:
            return "person.2"
        case .frequentlyAskedQuestions:
            return "questionmark.circle"
        case .helpCenter:
            return "lifepreserver"
        case .chatWithUs:
            return "message"
        case .rateUs:
            return "star"
        case .socialMedia:
            return "network"
        case .tellUsWhatYouWant:
            return "bubble.left.and.bubble.right"
        case .autoLogoff:
            return "lock"
        case .appearance:
            return "circle.lefthalf.filled"
        }
    }
}
