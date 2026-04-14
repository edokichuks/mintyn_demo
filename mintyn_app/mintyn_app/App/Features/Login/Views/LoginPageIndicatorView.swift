import UIKit

final class LoginPageIndicatorView: UIView {
    private let activeIndicator = UIView()
    private let inactiveIndicator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCurrentPage(_ page: Int) {
        if page == 0 {
            activeIndicator.backgroundColor = AppColors.brandPrimary
            inactiveIndicator.backgroundColor = AppColors.indicatorInactive
        } else {
            activeIndicator.backgroundColor = AppColors.indicatorInactive
            inactiveIndicator.backgroundColor = AppColors.brandPrimary
        }
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [activeIndicator, inactiveIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Spacing.sm

        [activeIndicator, inactiveIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 4
        }

        activeIndicator.backgroundColor = AppColors.brandPrimary
        inactiveIndicator.backgroundColor = AppColors.indicatorInactive

        addSubview(stackView)

        NSLayoutConstraint.activate([
            activeIndicator.widthAnchor.constraint(equalToConstant: 24),
            activeIndicator.heightAnchor.constraint(equalToConstant: 8),
            inactiveIndicator.widthAnchor.constraint(equalToConstant: 8),
            inactiveIndicator.heightAnchor.constraint(equalToConstant: 8),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
