import UIKit

final class MainTabsViewController: UIViewController {
    private let viewControllers: [MainTab: UIViewController]
    private let initialTab: MainTab

    private let contentContainerView = UIView()
    private let tabBarView = MainTabBarView()
    private var selectedTab: MainTab = .home
    private var currentViewController: UIViewController?

    init(
        viewControllers: [MainTab: UIViewController],
        initialTab: MainTab = .home
    ) {
        self.viewControllers = viewControllers
        self.initialTab = initialTab
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        select(tab: initialTab)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func select(tabIdentifier: String?) {
        select(tab: MainTab.fallback(from: tabIdentifier))
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background

        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.onTabSelected = { [weak self] tab in
            self?.select(tab: tab)
        }

        view.addSubview(contentContainerView)
        view.addSubview(tabBarView)

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 118)
        ])
    }

    private func select(tab: MainTab) {
        let resolvedTab = viewControllers[tab] == nil ? MainTab.home : tab
        guard resolvedTab != selectedTab || currentViewController == nil else { return }
        guard let nextViewController = viewControllers[resolvedTab] ?? viewControllers[.home] else { return }

        let previousViewController = currentViewController
        previousViewController?.willMove(toParent: nil)
        previousViewController?.view.removeFromSuperview()
        previousViewController?.removeFromParent()

        addChild(nextViewController)
        contentContainerView.addSubview(nextViewController.view)
        nextViewController.view.pinToEdges(of: contentContainerView)
        nextViewController.didMove(toParent: self)

        selectedTab = resolvedTab
        currentViewController = nextViewController
        tabBarView.setSelectedTab(resolvedTab)
        view.accessibilityValue = "\(resolvedTab.title) selected"
    }
}
