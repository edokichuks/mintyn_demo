import UIKit

final class AppButton: UIButton {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var storedTitle: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.brandPrimary
        setTitleColor(AppColors.textOnBrand, for: .normal)
        setTitleColor(AppColors.textOnBrand.withAlphaComponent(0.85), for: .disabled)
        titleLabel?.font = AppTextStyles.button
        layer.cornerRadius = 16
        clipsToBounds = true
        accessibilityTraits.insert(.button)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = AppColors.textOnBrand
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        updateAppearance()
    }

    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard isEnabled else { return }
            backgroundColor = isHighlighted ? AppColors.brandPrimaryPressed : AppColors.brandPrimary
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
        }
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            if !activityIndicator.isAnimating {
                storedTitle = title(for: .normal)
            }
            setTitle(nil, for: .normal)
            isEnabled = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            if let storedTitle {
                setTitle(storedTitle, for: .normal)
                self.storedTitle = nil
            }
        }
        updateAppearance()
    }

    private func updateAppearance() {
        backgroundColor = isEnabled ? AppColors.brandPrimary : AppColors.brandPrimaryDisabled
        alpha = isEnabled ? 1.0 : 0.8
    }
}
