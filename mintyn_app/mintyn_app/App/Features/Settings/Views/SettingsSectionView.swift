import UIKit

final class SettingsSectionView: UIView {
    var onHeaderTapped: (() -> Void)?
    var onChildTapped: ((SettingsChildID) -> Void)?

    private let stackView = UIStackView()
    private let headerRowView = SettingsRowView()
    private var childRows = [SettingsRowView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with section: SettingsSection) {
        let isDestructive = section.id.kind == .action
        let headerAccessory: SettingsRowAccessory
        switch section.id.kind {
        case .expandable:
            headerAccessory = section.isExpanded ? .chevronDown : .chevronRight
        case .navigation, .action:
            headerAccessory = .chevronRight
        }

        headerRowView.configure(
            with: SettingsRowContent(
                title: section.id.title,
                subtitle: nil,
                symbolName: section.id.symbolName,
                titleFont: AppTextStyles.settingsRowTitle,
                subtitleFont: AppTextStyles.settingsBodyNote,
                titleColor: isDestructive ? AppColors.settingsDestructive : AppColors.textPrimary,
                subtitleColor: AppColors.textSecondary,
                iconTintColor: isDestructive ? AppColors.settingsDestructive : AppColors.settingsIconTint,
                accessoryTintColor: isDestructive ? AppColors.settingsDestructive : AppColors.settingsChevronTint,
                accessory: headerAccessory,
                showsSeparator: section.id.showsSeparatorAbove,
                separatorLeadingInset: 16,
                minimumHeight: 74,
                accessibilityIdentifier: section.id.accessibilityIdentifier,
                accessibilityValue: section.id.kind == .expandable
                    ? (section.isExpanded ? "Expanded" : "Collapsed")
                    : nil
            )
        )

        childRows.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        childRows.removeAll()

        guard section.isExpanded else { return }

        for childItem in section.id.childItems {
            let rowView = SettingsRowView()
            rowView.configure(
                with: SettingsRowContent(
                    title: childItem.title,
                    subtitle: nil,
                    symbolName: nil,
                    titleFont: AppTextStyles.settingsChildTitle,
                    subtitleFont: AppTextStyles.settingsBodyNote,
                    titleColor: AppColors.textPrimary,
                    subtitleColor: AppColors.textSecondary,
                    iconTintColor: AppColors.settingsIconTint,
                    accessoryTintColor: AppColors.settingsChevronTint,
                    accessory: .chevronRight,
                    showsSeparator: true,
                    separatorLeadingInset: 16,
                    minimumHeight: 56,
                    accessibilityIdentifier: childItem.id.accessibilityIdentifier,
                    accessibilityValue: nil
                )
            )
            rowView.addTarget(self, action: #selector(childTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(rowView)
            childRows.append(rowView)
        }
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0

        addSubview(stackView)
        stackView.addArrangedSubview(headerRowView)
        headerRowView.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func headerTapped() {
        onHeaderTapped?()
    }

    @objc private func childTapped(_ sender: SettingsRowView) {
        guard let identifier = sender.accessibilityIdentifier else { return }

        let matchedChild = SettingsChildID.allCases.first { $0.accessibilityIdentifier == identifier }
        if let matchedChild {
            onChildTapped?(matchedChild)
        }
    }
}
