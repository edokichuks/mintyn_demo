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
    private let gradientContainerView = GradientContainerView()
    private let iconImageView = UIImageView()
    private let customLogoView = MintynLogoView()
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
        updateFloatingButtonChrome()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius: CGFloat = style == .floatingCenter ? 16 : iconContainerView.bounds.height / 2
        gradientContainerView.layer.cornerRadius = cornerRadius
        iconContainerView.layer.cornerRadius = cornerRadius
        selectionBackgroundView.layer.cornerRadius = selectionBackgroundView.bounds.height / 2
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = tab.accessibilityIdentifier
        accessibilityTraits = [.button]

        selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectionBackgroundView.backgroundColor = AppColors.homeNavigationSelectedBackground
        selectionBackgroundView.layer.cornerCurve = .continuous
        selectionBackgroundView.isUserInteractionEnabled = false

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerCurve = .continuous
        iconContainerView.isUserInteractionEnabled = false
        
        gradientContainerView.translatesAutoresizingMaskIntoConstraints = false
        gradientContainerView.layer.cornerCurve = .continuous
        gradientContainerView.isUserInteractionEnabled = false

        let iconSide: CGFloat = style == .floatingCenter ? 56 : 24
        let iconPointSize: CGFloat = style == .floatingCenter ? 24 : 20

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: tab.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: iconPointSize, weight: .medium)
        )
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false
        
        customLogoView.translatesAutoresizingMaskIntoConstraints = false
        customLogoView.iconTintColor = AppColors.textWhite
        customLogoView.isUserInteractionEnabled = false

        titleLabel.text = tab.title
        titleLabel.isUserInteractionEnabled = false

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = style == .floatingCenter ? 6 : 4
        contentStackView.isUserInteractionEnabled = false

        addSubview(selectionBackgroundView)
        addSubview(contentStackView)
        iconContainerView.addSubview(gradientContainerView)
        iconContainerView.addSubview(iconImageView)
        iconContainerView.addSubview(customLogoView)
        contentStackView.addArrangedSubview(iconContainerView)
        contentStackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            selectionBackgroundView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
            selectionBackgroundView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: 32),
            selectionBackgroundView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 16),

            iconContainerView.widthAnchor.constraint(equalToConstant: iconSide),
            iconContainerView.heightAnchor.constraint(equalToConstant: iconSide),
            
            gradientContainerView.topAnchor.constraint(equalTo: iconContainerView.topAnchor),
            gradientContainerView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor),
            gradientContainerView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor),
            gradientContainerView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            customLogoView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            customLogoView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            customLogoView.widthAnchor.constraint(equalToConstant: 24),
            customLogoView.heightAnchor.constraint(equalToConstant: 24)
        ])

        if style == .standard {
            selectionBackgroundView.isHidden = true
            iconContainerView.backgroundColor = .clear
            gradientContainerView.isHidden = true
            customLogoView.isHidden = true
            iconImageView.isHidden = false
            NSLayoutConstraint.activate([
                widthAnchor.constraint(greaterThanOrEqualToConstant: 54)
            ])
        } else {
            selectionBackgroundView.isHidden = true
            gradientContainerView.isHidden = false
            customLogoView.isHidden = false
            iconImageView.isHidden = true
            
            iconContainerView.layer.shadowOpacity = 1
            iconContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
            iconContainerView.layer.shadowRadius = 14
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: 80)
            ])
        }

        updateFloatingButtonChrome()
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
            iconImageView.tintColor = AppColors.textOnBrand
            customLogoView.iconTintColor = AppColors.textOnBrand
            titleLabel.textColor = AppColors.homeNavigationInactive
            accessibilityValue = isSelected ? "Selected" : "Not selected"
        }
    }

    private func updateFloatingButtonChrome() {
        guard style == .floatingCenter else { return }

        gradientContainerView.colors = [
            AppColors.homeNavigationCenterButtonStart,
            AppColors.homeNavigationCenterButtonEnd
        ]
        gradientContainerView.startPoint = CGPoint(x: 0.15, y: 0.2)
        gradientContainerView.endPoint = CGPoint(x: 0.85, y: 1)
        iconContainerView.layer.shadowColor = AppColors.homeNavigationCenterButtonShadow.cgColor
    }
}
