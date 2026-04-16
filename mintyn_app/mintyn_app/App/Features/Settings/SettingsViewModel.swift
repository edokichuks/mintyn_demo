import Foundation

@MainActor
final class SettingsViewModel {
    var onStateChange: ((SettingsScreenState) -> Void)?

    private let contentProvider: SettingsContentProviding
    private(set) var currentState: SettingsScreenState = .loading
    private var loadTask: Task<Void, Never>?

    init(contentProvider: SettingsContentProviding = SettingsContentProvider()) {
        self.contentProvider = contentProvider
    }

    deinit {
        loadTask?.cancel()
    }

    func load() {
        transition(to: .loading)

        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                let content = try await contentProvider.fetchContent()
                guard !Task.isCancelled else { return }

                if let content {
                    transition(to: .content(content))
                } else {
                    transition(to: .empty)
                }
            } catch let error as LocalizedError {
                guard !Task.isCancelled else { return }
                transition(to: .error(message: error.errorDescription ?? "Something went wrong. Please try again."))
            } catch {
                guard !Task.isCancelled else { return }
                transition(to: .error(message: "Something went wrong. Please try again."))
            }
        }
    }

    func retry() {
        load()
    }

    func toggleSection(_ sectionID: SettingsSectionID) {
        guard case .content(let content) = currentState else { return }
        transition(to: .content(content.toggledSection(withID: sectionID)))
    }

    private func transition(to state: SettingsScreenState) {
        currentState = state
        onStateChange?(state)
    }
}
