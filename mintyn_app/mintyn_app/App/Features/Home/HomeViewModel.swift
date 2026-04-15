import Foundation

enum HomeViewState: Equatable {
    case loading
    case content(HomeDashboardViewData)
    case empty
    case error(message: String)
}

@MainActor
final class HomeViewModel {
    var onStateChange: ((HomeViewState) -> Void)?

    private let dashboardService: HomeDashboardServiceProtocol
    private(set) var currentState: HomeViewState = .loading
    private var loadTask: Task<Void, Never>?

    init(dashboardService: HomeDashboardServiceProtocol) {
        self.dashboardService = dashboardService
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
                let dashboard = try await dashboardService.fetchDashboard()
                guard !Task.isCancelled else { return }

                if let dashboard {
                    transition(to: .content(dashboard))
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

    private func transition(to state: HomeViewState) {
        currentState = state
        onStateChange?(state)
    }
}
