import UIKit

final class HomeViewController: UIViewController {
    var onLogoutRequested: (() -> Void)?

    private let iconView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                systemName: "checkmark.shield.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)
            )
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = AppColors.brandPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

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

    private let logoutButton = AppButton()

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

        titleLabel.text = "You are logged in"
        titleLabel.accessibilityIdentifier = "homeTitleLabel"

        messageLabel.text = "This is a placeholder authenticated screen for the Mintyn demo flow. Use Logout to return to the login experience."

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.accessibilityIdentifier = "homeLogoutButton"
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel, logoutButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Spacing.lg

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 72),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.lg),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.lg),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func logoutTapped() {
        onLogoutRequested?()
    }
}
