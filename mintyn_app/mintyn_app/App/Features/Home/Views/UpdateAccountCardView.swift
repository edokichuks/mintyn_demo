import UIKit

final class UpdateAccountCardView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let iconView = UIImageView()
    private let titleLabel = AppLabel(style: AppTextStyles.homeSectionHeader, color: AppColors.textOnBrand)
    private let messageLabel = AppLabel(
        style: AppTextStyles.body,
        color: AppColors.textOnBrand,
        alignment: .left,
        numberOfLines: 0
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
        actionButton.setTitle(buttonTitle, for: .normal)
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
        actionButton.backgroundColor = AppColors.homeCardSecondaryBackground
        actionButton.layer.cornerRadius = 16
        actionButton.layer.cornerCurve = .continuous
        actionButton.setTitleColor(AppColors.textPrimary, for: .normal)
        actionButton.titleLabel?.font = AppTextStyles.homeSmallAction
        actionButton.setImage(
            UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)),
            for: .normal
        )
        actionButton.semanticContentAttribute = .forceRightToLeft
        actionButton.tintColor = AppColors.textPrimary
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 14, bottom: 9, right: 14)

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
            heightAnchor.constraint(equalToConstant: 128),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}
