import UIKit

final class QuickActionButton: UIButton {
    private let iconImageView = UIImageView()
    private let titleLabelView = AppLabel(
        style: AppTextStyles.quickActionTitle,
        color: AppColors.textPrimary,
        alignment: .left,
        numberOfLines: 2
    )

    init(title: String, iconSystemName: String) {
        super.init(frame: .zero)
        setup(title: title, iconSystemName: iconSystemName)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String, iconSystemName: String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.surfacePrimary
        layer.cornerRadius = 16
        accessibilityTraits.insert(.button)

        iconImageView.image = UIImage(
            systemName: iconSystemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        )
        iconImageView.tintColor = AppColors.iconTint
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabelView.text = title
        addSubview(iconImageView)
        addSubview(titleLabelView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 68),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.md),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabelView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.md),
            titleLabelView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
