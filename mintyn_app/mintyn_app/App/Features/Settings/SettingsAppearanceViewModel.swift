import Foundation

struct SettingsAppearanceState: Equatable {
    let options: [SettingsAppearanceOptionViewData]
}

struct SettingsAppearanceOptionViewData: Equatable {
    let appearance: AppAppearanceOption
    let isSelected: Bool
}

@MainActor
final class SettingsAppearanceViewModel {
    var onStateChange: ((SettingsAppearanceState) -> Void)?

    private let appearanceService: AppAppearanceServing

    init(appearanceService: AppAppearanceServing) {
        self.appearanceService = appearanceService
    }

    var currentState: SettingsAppearanceState {
        let selectedAppearance = appearanceService.currentAppearance
        return SettingsAppearanceState(
            options: AppAppearanceOption.allCases.map {
                SettingsAppearanceOptionViewData(
                    appearance: $0,
                    isSelected: $0 == selectedAppearance
                )
            }
        )
    }

    func load() {
        onStateChange?(currentState)
    }

    func selectAppearance(_ appearance: AppAppearanceOption) {
        appearanceService.saveAppearance(appearance)
        onStateChange?(currentState)
    }
}
