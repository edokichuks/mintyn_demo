import Foundation

protocol SettingsContentProviding {
    func fetchContent() async throws -> SettingsScreenContent?
}

enum SettingsContentProviderError: LocalizedError, Equatable {
    case unavailable

    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "Unable to load settings right now. Please try again."
        }
    }
}

final class SettingsContentProvider: SettingsContentProviding {
    func fetchContent() async throws -> SettingsScreenContent? {
        if AppLaunchArguments.shouldShowSettingsSlowLoad {
            try await Task.sleep(nanoseconds: 600_000_000)
        }

        if AppLaunchArguments.shouldShowSettingsError {
            throw SettingsContentProviderError.unavailable
        }

        if AppLaunchArguments.shouldShowSettingsEmpty {
            return nil
        }

        return SettingsScreenContent(
            sections: SettingsSectionID.allCases.map { SettingsSection(id: $0) }
        )
    }
}
