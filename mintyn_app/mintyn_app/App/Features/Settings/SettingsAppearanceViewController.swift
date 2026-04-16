import UIKit

final class SettingsAppearanceViewController: UIViewController {
    var onAppearanceSelected: ((AppAppearanceOption) -> Void)?

    private let viewModel: SettingsAppearanceViewModel
    private let rootScrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = AppLabel(
        style: AppTextStyles.settingsBodyNote,
        color: AppColors.textSecondary,
        alignment: .left,
        numberOfLines: 0
    )
    private let optionsStackView = UIStackView()

    init(viewModel: SettingsAppearanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        apply(state: viewModel.currentState)
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyNavigationAppearance(animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.settingsBackground
        view.accessibilityIdentifier = "settingsAppearanceScreen"
        title = "Appearance"
        navigationItem.largeTitleDisplayMode = .never

        rootScrollView.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.showsVerticalScrollIndicator = false

        contentView.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = "Choose how Mintyn should look. Your selection applies immediately and stays saved for the next launch."

        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.axis = .vertical
        optionsStackView.alignment = .fill
        optionsStackView.spacing = 0

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(optionsStackView)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            optionsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.apply(state: state)
        }
    }

    private func apply(state: SettingsAppearanceState) {
        optionsStackView.arrangedSubviews.forEach { subview in
            optionsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        for (index, option) in state.options.enumerated() {
            let rowView = SettingsRowView()
            rowView.configure(
                with: SettingsRowContent(
                    title: option.appearance.title,
                    subtitle: option.appearance.subtitle,
                    symbolName: nil,
                    titleFont: AppTextStyles.settingsRowTitle,
                    subtitleFont: AppTextStyles.settingsBodyNote,
                    titleColor: AppColors.textPrimary,
                    subtitleColor: AppColors.textSecondary,
                    iconTintColor: AppColors.settingsIconTint,
                    accessoryTintColor: AppColors.settingsChevronTint,
                    accessory: .checkmark(isSelected: option.isSelected),
                    showsSeparator: index != 0,
                    separatorLeadingInset: 16,
                    minimumHeight: option.isSelected ? 76 : 72,
                    accessibilityIdentifier: option.appearance.accessibilityIdentifier,
                    accessibilityValue: option.isSelected ? "Selected" : "Not selected"
                )
            )
            rowView.addTarget(self, action: #selector(appearanceOptionTapped(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(rowView)
        }
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

    @objc private func appearanceOptionTapped(_ sender: SettingsRowView) {
        guard let identifier = sender.accessibilityIdentifier else { return }
        let selectedOption = AppAppearanceOption.allCases.first { $0.accessibilityIdentifier == identifier }
        guard let selectedOption else { return }

        viewModel.selectAppearance(selectedOption)
        onAppearanceSelected?(selectedOption)
    }
}
