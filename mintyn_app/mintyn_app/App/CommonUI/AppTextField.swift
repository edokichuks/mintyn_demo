import UIKit

final class AppTextField: UITextField {
    private let contentInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    private let accessorySpacing: CGFloat = 10

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
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        font = AppTextStyles.input
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        autocorrectionType = .no
        spellCheckingType = .no
        adjustsFontForContentSizeCategory = true
        applyPalette()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyPalette()
    }

    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    func applyLeftAccessoryView(_ accessoryView: UIView) {
        leftView = accessoryView
        leftViewMode = .always
        setNeedsLayout()
    }

    func applyRightAccessoryView(_ accessoryView: UIView) {
        rightView = accessoryView
        rightViewMode = .always
        setNeedsLayout()
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView else {
            return super.leftViewRect(forBounds: bounds)
        }
        return CGRect(
            x: contentInsets.left,
            y: (bounds.height - leftView.bounds.height) / 2,
            width: leftView.bounds.width,
            height: leftView.bounds.height
        )
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightView else {
            return super.rightViewRect(forBounds: bounds)
        }
        return CGRect(
            x: bounds.width - rightView.bounds.width - contentInsets.right,
            y: (bounds.height - rightView.bounds.height) / 2,
            width: rightView.bounds.width,
            height: rightView.bounds.height
        )
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        adjustedRect(for: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        adjustedRect(for: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        adjustedRect(for: bounds)
    }

    private func adjustedRect(for bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: contentInsets)

        if let leftView, leftViewMode != .never {
            rect.origin.x += leftView.bounds.width + accessorySpacing
            rect.size.width -= leftView.bounds.width + accessorySpacing
        }

        if let rightView, rightViewMode != .never {
            rect.size.width -= rightView.bounds.width + accessorySpacing
        }

        return rect
    }

    private func updatePlaceholder() {
        let placeholderText = placeholder ?? ""
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: AppColors.textTertiary,
                .font: AppTextStyles.input
            ]
        )
    }

    private func applyPalette() {
        backgroundColor = AppColors.inputBackground
        textColor = AppColors.textPrimary
        tintColor = AppColors.brandPrimary
        layer.borderColor = AppColors.border.cgColor
        updatePlaceholder()
    }
}
