import UIKit

final class DashboardActionButton: UIButton {
    enum Style {
        case light
        case brand
    }

    private let iconImageView = UIImageView()
    private let titleLabelView = AppLabel(style: AppTextStyles.homeActionButton)
    private let contentStackView = UIStackView()
    private let style: Style

    init(title: String, symbolName: String, style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup(title: title, symbolName: symbolName)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.84 : 1.0
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
        }
    }

    private func setup(title: String, symbolName: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 26
        layer.cornerCurve = .continuous

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        )
        iconImageView.contentMode = .scaleAspectFit

        titleLabelView.text = title

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 10

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabelView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        switch style {
        case .light:
            backgroundColor = AppColors.homeCardSecondaryBackground
            iconImageView.tintColor = AppColors.textPrimary
            titleLabelView.textColor = AppColors.textPrimary
        case .brand:
            backgroundColor = AppColors.brandPrimary
            iconImageView.tintColor = AppColors.textOnBrand
            titleLabelView.textColor = AppColors.textOnBrand
        }
    }
}
