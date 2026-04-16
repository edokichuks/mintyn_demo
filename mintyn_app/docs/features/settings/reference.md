# Reference: Settings
> **Type:** Reference — information-oriented.

## Screens

| Screen | File |
|---|---|
| Settings root | `mintyn_app/App/Features/Settings/SettingsViewController.swift` |
| Settings detail placeholder | `mintyn_app/App/Features/Settings/SettingsDetailViewController.swift` |
| Appearance | `mintyn_app/App/Features/Settings/SettingsAppearanceViewController.swift` |

## ViewModels

| ViewModel | File |
|---|---|
| Settings root state | `mintyn_app/App/Features/Settings/SettingsViewModel.swift` |
| Appearance state | `mintyn_app/App/Features/Settings/SettingsAppearanceViewModel.swift` |

## Shared Feature Views

| View | File |
|---|---|
| Settings row | `mintyn_app/App/Features/Settings/Views/SettingsRowView.swift` |
| Settings section | `mintyn_app/App/Features/Settings/Views/SettingsSectionView.swift` |

## Core Services

| Service | File | Purpose |
|---|---|---|
| Appearance persistence | `mintyn_app/App/Core/Services/AppAppearanceService.swift` | Stores the selected interface style and applies it to the app window |

## Main Routes

| Trigger | Coordinator Action |
|---|---|
| Settings tab selected | Show `SettingsViewController` inside `MainTabsViewController` |
| Static row tapped | Push `SettingsDetailViewController` |
| `System > Appearance` tapped | Push `SettingsAppearanceViewController` |
| `Logout` tapped | Clear token and hand control back to `AppCoordinator` |

## Key AppColors Used
- `AppColors.settingsBackground`
- `AppColors.settingsIconTint`
- `AppColors.settingsChevronTint`
- `AppColors.settingsDivider`
- `AppColors.settingsPressedBackground`
- `AppColors.settingsDestructive`

## Key Text Styles Used
- `AppTextStyles.settingsScreenTitle`
- `AppTextStyles.settingsRowTitle`
- `AppTextStyles.settingsChildTitle`
- `AppTextStyles.settingsBodyNote`

## Accessibility Identifiers
- Root screen: `settingsScreen`
- Expandable headers: `settingsSectionProfile`, `settingsSectionHelpAndSupport`, `settingsSectionSystem`
- Logout: `settingsLogoutButton`
- Appearance options: `settingsAppearanceOptionSystem`, `settingsAppearanceOptionLight`, `settingsAppearanceOptionDark`
