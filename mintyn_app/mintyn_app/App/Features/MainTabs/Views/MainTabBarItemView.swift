import UIKit

final class MainTabBarItemView: UIControl {
    enum Style {
        case standard
        case floatingCenter
    }

    private let tab: MainTab
    private let style: Style
    private let selectionBackgroundView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.homeNavigationLabel,
        color: AppColors.homeNavigationInactive,
        alignment: .center
    )
    private let contentStackView = UIStackView()

    override var isSelected: Bool {
        didSet {
            applySelectionState()
        }
    }

    init(tab: MainTab, style: Style) {
        self.tab = tab
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applySelectionState()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = tab.accessibilityIdentifier
        accessibilityTraits = [.button]

        selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectionBackgroundView.backgroundColor = AppColors.homeNavigationSelectedBackground
        selectionBackgroundView.layer.cornerRadius = 20
        selectionBackgroundView.layer.cornerCurve = .continuous
        selectionBackgroundView.isUserInteractionEnabled = false

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerCurve = .continuous
        iconContainerView.isUserInteractionEnabled = false

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: tab.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: style == .floatingCenter ? 20 : 18, weight: .semibold)
        )
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false

        titleLabel.text = tab.title
        titleLabel.isUserInteractionEnabled = false

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 6
        contentStackView.isUserInteractionEnabled = false

        addSubview(selectionBackgroundView)
        addSubview(contentStackView)
        iconContainerView.addSubview(iconImageView)
        contentStackView.addArrangedSubview(iconContainerView)
        contentStackView.addArrangedSubview(titleLabel)

        let iconSide: CGFloat = style == .floatingCenter ? 58 : 28
        let verticalPadding: CGFloat = style == .floatingCenter ? 0 : 10

        NSLayoutConstraint.activate([
            selectionBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            selectionBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionBackgroundView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),

            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            iconContainerView.widthAnchor.constraint(equalToConstant: iconSide),
            iconContainerView.heightAnchor.constraint(equalToConstant: iconSide),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor)
        ])

        if style == .standard {
            selectionBackgroundView.isHidden = true
            iconContainerView.backgroundColor = .clear
            NSLayoutConstraint.activate([
                widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ])
        } else {
            iconContainerView.backgroundColor = AppColors.brandPrimary
            iconContainerView.layer.cornerRadius = iconSide / 2
            selectionBackgroundView.isHidden = true
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: 74)
            ])
        }

        applySelectionState()
    }

    private func applySelectionState() {
        switch style {
        case .standard:
            selectionBackgroundView.isHidden = !isSelected
            iconImageView.tintColor = isSelected ? AppColors.brandPrimary : AppColors.homeNavigationInactive
            titleLabel.textColor = isSelected ? AppColors.brandPrimary : AppColors.homeNavigationInactive
            accessibilityValue = isSelected ? "Selected" : "Not selected"
        case .floatingCenter:
            iconContainerView.backgroundColor = AppColors.brandPrimary
            iconImageView.tintColor = AppColors.textOnBrand
            titleLabel.textColor = isSelected ? AppColors.brandPrimary : AppColors.homeNavigationInactive
            accessibilityValue = isSelected ? "Selected" : "Not selected"
        }
    }
}
