import UIKit

final class MainTabBarView: UIView {
    var onTabSelected: ((MainTab) -> Void)?

    private let backgroundView = UIView()
    private let leadingStackView = UIStackView()
    private let trailingStackView = UIStackView()
    private let centerItemView = MainTabBarItemView(tab: .menu, style: .floatingCenter)
    private let itemViews: [MainTab: MainTabBarItemView] = [
        .home: MainTabBarItemView(tab: .home, style: .standard),
        .invest: MainTabBarItemView(tab: .invest, style: .standard),
        .transactions: MainTabBarItemView(tab: .transactions, style: .standard),
        .settings: MainTabBarItemView(tab: .settings, style: .standard)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "mainTabBar"
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = AppColors.homeNavigationShadow.cgColor
    }

    func setSelectedTab(_ tab: MainTab) {
        itemViews.forEach { currentTab, itemView in
            itemView.isSelected = currentTab == tab
        }
        centerItemView.isSelected = tab == .menu
        accessibilityValue = "\(tab.title) selected"
    }

    private func setup() {
        backgroundColor = .clear
        layer.shadowOpacity = 1
        layer.shadowRadius = 24
        layer.shadowOffset = CGSize(width: 0, height: 8)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = AppColors.homeNavigationBackground
        backgroundView.layer.cornerRadius = 28
        backgroundView.layer.cornerCurve = .continuous

        [leadingStackView, trailingStackView].forEach { stackView in
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 4
        }

        addSubview(backgroundView)
        addSubview(centerItemView)
        backgroundView.addSubview(leadingStackView)
        backgroundView.addSubview(trailingStackView)

        leadingStackView.addArrangedSubview(itemViews[.home]!)
        leadingStackView.addArrangedSubview(itemViews[.invest]!)
        trailingStackView.addArrangedSubview(itemViews[.transactions]!)
        trailingStackView.addArrangedSubview(itemViews[.settings]!)

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 76),

            centerItemView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            centerItemView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),

            leadingStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            leadingStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            leadingStackView.trailingAnchor.constraint(equalTo: centerItemView.leadingAnchor, constant: -8),
            leadingStackView.heightAnchor.constraint(equalToConstant: 58),

            trailingStackView.leadingAnchor.constraint(equalTo: centerItemView.trailingAnchor, constant: 8),
            trailingStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            trailingStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            trailingStackView.heightAnchor.constraint(equalToConstant: 58),

            centerItemView.topAnchor.constraint(equalTo: topAnchor)
        ])

        itemViews.values.forEach { itemView in
            itemView.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
        centerItemView.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
    }

    @objc private func tabTapped(_ sender: MainTabBarItemView) {
        switch sender.accessibilityIdentifier {
        case MainTab.home.accessibilityIdentifier:
            onTabSelected?(.home)
        case MainTab.invest.accessibilityIdentifier:
            onTabSelected?(.invest)
        case MainTab.transactions.accessibilityIdentifier:
            onTabSelected?(.transactions)
        case MainTab.settings.accessibilityIdentifier:
            onTabSelected?(.settings)
        default:
            onTabSelected?(.menu)
        }
    }
}
