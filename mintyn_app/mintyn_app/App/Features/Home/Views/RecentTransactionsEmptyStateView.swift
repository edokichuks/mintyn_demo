import UIKit

final class RecentTransactionsEmptyStateView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.body,
        color: AppColors.textPrimary,
        alignment: .center,
        numberOfLines: 0
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.homeEmptyStateBackground
        layer.cornerRadius = 18
        layer.cornerCurve = .continuous

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: "list.bullet.rectangle.portrait",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        )
        iconImageView.tintColor = AppColors.homeEmptyStateIcon

        titleLabel.text = "No Transactions Found."

        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 270),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -18),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
}
