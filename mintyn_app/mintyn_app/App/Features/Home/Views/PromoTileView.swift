import UIKit

final class PromoTileView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.homePromoTitle,
        color: AppColors.homePromoText,
        alignment: .center
    )

    init(tile: HomePromoTile) {
        super.init(frame: .zero)
        setup(tile: tile)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(tile: HomePromoTile) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 18
        layer.cornerCurve = .continuous

        switch tile.style {
        case .marketplace:
            backgroundColor = AppColors.homeMarketplaceBackground
        case .easyCollect:
            backgroundColor = AppColors.homeEasyCollectBackground
        case .business:
            backgroundColor = AppColors.homeBusinessBackground
        }

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: tile.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .medium)
        )
        iconImageView.tintColor = AppColors.homePromoText
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = tile.title

        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 104),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
