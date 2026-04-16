import UIKit

final class MainTabBarView: UIView {
    var onTabSelected: ((MainTab) -> Void)?

    private let backgroundView = UIView()
    private let centerCutoutView = UIView()
    private let topBorderView = UIView()
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
        backgroundView.layer.shadowColor = AppColors.homeNavigationShadow.cgColor
        backgroundView.layer.shadowPath = UIBezierPath(
            roundedRect: backgroundView.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 18, height: 18)
        ).cgPath
        centerCutoutView.layer.cornerRadius = centerCutoutView.bounds.height / 2
    }

    func setSelectedTab(_ tab: MainTab) {
        itemViews.forEach { currentTab, itemView in
            itemView.isSelected = currentTab == tab
        }
        centerItemView.isSelected = tab == .menu
        accessibilityValue = "\(tab.title) selected"
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyChrome()
    }

    private func setup() {
        backgroundColor = .clear

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.clipsToBounds = false
        backgroundView.layer.cornerRadius = 18
        backgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowRadius = 18
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: -3)

        centerCutoutView.translatesAutoresizingMaskIntoConstraints = false
        centerCutoutView.isUserInteractionEnabled = false
        centerCutoutView.layer.cornerCurve = .continuous

        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.isUserInteractionEnabled = false

        [leadingStackView, trailingStackView].forEach { stackView in
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 4
        }

        addSubview(backgroundView)
        addSubview(centerCutoutView)
        addSubview(centerItemView)
        backgroundView.addSubview(topBorderView)
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
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 24),

            topBorderView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            topBorderView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1),

            centerCutoutView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerCutoutView.centerYAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 2),
            centerCutoutView.widthAnchor.constraint(equalToConstant: 144),
            centerCutoutView.heightAnchor.constraint(equalToConstant: 38),

            centerItemView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerItemView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4),

            leadingStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            leadingStackView.trailingAnchor.constraint(equalTo: centerItemView.leadingAnchor, constant: -8),
            leadingStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3),
            leadingStackView.heightAnchor.constraint(equalToConstant: 60),

            trailingStackView.leadingAnchor.constraint(equalTo: centerItemView.trailingAnchor, constant: 8),
            trailingStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12),
            trailingStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3),
            trailingStackView.heightAnchor.constraint(equalToConstant: 60),

            centerItemView.topAnchor.constraint(equalTo: topAnchor)
        ])

        itemViews.values.forEach { itemView in
            itemView.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
        centerItemView.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)

        applyChrome()
    }

    private func applyChrome() {
        backgroundView.backgroundColor = AppColors.homeNavigationBackground
        centerCutoutView.backgroundColor = AppColors.background
        topBorderView.backgroundColor = AppColors.homeNavigationBorder
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
