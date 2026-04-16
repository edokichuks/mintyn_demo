import UIKit

final class PromoTileView: UIView {
    private let tile: HomePromoTile
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.homePromoTitle,
        color: AppColors.homePromoText,
        alignment: .center
    )

    init(tile: HomePromoTile) {
        self.tile = tile
        super.init(frame: .zero)
        setup(tile: tile)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard window != nil else {
            iconImageView.layer.removeAnimation(forKey: "promoDance")
            return
        }

        startIconAnimationIfNeeded()
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
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 38, weight: .medium)
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

    private func startIconAnimationIfNeeded() {
        guard iconImageView.layer.animation(forKey: "promoDance") == nil else { return }

        let dance = CAAnimationGroup()
        dance.animations = [
            makeVerticalBobAnimation(),
            makeRotationAnimation(),
            makePulseAnimation()
        ]
        dance.duration = 2.7
        dance.repeatCount = .infinity
        dance.isRemovedOnCompletion = false
        dance.beginTime = CACurrentMediaTime() + animationDelay

        iconImageView.layer.add(dance, forKey: "promoDance")
    }

    private func makeVerticalBobAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [0, -5, 1, -3, 0]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animation.isAdditive = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    private func makeRotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [0, 0.05, -0.04, 0.03, 0]
        animation.keyTimes = [0, 0.22, 0.5, 0.78, 1]
        animation.isAdditive = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    private func makePulseAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 1.04, 0.98, 1.02, 1]
        animation.keyTimes = [0, 0.2, 0.5, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    private var animationDelay: CFTimeInterval {
        switch tile.style {
        case .marketplace:
            return 0
        case .easyCollect:
            return 0.25
        case .business:
            return 0.45
        }
    }
}
