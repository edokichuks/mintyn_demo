import Foundation

enum AppLaunchArguments {
    static let uiTesting = "--ui-testing"
    static let resetPersistedAuth = "--ui-testing-reset-auth"
    static let homeDashboardError = "--ui-testing-home-error"
    static let homeDashboardEmpty = "--ui-testing-home-empty"
    static let settingsError = "--ui-testing-settings-error"
    static let settingsEmpty = "--ui-testing-settings-empty"
    static let settingsSlowLoad = "--ui-testing-settings-slow"

    static var isUITesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains(uiTesting) || arguments.contains(resetPersistedAuth)
    }

    static var shouldResetPersistedAuth: Bool {
        ProcessInfo.processInfo.arguments.contains(resetPersistedAuth)
            || ProcessInfo.processInfo.arguments.contains(uiTesting)
    }

    static var shouldShowHomeDashboardError: Bool {
        ProcessInfo.processInfo.arguments.contains(homeDashboardError)
    }

    static var shouldShowHomeDashboardEmpty: Bool {
        ProcessInfo.processInfo.arguments.contains(homeDashboardEmpty)
    }

    static var shouldShowSettingsError: Bool {
        ProcessInfo.processInfo.arguments.contains(settingsError)
    }

    static var shouldShowSettingsEmpty: Bool {
        ProcessInfo.processInfo.arguments.contains(settingsEmpty)
    }

    static var shouldShowSettingsSlowLoad: Bool {
        ProcessInfo.processInfo.arguments.contains(settingsSlowLoad)
    }
}
