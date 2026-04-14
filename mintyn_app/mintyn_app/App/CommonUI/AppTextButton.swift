import UIKit

final class AppTextButton: UIButton {
    init(title: String, color: UIColor = AppColors.brandPrimary, font: UIFont = AppTextStyles.link) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(color.withAlphaComponent(0.55), for: .highlighted)
        setTitleColor(color.withAlphaComponent(0.45), for: .disabled)
        titleLabel?.font = font
        titleLabel?.adjustsFontForContentSizeCategory = true
        contentHorizontalAlignment = .leading
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
}
