import Foundation

enum AppLaunchArguments {
    static let uiTesting = "--ui-testing"
    static let resetPersistedAuth = "--ui-testing-reset-auth"

    static var isUITesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains(uiTesting) || arguments.contains(resetPersistedAuth)
    }

    static var shouldResetPersistedAuth: Bool {
        ProcessInfo.processInfo.arguments.contains(resetPersistedAuth)
            || ProcessInfo.processInfo.arguments.contains(uiTesting)
    }
}
