import UIKit

final class RememberMeCheckboxView: UIControl {
    private enum Animation {
        static let duration: TimeInterval = 0.55
        static let scaleTransform = CGAffineTransform(scaleX: 0.78, y: 0.78)
    }

    private let imageView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.checkbox,
        color: AppColors.textSecondary
    )

    var isChecked: Bool = false {
        didSet {
            let shouldAnimate = oldValue != isChecked && window != nil
            updateAppearance(animated: shouldAnimate)
        }
    }

    init(title: String = "Remember me") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI(title: title)
        updateAppearance(animated: false)
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

    private func updateAppearance(animated: Bool) {
        let updatedImage = UIImage(
            systemName: isChecked ? "checkmark.square.fill" : "square",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        )
        let updatedTintColor = isChecked ? AppColors.brandPrimary : AppColors.textSecondary

        let applyChanges = {
            self.imageView.image = updatedImage
            self.imageView.tintColor = updatedTintColor
            self.accessibilityValue = self.isChecked ? "Checked" : "Unchecked"
            self.accessibilityTraits = self.isChecked ? [.button, .selected] : [.button]
        }

        guard animated else {
            imageView.transform = .identity
            applyChanges()
            return
        }

        imageView.transform = Animation.scaleTransform
        UIView.transition(
            with: imageView,
            duration: Animation.duration,
            options: [.transitionCrossDissolve, .curveEaseInOut]
        ) {
            applyChanges()
        }
        UIView.animate(
            withDuration: Animation.duration,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.12,
            options: [.curveEaseInOut]
        ) {
            self.imageView.transform = .identity
        }
    }
}
