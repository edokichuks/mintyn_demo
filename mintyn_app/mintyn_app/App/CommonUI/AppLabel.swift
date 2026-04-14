import UIKit

final class AppLabel: UILabel {
    init(
        style: UIFont = AppTextStyles.body,
        color: UIColor = AppColors.textPrimary,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = style
        textColor = color
        textAlignment = alignment
        self.numberOfLines = numberOfLines
        adjustsFontForContentSizeCategory = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
