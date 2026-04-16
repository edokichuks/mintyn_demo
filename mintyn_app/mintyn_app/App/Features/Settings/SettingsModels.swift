import Foundation

enum SettingsScreenState: Equatable {
    case loading
    case content(SettingsScreenContent)
    case empty
    case error(message: String)
}

struct SettingsScreenContent: Equatable {
    let sections: [SettingsSection]

    func toggledSection(withID sectionID: SettingsSectionID) -> SettingsScreenContent {
        guard sectionID.kind == .expandable else { return self }

        let updatedSections = sections.map { section -> SettingsSection in
            guard section.id.kind == .expandable else { return section }
            guard section.id == sectionID else {
                return SettingsSection(id: section.id, isExpanded: false)
            }

            return SettingsSection(id: section.id, isExpanded: !section.isExpanded)
        }

        return SettingsScreenContent(sections: updatedSections)
    }
}

struct SettingsSection: Equatable {
    let id: SettingsSectionID
    let isExpanded: Bool

    init(id: SettingsSectionID, isExpanded: Bool = false) {
        self.id = id
        self.isExpanded = isExpanded
    }
}

enum SettingsSectionKind: Equatable {
    case navigation
    case expandable
    case action
}

enum SettingsSectionID: CaseIterable, Equatable {
    case profile
    case accountManagement
    case referrals
    case legal
    case helpAndSupport
    case system
    case createBusinessAccount
    case logout

    var title: String {
        switch self {
        case .profile:
            return "Profile"
        case .accountManagement:
            return "Account Management"
        case .referrals:
            return "Referrals"
        case .legal:
            return "Legal"
        case .helpAndSupport:
            return "Help and Support"
        case .system:
            return "System"
        case .createBusinessAccount:
            return "Create Business Account"
        case .logout:
            return "Logout"
        }
    }

    var symbolName: String? {
        switch self {
        case .profile:
            return "person.crop.circle"
        case .accountManagement:
            return "creditcard"
        case .referrals:
            return "megaphone"
        case .legal:
            return "shield"
        case .helpAndSupport:
            return "message.badge"
        case .system:
            return "iphone"
        case .createBusinessAccount:
            return "arrow.triangle.2.circlepath"
        case .logout:
            return "arrow.left.circle"
        }
    }

    var kind: SettingsSectionKind {
        switch self {
        case .profile, .helpAndSupport, .system:
            return .expandable
        case .logout:
            return .action
        case .accountManagement, .referrals, .legal, .createBusinessAccount:
            return .navigation
        }
    }

    var childItems: [SettingsChildItem] {
        switch self {
        case .profile:
            return [
                .init(id: .personalInformation),
                .init(id: .employmentInformation),
                .init(id: .identificationInformation),
                .init(id: .addressInformation),
                .init(id: .nextOfKin)
            ]
        case .helpAndSupport:
            return [
                .init(id: .frequentlyAskedQuestions),
                .init(id: .helpCenter),
                .init(id: .chatWithUs),
                .init(id: .rateUs),
                .init(id: .socialMedia),
                .init(id: .tellUsWhatYouWant)
            ]
        case .system:
            return [
                .init(id: .autoLogoff),
                .init(id: .appearance)
            ]
        case .accountManagement, .referrals, .legal, .createBusinessAccount, .logout:
            return []
        }
    }

    var showsSeparatorAbove: Bool {
        switch self {
        case .referrals, .legal, .helpAndSupport:
            return true
        case .profile, .accountManagement, .system, .createBusinessAccount, .logout:
            return false
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .profile:
            return "settingsSectionProfile"
        case .accountManagement:
            return "settingsSectionAccountManagement"
        case .referrals:
            return "settingsSectionReferrals"
        case .legal:
            return "settingsSectionLegal"
        case .helpAndSupport:
            return "settingsSectionHelpAndSupport"
        case .system:
            return "settingsSectionSystem"
        case .createBusinessAccount:
            return "settingsSectionCreateBusinessAccount"
        case .logout:
            return "settingsLogoutButton"
        }
    }
}

struct SettingsChildItem: Equatable {
    let id: SettingsChildID

    var title: String {
        id.title
    }
}

enum SettingsChildID: CaseIterable, Equatable {
    case personalInformation
    case employmentInformation
    case identificationInformation
    case addressInformation
    case nextOfKin
    case frequentlyAskedQuestions
    case helpCenter
    case chatWithUs
    case rateUs
    case socialMedia
    case tellUsWhatYouWant
    case autoLogoff
    case appearance

    var title: String {
        switch self {
        case .personalInformation:
            return "Personal Information"
        case .employmentInformation:
            return "Employment Information"
        case .identificationInformation:
            return "Identification Information"
        case .addressInformation:
            return "Address Information"
        case .nextOfKin:
            return "Next of Kin"
        case .frequentlyAskedQuestions:
            return "Frequently Asked Questions"
        case .helpCenter:
            return "Help Center"
        case .chatWithUs:
            return "Chat With Us"
        case .rateUs:
            return "Rate Us"
        case .socialMedia:
            return "Reach Us On Social Media"
        case .tellUsWhatYouWant:
            return "Tell Us What You Want"
        case .autoLogoff:
            return "Auto Logoff"
        case .appearance:
            return "Appearance"
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .personalInformation:
            return "settingsChildPersonalInformation"
        case .employmentInformation:
            return "settingsChildEmploymentInformation"
        case .identificationInformation:
            return "settingsChildIdentificationInformation"
        case .addressInformation:
            return "settingsChildAddressInformation"
        case .nextOfKin:
            return "settingsChildNextOfKin"
        case .frequentlyAskedQuestions:
            return "settingsChildFrequentlyAskedQuestions"
        case .helpCenter:
            return "settingsChildHelpCenter"
        case .chatWithUs:
            return "settingsChildChatWithUs"
        case .rateUs:
            return "settingsChildRateUs"
        case .socialMedia:
            return "settingsChildSocialMedia"
        case .tellUsWhatYouWant:
            return "settingsChildTellUsWhatYouWant"
        case .autoLogoff:
            return "settingsChildAutoLogoff"
        case .appearance:
            return "settingsChildAppearance"
        }
    }
}

enum SettingsDestination: Equatable {
    case section(SettingsSectionID)
    case child(SettingsChildID)
}
