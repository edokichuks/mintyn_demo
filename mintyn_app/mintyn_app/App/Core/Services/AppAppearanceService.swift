import Foundation
import UIKit

enum AppAppearanceOption: String, CaseIterable, Equatable {
    case system
    case light
    case dark

    var title: String {
        switch self {
        case .system:
            return "System Default"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var subtitle: String {
        switch self {
        case .system:
            return "Follow your device appearance."
        case .light:
            return "Keep Mintyn bright at all times."
        case .dark:
            return "Use the dark interface throughout the app."
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .system:
            return "settingsAppearanceOptionSystem"
        case .light:
            return "settingsAppearanceOptionLight"
        case .dark:
            return "settingsAppearanceOptionDark"
        }
    }
}

protocol AppAppearanceServing {
    var currentAppearance: AppAppearanceOption { get }
    func saveAppearance(_ appearance: AppAppearanceOption)
    func applyStoredAppearance(to window: UIWindow?)
    func apply(_ appearance: AppAppearanceOption, to window: UIWindow?)
}

final class AppAppearanceService: AppAppearanceServing {
    private enum Key: String {
        case selectedAppearance
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var currentAppearance: AppAppearanceOption {
        guard let rawValue = defaults.string(forKey: Key.selectedAppearance.rawValue),
              let appearance = AppAppearanceOption(rawValue: rawValue)
        else {
            return .system
        }

        return appearance
    }

    func saveAppearance(_ appearance: AppAppearanceOption) {
        defaults.set(appearance.rawValue, forKey: Key.selectedAppearance.rawValue)
    }

    func applyStoredAppearance(to window: UIWindow?) {
        apply(currentAppearance, to: window)
    }

    func apply(_ appearance: AppAppearanceOption, to window: UIWindow?) {
        saveAppearance(appearance)

        if let window {
            window.overrideUserInterfaceStyle = appearance.interfaceStyle
            return
        }

        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows }
            .flatMap { $0 }
            .forEach { $0.overrideUserInterfaceStyle = appearance.interfaceStyle }
    }
}
