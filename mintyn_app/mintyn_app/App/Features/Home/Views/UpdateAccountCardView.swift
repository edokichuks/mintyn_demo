import UIKit

final class UpdateAccountCardView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let iconView = UIImageView()
    private let titleLabel = AppLabel(style: AppTextStyles.homeSectionHeader, color: AppColors.textOnBrand)
    private let messageLabel = AppLabel(
        style: AppTextStyles.body,
        color: AppColors.textOnBrand,
        alignment: .left,
        numberOfLines: 2
    )
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.colors = [AppColors.homeUpdateCardStart.cgColor, AppColors.homeUpdateCardEnd.cgColor]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientLayer.colors = [AppColors.homeUpdateCardStart.cgColor, AppColors.homeUpdateCardEnd.cgColor]
    }

    func configure(title: String, message: String, buttonTitle: String) {
        titleLabel.text = title
        messageLabel.text = message
        applyActionButtonTitle(buttonTitle)
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 22
        layer.cornerCurve = .continuous
        clipsToBounds = true

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(
            systemName: "exclamationmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )
        iconView.tintColor = .systemRed

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.baseForegroundColor = AppColors.textPrimary
        buttonConfiguration.image = UIImage(
            systemName: "chevron.right",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        )
        buttonConfiguration.imagePlacement = .trailing
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        buttonConfiguration.background.backgroundColor = AppColors.homeCardSecondaryBackground
        buttonConfiguration.background.cornerRadius = 16
        actionButton.configuration = buttonConfiguration
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .vertical)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)

        let titleRow = UIStackView(arrangedSubviews: [iconView, titleLabel])
        titleRow.translatesAutoresizingMaskIntoConstraints = false
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 8

        let contentStackView = UIStackView(arrangedSubviews: [titleRow, messageLabel, actionButton])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.spacing = 14

        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 168),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 152),
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    private func applyActionButtonTitle(_ title: String) {
        var attributes = AttributeContainer()
        attributes.font = AppTextStyles.homeSmallAction

        var configuration = actionButton.configuration
        configuration?.attributedTitle = AttributedString(title, attributes: attributes)
        actionButton.configuration = configuration
    }
}
