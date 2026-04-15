import UIKit

final class ExploreCardView: UIView {
    private let titleLabel = AppLabel(
        style: AppTextStyles.homeExploreTitle,
        color: AppColors.textPrimary,
        alignment: .center,
        numberOfLines: 2
    )
    private let subtitleLabel = AppLabel(
        style: AppTextStyles.homeExploreSubtitle,
        color: AppColors.textSecondary,
        alignment: .center,
        numberOfLines: 2
    )
    private let illustrationBackgroundView = UIView()
    private let illustrationImageView = UIImageView()

    init(item: HomeExploreItem) {
        super.init(frame: .zero)
        setup(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(item: HomeExploreItem) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.homeCardBackground
        layer.cornerRadius = 18
        layer.cornerCurve = .continuous

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        illustrationBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        illustrationBackgroundView.backgroundColor = AppColors.homeExploreIllustrationBackground
        illustrationBackgroundView.layer.cornerRadius = 26
        illustrationBackgroundView.layer.cornerCurve = .continuous

        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
        illustrationImageView.image = UIImage(
            systemName: item.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: item.style == .investment ? 34 : 40, weight: .medium)
        )
        illustrationImageView.tintColor = AppColors.brandPrimary
        illustrationImageView.contentMode = .scaleAspectFit

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(illustrationBackgroundView)
        illustrationBackgroundView.addSubview(illustrationImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            illustrationBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            illustrationBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            illustrationBackgroundView.widthAnchor.constraint(equalToConstant: 76),
            illustrationBackgroundView.heightAnchor.constraint(equalToConstant: 76),

            illustrationImageView.centerXAnchor.constraint(equalTo: illustrationBackgroundView.centerXAnchor),
            illustrationImageView.centerYAnchor.constraint(equalTo: illustrationBackgroundView.centerYAnchor)
        ])
    }
}
