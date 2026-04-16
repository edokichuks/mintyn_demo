# How-To: Settings
> **Type:** How-to Guides — task-oriented.

## How to add another expandable group
- Add the new case to `SettingsSectionID` in `mintyn_app/App/Features/Settings/SettingsModels.swift`.
- Return `.expandable` from `kind`.
- Add the child items in `childItems`.
- If needed, define accessibility identifiers for the new rows.
- The existing `SettingsViewModel` and `SettingsSectionView` will handle expansion without further structural changes.

## How to add a new tappable child destination
- Add the case to `SettingsChildID`.
- Add its title and accessibility identifier.
- Update `MainCoordinator.handleSettingsDestination(_:)` to route the new child.
- If the child should not use the generic placeholder, push a dedicated view controller from the coordinator.

## How to change the appearance options
- Update `AppAppearanceOption` in `mintyn_app/App/Core/Services/AppAppearanceService.swift`.
- Provide the new title, subtitle, and interface style mapping.
- `SettingsAppearanceViewModel` and `SettingsAppearanceViewController` will render the new option automatically if it is part of `allCases`.

## How to adjust the Settings visual styling
- Add or update tokens in `mintyn_app/App/Core/Utils/AppColors.swift`.
- Add typography tokens in `mintyn_app/App/Core/Utils/AppTextStyles.swift`.
- Keep all row visuals centralized through `SettingsRowView` instead of styling one screen directly.
