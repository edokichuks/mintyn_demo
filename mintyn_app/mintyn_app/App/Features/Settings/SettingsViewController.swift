import UIKit

final class SettingsViewController: UIViewController {
    var onDestinationRequested: ((SettingsDestination) -> Void)?
    var onLogoutRequested: (() -> Void)?

    private let viewModel: SettingsViewModel

    private let rootScrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = AppLabel(
        style: AppTextStyles.settingsScreenTitle,
        color: AppColors.textPrimary,
        alignment: .center
    )
    private let sectionsStackView = UIStackView()
    private let stateContainerView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let stateTitleLabel = AppLabel(
        style: AppTextStyles.screenTitle,
        color: AppColors.textPrimary,
        alignment: .center,
        numberOfLines: 0
    )
    private let stateMessageLabel = AppLabel(
        style: AppTextStyles.body,
        color: AppColors.textSecondary,
        alignment: .center,
        numberOfLines: 0
    )
    private let retryButton = AppButton()

    private var hasRenderedContent = false

    init(viewModel: SettingsViewModel) {
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.settingsBackground
        view.accessibilityIdentifier = "settingsScreen"

        titleLabel.text = "Settings"

        rootScrollView.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.showsVerticalScrollIndicator = false
        rootScrollView.alwaysBounceVertical = true

        contentView.translatesAutoresizingMaskIntoConstraints = false

        sectionsStackView.translatesAutoresizingMaskIntoConstraints = false
        sectionsStackView.axis = .vertical
        sectionsStackView.alignment = .fill
        sectionsStackView.spacing = 0

        stateContainerView.translatesAutoresizingMaskIntoConstraints = false
        stateContainerView.isHidden = true

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = AppColors.brandPrimary
        loadingIndicator.hidesWhenStopped = true

        retryButton.setTitle("Retry", for: .normal)
        retryButton.accessibilityIdentifier = "settingsRetryButton"
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stateStackView = UIStackView(arrangedSubviews: [loadingIndicator, stateTitleLabel, stateMessageLabel, retryButton])
        stateStackView.translatesAutoresizingMaskIntoConstraints = false
        stateStackView.axis = .vertical
        stateStackView.alignment = .center
        stateStackView.spacing = 16

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sectionsStackView)
        view.addSubview(stateContainerView)
        stateContainerView.addSubview(stateStackView)

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

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            sectionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            sectionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sectionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sectionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),

            stateContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stateContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stateContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateStackView.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            stateStackView.centerYAnchor.constraint(equalTo: stateContainerView.centerYAnchor),
            stateStackView.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor),
            stateStackView.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.apply(state: state)
        }
    }

    private func apply(state: SettingsScreenState) {
        switch state {
        case .loading:
            showState(
                title: "Loading Settings",
                message: "Getting your available settings.",
                showsLoading: true,
                showsRetry: false,
                accessibilityIdentifier: "settingsLoadingState"
            )
        case .empty:
            showState(
                title: "No Settings Available",
                message: "There are no settings to show right now.",
                showsLoading: false,
                showsRetry: false,
                accessibilityIdentifier: "settingsEmptyState"
            )
        case .error(let message):
            showState(
                title: "Unable to Load Settings",
                message: message,
                showsLoading: false,
                showsRetry: true,
                accessibilityIdentifier: "settingsErrorState"
            )
        case .content(let content):
            showContent(content, animated: hasRenderedContent)
        }
    }

    private func showState(
        title: String,
        message: String,
        showsLoading: Bool,
        showsRetry: Bool,
        accessibilityIdentifier: String
    ) {
        hasRenderedContent = false
        rootScrollView.isHidden = true
        stateContainerView.isHidden = false
        stateContainerView.accessibilityIdentifier = accessibilityIdentifier
        stateTitleLabel.text = title
        stateMessageLabel.text = message
        retryButton.isHidden = !showsRetry

        if showsLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    private func showContent(_ content: SettingsScreenContent, animated: Bool) {
        rootScrollView.isHidden = false
        stateContainerView.isHidden = true
        loadingIndicator.stopAnimating()

        let renderContent = {
            self.sectionsStackView.arrangedSubviews.forEach { subview in
                self.sectionsStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }

            content.sections.forEach { section in
                let sectionView = SettingsSectionView()
                sectionView.configure(with: section)
                sectionView.onHeaderTapped = { [weak self] in
                    self?.handleHeaderTap(for: section.id)
                }
                sectionView.onChildTapped = { [weak self] childID in
                    self?.onDestinationRequested?(.child(childID))
                }
                self.sectionsStackView.addArrangedSubview(sectionView)
            }
        }

        if animated {
            UIView.transition(
                with: sectionsStackView,
                duration: 0.2,
                options: [.transitionCrossDissolve, .curveEaseInOut]
            ) {
                renderContent()
            }
        } else {
            renderContent()
        }

        hasRenderedContent = true
    }

    private func handleHeaderTap(for sectionID: SettingsSectionID) {
        switch sectionID.kind {
        case .expandable:
            viewModel.toggleSection(sectionID)
        case .navigation:
            onDestinationRequested?(.section(sectionID))
        case .action:
            onLogoutRequested?()
        }
    }

    @objc private func retryTapped() {
        viewModel.retry()
    }
}
