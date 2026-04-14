import UIKit

final class InfoPlaceholderViewController: UIViewController {
    private let titleText: String
    private let messageText: String
    private let symbolName: String

    private let iconView = UIImageView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.placeholderTitle,
        color: AppColors.textPrimary,
        alignment: .center,
        numberOfLines: 0
    )
    private let messageLabel = AppLabel(
        style: AppTextStyles.body,
        color: AppColors.textSecondary,
        alignment: .center,
        numberOfLines: 0
    )

    init(titleText: String, messageText: String, symbolName: String) {
        self.titleText = titleText
        self.messageText = messageText
        self.symbolName = symbolName
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationItem.largeTitleDisplayMode = .never
        title = titleText

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 42, weight: .semibold)
        )
        iconView.tintColor = AppColors.brandPrimary
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = titleText
        messageLabel.text = messageText

        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Spacing.lg

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.lg),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.lg),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
