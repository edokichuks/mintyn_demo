import UIKit

final class CompactQuickAccessItemView: UIView {
    private let iconBackgroundView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.homeQuickAccessTitle,
        color: AppColors.textPrimary,
        alignment: .center,
        numberOfLines: 2
    )
    private let contentStackView = UIStackView()

    init(item: HomeQuickAccessItem) {
        super.init(frame: .zero)
        setup(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(item: HomeQuickAccessItem) {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = item.accessibilityIdentifier

        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconBackgroundView.backgroundColor = AppColors.homeQuickAccessIconBackground
        iconBackgroundView.layer.cornerRadius = 10
        iconBackgroundView.layer.cornerCurve = .continuous

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: item.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        )
        iconImageView.tintColor = AppColors.homeQuickAccessIconTint
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = item.title

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 8

        addSubview(contentStackView)
        iconBackgroundView.addSubview(iconImageView)
        contentStackView.addArrangedSubview(iconBackgroundView)
        contentStackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
