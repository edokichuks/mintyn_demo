import UIKit

final class SettingsDetailViewController: UIViewController {
    private let titleText: String
    private let messageText: String
    private let symbolName: String

    private let iconImageView = UIImageView()
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
        applyNavigationAppearance(animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.settingsBackground
        view.accessibilityIdentifier = "settingsDetailScreen"
        navigationItem.largeTitleDisplayMode = .never
        title = titleText

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 42, weight: .regular)
        )
        iconImageView.tintColor = AppColors.brandPrimary
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = titleText
        messageLabel.text = messageText

        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, messageLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func applyNavigationAppearance(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.settingsBackground
        appearance.titleTextAttributes = [
            .foregroundColor: AppColors.textPrimary,
            .font: AppTextStyles.settingsScreenTitle
        ]

        navigationController?.navigationBar.tintColor = AppColors.brandPrimary
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
