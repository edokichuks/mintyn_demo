import UIKit

final class LoginPageIndicatorView: UIView {
    private let stackView = UIStackView()
    private var indicatorViews = [UIView]()
    private var widthConstraints = [NSLayoutConstraint]()
    private var currentPage = 0
    private var pageCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        accessibilityTraits = .updatesFrequently
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(pageCount: Int) {
        guard pageCount > 0 else { return }

        self.pageCount = pageCount
        indicatorViews.forEach { $0.removeFromSuperview() }
        indicatorViews.removeAll()
        widthConstraints.removeAll()

        for _ in 0..<pageCount {
            let indicatorView = UIView()
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.layer.cornerRadius = 4

            let widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 8)
            widthConstraint.isActive = true
            widthConstraints.append(widthConstraint)
            NSLayoutConstraint.activate([
                indicatorView.heightAnchor.constraint(equalToConstant: 8)
            ])

            stackView.addArrangedSubview(indicatorView)
            indicatorViews.append(indicatorView)
        }

        currentPage = min(currentPage, pageCount - 1)
        setCurrentPage(currentPage, animated: false)
    }

    func setCurrentPage(_ page: Int, animated: Bool = true) {
        guard !indicatorViews.isEmpty else { return }

        currentPage = max(0, min(page, indicatorViews.count - 1))

        let changes = {
            for (index, indicatorView) in self.indicatorViews.enumerated() {
                let isActive = index == self.currentPage
                indicatorView.backgroundColor = isActive ? AppColors.brandPrimary : AppColors.indicatorInactive
                self.widthConstraints[index].constant = isActive ? 24 : 8
            }
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                changes()
            }
        } else {
            changes()
        }

        accessibilityValue = "Page \(currentPage + 1) of \(pageCount)"
    }

    private func setupUI() {
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
