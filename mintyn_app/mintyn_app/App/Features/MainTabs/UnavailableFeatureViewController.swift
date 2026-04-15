import UIKit

final class UnavailableFeatureViewController: UIViewController {
    var onActionRequested: (() -> Void)?

    private let featureTitle: String
    private let messageText: String
    private let symbolName: String
    private let actionTitle: String?
    private let actionAccessibilityIdentifier: String?

    private let contentContainerView = UIView()
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
    private let actionButton = AppButton()

    init(
        featureTitle: String,
        messageText: String,
        symbolName: String = "exclamationmark.circle",
        actionTitle: String? = nil,
        actionAccessibilityIdentifier: String? = nil
    ) {
        self.featureTitle = featureTitle
        self.messageText = messageText
        self.symbolName = symbolName
        self.actionTitle = actionTitle
        self.actionAccessibilityIdentifier = actionAccessibilityIdentifier
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.accessibilityIdentifier = "unavailable\(featureTitle.replacingOccurrences(of: " ", with: ""))Screen"

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 42, weight: .semibold)
        )
        iconImageView.tintColor = AppColors.brandPrimary

        titleLabel.text = featureTitle
        messageLabel.text = messageText

        actionButton.isHidden = actionTitle == nil
        if let actionTitle {
            actionButton.setTitle(actionTitle, for: .normal)
        }
        actionButton.accessibilityIdentifier = actionAccessibilityIdentifier
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, messageLabel, actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 18

        view.addSubview(contentContainerView)
        contentContainerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            contentContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            iconImageView.heightAnchor.constraint(equalToConstant: 84),
            stackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }

    @objc private func actionTapped() {
        onActionRequested?()
    }
}
