import UIKit

enum SettingsRowAccessory {
    case chevronRight
    case chevronDown
    case checkmark(isSelected: Bool)
    case none
}

struct SettingsRowContent {
    let title: String
    let subtitle: String?
    let symbolName: String?
    let titleFont: UIFont
    let subtitleFont: UIFont
    let titleColor: UIColor
    let subtitleColor: UIColor
    let iconTintColor: UIColor
    let accessoryTintColor: UIColor
    let accessory: SettingsRowAccessory
    let showsSeparator: Bool
    let separatorLeadingInset: CGFloat
    let minimumHeight: CGFloat
    let accessibilityIdentifier: String?
    let accessibilityValue: String?
}

final class SettingsRowView: UIControl {
    private let separatorView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = AppLabel(numberOfLines: 0)
    private let subtitleLabel = AppLabel(numberOfLines: 0)
    private let textStackView = UIStackView()
    private let accessoryImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let spacerView = UIView()
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var minimumHeightConstraint: NSLayoutConstraint?

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? AppColors.settingsPressedBackground : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: SettingsRowContent) {
        isAccessibilityElement = true
        accessibilityIdentifier = content.accessibilityIdentifier
        accessibilityLabel = content.title
        accessibilityValue = content.accessibilityValue
        accessibilityTraits = [.button]

        titleLabel.text = content.title
        titleLabel.font = content.titleFont
        titleLabel.textColor = content.titleColor

        subtitleLabel.text = content.subtitle
        subtitleLabel.font = content.subtitleFont
        subtitleLabel.textColor = content.subtitleColor
        subtitleLabel.isHidden = content.subtitle == nil

        if let symbolName = content.symbolName {
            iconImageView.image = UIImage(
                systemName: symbolName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            )
            iconImageView.tintColor = content.iconTintColor
            iconImageView.alpha = 1
        } else {
            iconImageView.image = nil
            iconImageView.alpha = 0
        }

        separatorView.isHidden = !content.showsSeparator
        separatorLeadingConstraint?.constant = content.separatorLeadingInset
        minimumHeightConstraint?.constant = content.minimumHeight

        switch content.accessory {
        case .chevronRight:
            accessoryImageView.image = UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            )
            accessoryImageView.tintColor = content.accessoryTintColor
            accessoryImageView.isHidden = false
        case .chevronDown:
            accessoryImageView.image = UIImage(
                systemName: "chevron.down",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            )
            accessoryImageView.tintColor = content.accessoryTintColor
            accessoryImageView.isHidden = false
        case .checkmark(let isSelected):
            accessoryImageView.image = UIImage(
                systemName: isSelected ? "checkmark.circle.fill" : "circle",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            )
            accessoryImageView.tintColor = isSelected ? AppColors.brandPrimary : content.accessoryTintColor
            accessoryImageView.isHidden = false
            if isSelected {
                accessibilityTraits.insert(.selected)
            }
        case .none:
            accessoryImageView.image = nil
            accessoryImageView.isHidden = true
        }
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = AppColors.settingsDivider
        separatorView.isUserInteractionEnabled = false

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconImageView.isUserInteractionEnabled = false

        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        accessoryImageView.isUserInteractionEnabled = false

        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.spacing = 4
        textStackView.isUserInteractionEnabled = false

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 18
        contentStackView.isUserInteractionEnabled = false

        titleLabel.isUserInteractionEnabled = false
        subtitleLabel.isUserInteractionEnabled = false
        spacerView.isUserInteractionEnabled = false

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(spacerView)
        contentStackView.addArrangedSubview(accessoryImageView)

        addSubview(separatorView)
        addSubview(contentStackView)

        separatorLeadingConstraint = separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        minimumHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        minimumHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorLeadingConstraint!,
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26),

            accessoryImageView.widthAnchor.constraint(equalToConstant: 20),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
