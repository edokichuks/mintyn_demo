import UIKit

final class AppIconButton: UIButton {
    private let symbolConfiguration: UIImage.SymbolConfiguration
    private let normalTintColor: UIColor

    init(symbolName: String, pointSize: CGFloat = 18, weight: UIImage.SymbolWeight = .medium, tintColor: UIColor = AppColors.textSecondary) {
        self.symbolConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        self.normalTintColor = tintColor
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: symbolName, withConfiguration: symbolConfiguration), for: .normal)
        self.tintColor = tintColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.65 : 1.0
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
        }
    }

    func setSymbol(_ symbolName: String) {
        setImage(UIImage(systemName: symbolName, withConfiguration: symbolConfiguration), for: .normal)
    }

    func setTintColor(_ color: UIColor) {
        tintColor = color
    }

    func resetTintColor() {
        tintColor = normalTintColor
    }
}
