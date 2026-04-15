import UIKit

final class HomeBalanceSummaryView: UIView {
    private let profileView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = AppLabel(style: AppTextStyles.homeHeaderName, color: AppColors.textPrimary)
    private let switchAccountButton = UIButton(type: .system)
    private let balanceLabel = AppLabel(
        style: AppTextStyles.homeBalance,
        color: AppColors.textPrimary,
        alignment: .center
    )
    private let eyeImageView = UIImageView()
    private let metadataLabel = AppLabel(
        style: AppTextStyles.homeBalanceMeta,
        color: AppColors.textSecondary,
        alignment: .center
    )
    private let addMoneyButton = DashboardActionButton(title: "Add Money", symbolName: "plus", style: .light)
    private let transferButton = DashboardActionButton(title: "Transfer", symbolName: "arrow.left.arrow.right", style: .brand)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        profileName: String,
        switchAccountTitle: String,
        balanceText: String,
        metadataText: String
    ) {
        nameLabel.text = profileName
        switchAccountButton.setTitle(switchAccountTitle, for: .normal)
        balanceLabel.text = balanceText
        metadataLabel.text = metadataText
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "homeBalanceSection"

        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.backgroundColor = AppColors.homeProfileBackground
        profileView.layer.cornerRadius = 18
        profileView.layer.cornerCurve = .continuous

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(
            systemName: "person.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        )
        profileImageView.tintColor = AppColors.homeProfileTint

        switchAccountButton.translatesAutoresizingMaskIntoConstraints = false
        switchAccountButton.backgroundColor = AppColors.homeCardBackground
        switchAccountButton.layer.cornerRadius = 18
        switchAccountButton.layer.cornerCurve = .continuous
        switchAccountButton.setTitleColor(AppColors.textPrimary, for: .normal)
        switchAccountButton.titleLabel?.font = AppTextStyles.homePill
        switchAccountButton.contentEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)

        eyeImageView.translatesAutoresizingMaskIntoConstraints = false
        eyeImageView.image = UIImage(
            systemName: "eye",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        )
        eyeImageView.tintColor = AppColors.brandPrimary

        let nameRow = UIStackView(arrangedSubviews: [profileView, nameLabel, UIView(), switchAccountButton])
        nameRow.translatesAutoresizingMaskIntoConstraints = false
        nameRow.axis = .horizontal
        nameRow.alignment = .center
        nameRow.spacing = 10

        let balanceRow = UIStackView(arrangedSubviews: [balanceLabel, eyeImageView])
        balanceRow.translatesAutoresizingMaskIntoConstraints = false
        balanceRow.axis = .horizontal
        balanceRow.alignment = .center
        balanceRow.spacing = 10

        let actionRow = UIStackView(arrangedSubviews: [addMoneyButton, transferButton])
        actionRow.translatesAutoresizingMaskIntoConstraints = false
        actionRow.axis = .horizontal
        actionRow.spacing = 12
        actionRow.distribution = .fillEqually

        let contentStackView = UIStackView(arrangedSubviews: [nameRow, balanceRow, metadataLabel, actionRow])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 18

        addSubview(contentStackView)
        profileView.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            profileView.widthAnchor.constraint(equalToConstant: 36),
            profileView.heightAnchor.constraint(equalToConstant: 36),
            profileImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
