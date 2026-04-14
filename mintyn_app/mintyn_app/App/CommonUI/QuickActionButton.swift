import UIKit

final class QuickActionButton: UIButton {
    struct Style {
        let backgroundColor: UIColor
        let borderColor: UIColor?
        let borderWidth: CGFloat
        let iconTintColor: UIColor
        let titleColor: UIColor
        let subtitleColor: UIColor

        static let `default` = Style(
            backgroundColor: AppColors.surfaceSecondary,
            borderColor: nil,
            borderWidth: 0,
            iconTintColor: AppColors.iconTint,
            titleColor: AppColors.textPrimary,
            subtitleColor: AppColors.textSecondary
        )

        static let highlighted = Style(
            backgroundColor: AppColors.surfaceSecondary,
            borderColor: AppColors.successMuted.withAlphaComponent(0.45),
            borderWidth: 1,
            iconTintColor: AppColors.successMuted,
            titleColor: AppColors.textPrimary,
            subtitleColor: AppColors.textSecondary
        )

        static let mutedSuccess = Style(
            backgroundColor: AppColors.surfaceSecondary,
            borderColor: nil,
            borderWidth: 0,
            iconTintColor: AppColors.iconSuccessTint,
            titleColor: AppColors.textPrimary,
            subtitleColor: AppColors.textSecondary
        )
    }

    private let iconImageView = UIImageView()
    private let titleLabelView = AppLabel(
        style: AppTextStyles.quickActionTitle,
        color: AppColors.textPrimary,
        alignment: .left,
        numberOfLines: 1
    )
    private let subtitleLabelView = AppLabel(
        style: AppTextStyles.quickActionSubtitle,
        color: AppColors.textSecondary,
        alignment: .left,
        numberOfLines: 1
    )
    private let textStackView = UIStackView()
    private let buttonStyle: Style

    init(
        title: String,
        subtitle: String? = nil,
        iconSystemName: String,
        style: Style = .default
    ) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setup(title: title, subtitle: subtitle, iconSystemName: iconSystemName, style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String, subtitle: String?, iconSystemName: String, style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        accessibilityTraits.insert(.button)

        iconImageView.image = UIImage(
            systemName: iconSystemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        )
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabelView.text = title
        subtitleLabelView.text = subtitle
        subtitleLabelView.isHidden = subtitle == nil

        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.spacing = 2
        textStackView.addArrangedSubview(titleLabelView)
        textStackView.addArrangedSubview(subtitleLabelView)

        addSubview(iconImageView)
        addSubview(textStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 68),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.md),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.md),
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        applyStyle()
        addAction(UIAction { _ in }, for: .touchUpInside)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyStyle()
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.82 : 1.0
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.985, y: 0.985) : .identity
        }
    }

    private func applyStyle() {
        backgroundColor = buttonStyle.backgroundColor
        layer.borderColor = buttonStyle.borderColor?.cgColor
        layer.borderWidth = buttonStyle.borderWidth
        iconImageView.tintColor = buttonStyle.iconTintColor
        titleLabelView.textColor = buttonStyle.titleColor
        subtitleLabelView.textColor = buttonStyle.subtitleColor
    }
}
