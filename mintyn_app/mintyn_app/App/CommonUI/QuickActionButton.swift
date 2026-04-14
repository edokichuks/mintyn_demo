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
            backgroundColor: AppColors.surfacePrimary,
            borderColor: nil,
            borderWidth: 0,
            iconTintColor: AppColors.iconTint,
            titleColor: AppColors.textPrimary,
            subtitleColor: AppColors.textSecondary
        )

        static let highlighted = Style(
            backgroundColor: AppColors.surfacePrimary,
            borderColor: AppColors.successMuted.withAlphaComponent(0.45),
            borderWidth: 1,
            iconTintColor: AppColors.successMuted,
            titleColor: AppColors.textPrimary,
            subtitleColor: AppColors.textSecondary
        )

        static let mutedSuccess = Style(
            backgroundColor: AppColors.surfacePrimary,
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

    init(
        title: String,
        subtitle: String? = nil,
        iconSystemName: String,
        style: Style = .default
    ) {
        super.init(frame: .zero)
        setup(title: title, subtitle: subtitle, iconSystemName: iconSystemName, style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String, subtitle: String?, iconSystemName: String, style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 16
        layer.borderColor = style.borderColor?.cgColor
        layer.borderWidth = style.borderWidth
        accessibilityTraits.insert(.button)

        iconImageView.image = UIImage(
            systemName: iconSystemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        )
        iconImageView.tintColor = style.iconTintColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabelView.text = title
        titleLabelView.textColor = style.titleColor
        subtitleLabelView.text = subtitle
        subtitleLabelView.textColor = style.subtitleColor
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

        addAction(UIAction { _ in }, for: .touchUpInside)
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.82 : 1.0
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.985, y: 0.985) : .identity
        }
    }
}
