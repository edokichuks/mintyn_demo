import UIKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

    private let rootScrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStackView = UIStackView()
    private let stateContainerView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let stateTitleLabel = AppLabel(
        style: AppTextStyles.placeholderTitle,
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

    private var renderedDashboard: HomeDashboardViewData?

    init(viewModel: HomeViewModel) {
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
        view.backgroundColor = AppColors.background
        view.accessibilityIdentifier = "homeScreen"

        rootScrollView.translatesAutoresizingMaskIntoConstraints = false
        rootScrollView.showsVerticalScrollIndicator = false
        rootScrollView.alwaysBounceVertical = true

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 24

        stateContainerView.translatesAutoresizingMaskIntoConstraints = false
        stateContainerView.isHidden = true

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = AppColors.brandPrimary
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.accessibilityIdentifier = "homeLoadingIndicator"

        retryButton.setTitle("Retry", for: .normal)
        retryButton.accessibilityIdentifier = "homeRetryButton"
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stateStackView = UIStackView(arrangedSubviews: [loadingIndicator, stateTitleLabel, stateMessageLabel, retryButton])
        stateStackView.translatesAutoresizingMaskIntoConstraints = false
        stateStackView.axis = .vertical
        stateStackView.alignment = .center
        stateStackView.spacing = 16

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
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

            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -148),

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

    private func apply(state: HomeViewState) {
        switch state {
        case .loading:
            renderedDashboard = nil
            showState(
                title: "Loading Home",
                message: "Fetching your dashboard details.",
                showsLoading: true,
                showsRetry: false,
                accessibilityIdentifier: "homeLoadingState"
            )
        case .empty:
            renderedDashboard = nil
            showState(
                title: "Screen not available",
                message: "This dashboard is empty right now. Pull to refresh is not enabled in the demo, so use retry when data becomes available.",
                showsLoading: false,
                showsRetry: false,
                accessibilityIdentifier: "homeEmptyState"
            )
        case .error(let message):
            renderedDashboard = nil
            showState(
                title: "Unable to Load Home",
                message: message,
                showsLoading: false,
                showsRetry: true,
                accessibilityIdentifier: "homeErrorState"
            )
        case .content(let dashboard):
            showContent(dashboard)
        }
    }

    private func showState(
        title: String,
        message: String,
        showsLoading: Bool,
        showsRetry: Bool,
        accessibilityIdentifier: String
    ) {
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

    private func showContent(_ dashboard: HomeDashboardViewData) {
        stateContainerView.isHidden = true
        loadingIndicator.stopAnimating()
        rootScrollView.isHidden = false

        guard dashboard != renderedDashboard else { return }
        renderedDashboard = dashboard

        contentStackView.arrangedSubviews.forEach { subview in
            contentStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        let headerView = HomeHeaderView()
        let balanceSummaryView = HomeBalanceSummaryView()
        balanceSummaryView.configure(
            profileName: dashboard.profileName,
            switchAccountTitle: dashboard.switchAccountTitle,
            balanceText: dashboard.balanceText,
            metadataText: dashboard.accountMetadataText
        )

        let updateAccountCardView = UpdateAccountCardView()
        updateAccountCardView.configure(
            title: dashboard.updateAccountTitle,
            message: dashboard.updateAccountMessage,
            buttonTitle: dashboard.updateAccountButtonTitle
        )

        let promoRow = UIStackView()
        promoRow.translatesAutoresizingMaskIntoConstraints = false
        promoRow.axis = .horizontal
        promoRow.spacing = 10
        promoRow.distribution = .fillEqually

        dashboard.promoTiles.forEach { promoRow.addArrangedSubview(PromoTileView(tile: $0)) }

        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(balanceSummaryView)
        contentStackView.addArrangedSubview(updateAccountCardView)
        contentStackView.addArrangedSubview(promoRow)
        contentStackView.addArrangedSubview(makeQuickAccessSection(items: dashboard.quickAccessItems))
        contentStackView.addArrangedSubview(makeExploreSection(items: dashboard.exploreItems))
        contentStackView.addArrangedSubview(makeRecentTransactionsSection(transactions: dashboard.transactions))
    }

    private func makeQuickAccessSection(items: [HomeQuickAccessItem]) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = "homeQuickAccessSection"

        let titleLabel = makeSectionLabel(text: "Quick Access")
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = AppColors.homeCardBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.cornerCurve = .continuous

        let rowsStackView = UIStackView()
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 16

        stride(from: 0, to: items.count, by: 4).forEach { startIndex in
            let rowStackView = UIStackView()
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            rowStackView.axis = .horizontal
            rowStackView.alignment = .top
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8

            let rowItems = Array(items[startIndex..<min(startIndex + 4, items.count)])
            rowItems.forEach { rowStackView.addArrangedSubview(CompactQuickAccessItemView(item: $0)) }
            rowsStackView.addArrangedSubview(rowStackView)
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(cardView)
        cardView.addSubview(rowsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            rowsStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            rowsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            rowsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            rowsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        return containerView
    }

    private func makeExploreSection(items: [HomeExploreItem]) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = "homeExploreSection"

        let titleLabel = makeSectionLabel(text: "Explore Mintyn")
        let cardsRow = UIStackView()
        cardsRow.translatesAutoresizingMaskIntoConstraints = false
        cardsRow.axis = .horizontal
        cardsRow.distribution = .fillEqually
        cardsRow.spacing = 8

        items.forEach {
            let cardView = ExploreCardView(item: $0)
            cardView.heightAnchor.constraint(equalToConstant: 172).isActive = true
            cardsRow.addArrangedSubview(cardView)
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(cardsRow)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            cardsRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            cardsRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardsRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cardsRow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    private func makeRecentTransactionsSection(transactions: [HomeTransactionItem]) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = "homeRecentTransactionsSection"

        let headerView = makeSectionHeader(
            title: "Recent Transactions",
            actionTitle: "See all"
        )

        let contentView: UIView
        if transactions.isEmpty {
            contentView = RecentTransactionsEmptyStateView()
        } else {
            contentView = makeTransactionsListView(transactions: transactions)
        }

        containerView.addSubview(headerView)
        containerView.addSubview(contentView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 14),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    private func makeTransactionsListView(transactions: [HomeTransactionItem]) -> UIView {
        let listContainerView = UIView()
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.backgroundColor = AppColors.homeCardBackground
        listContainerView.layer.cornerRadius = 18
        listContainerView.layer.cornerCurve = .continuous

        let listStackView = UIStackView()
        listStackView.translatesAutoresizingMaskIntoConstraints = false
        listStackView.axis = .vertical
        listStackView.spacing = 12

        transactions.forEach { transaction in
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false

            let titleLabel = AppLabel(style: AppTextStyles.body, color: AppColors.textPrimary)
            titleLabel.text = transaction.title

            let amountLabel = AppLabel(style: AppTextStyles.body, color: AppColors.textPrimary, alignment: .right)
            amountLabel.text = transaction.amountText

            rowView.addSubview(titleLabel)
            rowView.addSubview(amountLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),

                amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
                amountLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
                amountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])

            listStackView.addArrangedSubview(rowView)
        }

        listContainerView.addSubview(listStackView)

        NSLayoutConstraint.activate([
            listStackView.topAnchor.constraint(equalTo: listContainerView.topAnchor, constant: 16),
            listStackView.leadingAnchor.constraint(equalTo: listContainerView.leadingAnchor, constant: 16),
            listStackView.trailingAnchor.constraint(equalTo: listContainerView.trailingAnchor, constant: -16),
            listStackView.bottomAnchor.constraint(equalTo: listContainerView.bottomAnchor, constant: -16)
        ])

        return listContainerView
    }

    private func makeSectionLabel(text: String) -> UILabel {
        let label = AppLabel(style: AppTextStyles.homeSectionHeader, color: AppColors.textPrimary)
        label.text = text
        return label
    }

    private func makeSectionHeader(title: String, actionTitle: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = makeSectionLabel(text: title)

        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle(actionTitle, for: .normal)
        actionButton.setTitleColor(AppColors.brandPrimary, for: .normal)
        actionButton.titleLabel?.font = AppTextStyles.homeSmallAction
        actionButton.setImage(
            UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)),
            for: .normal
        )
        actionButton.tintColor = AppColors.brandPrimary
        actionButton.semanticContentAttribute = .forceRightToLeft

        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            actionButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])

        return containerView
    }

    @objc private func retryTapped() {
        viewModel.retry()
    }
}
