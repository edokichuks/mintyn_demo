import UIKit

final class PhonePrefixView: UIView {
    private let flagLabel = AppLabel(
        style: AppTextStyles.input,
        color: AppColors.textPrimary,
        alignment: .center
    )
    private let prefixLabel = AppLabel(
        style: AppTextStyles.input,
        color: AppColors.textSecondary
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 76, height: 24)
    }

    private func setupUI() {
        flagLabel.text = "🇳🇬"
        prefixLabel.text = "+234"

        let stackView = UIStackView(arrangedSubviews: [flagLabel, prefixLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Spacing.sm

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
