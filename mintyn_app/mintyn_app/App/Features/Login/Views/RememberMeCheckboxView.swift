import UIKit

final class RememberMeCheckboxView: UIControl {
    private let imageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.checkbox,
        color: AppColors.textSecondary
    )

    var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    init(title: String = "Remember me") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI(title: title)
        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.65 : 1.0
        }
    }

    private func setupUI(title: String) {
        accessibilityTraits = [.button]
        titleLabel.text = title

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func updateAppearance() {
        imageView.image = UIImage(
            systemName: isChecked ? "checkmark.square.fill" : "square",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        )
        imageView.tintColor = isChecked ? AppColors.brandPrimary : AppColors.textSecondary
        accessibilityValue = isChecked ? "Checked" : "Unchecked"
        accessibilityTraits = isChecked ? [.button, .selected] : [.button]
    }
}
