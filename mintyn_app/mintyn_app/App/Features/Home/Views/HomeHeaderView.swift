import UIKit

final class HomeHeaderView: UIView {
    private let logoMarkStackView = UIStackView()
    private let titleLabel = AppLabel(
        style: AppFonts.scaledFont(size: 16, weight: .semibold, textStyle: .headline),
        color: AppColors.textPrimary
    )
    private let actionButtonsStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        actionButtonsStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .forEach { $0.layer.borderColor = AppColors.homeHeaderActionBorder.cgColor }
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "homeHeaderSection"

        let logoContainer = UIStackView()
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.axis = .horizontal
        logoContainer.alignment = .center
        logoContainer.spacing = 8

        logoMarkStackView.translatesAutoresizingMaskIntoConstraints = false
        logoMarkStackView.axis = .horizontal
        logoMarkStackView.alignment = .bottom
        logoMarkStackView.spacing = 2

        [10, 14, 18].forEach { height in
            let barView = UIView()
            barView.translatesAutoresizingMaskIntoConstraints = false
            barView.backgroundColor = AppColors.brandPrimary
            barView.layer.cornerRadius = 1.5
            logoMarkStackView.addArrangedSubview(barView)
            NSLayoutConstraint.activate([
                barView.widthAnchor.constraint(equalToConstant: 3),
                barView.heightAnchor.constraint(equalToConstant: CGFloat(height))
            ])
        }

        titleLabel.text = "MINTYN"

        actionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButtonsStackView.axis = .horizontal
        actionButtonsStackView.spacing = 8

        logoContainer.addArrangedSubview(logoMarkStackView)
        logoContainer.addArrangedSubview(titleLabel)

        let contentStackView = UIStackView(arrangedSubviews: [logoContainer, UIView(), actionButtonsStackView])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center

        addSubview(contentStackView)

        [("magnifyingglass", "homeSearchButton"), ("headphones", "homeSupportButton"), ("bell", "homeNotificationsButton")].forEach {
            actionButtonsStackView.addArrangedSubview(makeActionButton(symbolName: $0.0, accessibilityIdentifier: $0.1))
        }

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func makeActionButton(symbolName: String, accessibilityIdentifier: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = accessibilityIdentifier
        button.backgroundColor = AppColors.homeHeaderActionBackground
        button.layer.cornerRadius = 13
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColors.homeHeaderActionBorder.cgColor
        button.tintColor = AppColors.textPrimary
        button.setImage(
            UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)),
            for: .normal
        )
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42)
        ])
        return button
    }
}
