import UIKit

final class MainTabBarView: UIView {
    var onTabSelected: ((MainTab) -> Void)?

    private let backgroundView = UIView()
    private let shapeLayer = CAShapeLayer()
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
        updateShapeLayer()
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
        updateShapeLayer()
    }

    private func setup() {
        backgroundColor = .clear

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.addSublayer(shapeLayer)

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
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 24),

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

    private func updateShapeLayer() {
        let width = backgroundView.bounds.width
        let height = backgroundView.bounds.height
        guard width > 0 else { return }

        let path = UIBezierPath()
        let cutoutWidth: CGFloat = 110
        let cutoutDepth: CGFloat = 34
        
        let center = width / 2
        let curveStartX = center - cutoutWidth / 2
        let curveEndX = center + cutoutWidth / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: curveStartX, y: 0))
        
        let cp1 = CGPoint(x: curveStartX + cutoutWidth * 0.25, y: 0)
        let cp2 = CGPoint(x: curveStartX + cutoutWidth * 0.20, y: cutoutDepth)
        let bottom = CGPoint(x: center, y: cutoutDepth)
        path.addCurve(to: bottom, controlPoint1: cp1, controlPoint2: cp2)
        
        let cp3 = CGPoint(x: curveEndX - cutoutWidth * 0.20, y: cutoutDepth)
        let cp4 = CGPoint(x: curveEndX - cutoutWidth * 0.25, y: 0)
        path.addCurve(to: CGPoint(x: curveEndX, y: 0), controlPoint1: cp3, controlPoint2: cp4)
        
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.shadowPath = path.cgPath
    }

    private func applyChrome() {
        shapeLayer.fillColor = AppColors.homeNavigationBackground.cgColor
        shapeLayer.shadowColor = AppColors.homeNavigationShadow.cgColor
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowRadius = 18
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
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
