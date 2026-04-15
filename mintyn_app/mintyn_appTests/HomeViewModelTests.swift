import XCTest
@testable import mintyn_app

@MainActor
final class HomeViewModelTests: XCTestCase {
    func test_load_transitionsFromLoadingToContent() async {
        let expectedDashboard = makeDashboard()
        let mockService = MockHomeDashboardService(results: [.success(expectedDashboard)])
        let sut = HomeViewModel(dashboardService: mockService)
        let contentExpectation = expectation(description: "Content state published")
        var observedStates = [HomeViewState]()

        sut.onStateChange = { state in
            observedStates.append(state)
            if state == .content(expectedDashboard) {
                contentExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [contentExpectation], timeout: 1)

        XCTAssertEqual(observedStates.first, .loading)
        XCTAssertEqual(observedStates.last, .content(expectedDashboard))
    }

    func test_load_transitionsFromLoadingToError() async {
        let mockService = MockHomeDashboardService(results: [.failure(HomeDashboardServiceError.networkUnavailable)])
        let sut = HomeViewModel(dashboardService: mockService)
        let errorExpectation = expectation(description: "Error state published")
        var observedStates = [HomeViewState]()

        sut.onStateChange = { state in
            observedStates.append(state)
            if state == .error(message: "Unable to load your dashboard right now. Check your connection and try again.") {
                errorExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [errorExpectation], timeout: 1)

        XCTAssertEqual(observedStates.first, .loading)
        XCTAssertEqual(
            observedStates.last,
            .error(message: "Unable to load your dashboard right now. Check your connection and try again.")
        )
    }

    func test_retry_afterFailureLoadsContent() async {
        let expectedDashboard = makeDashboard()
        let mockService = MockHomeDashboardService(
            results: [
                .failure(HomeDashboardServiceError.networkUnavailable),
                .success(expectedDashboard)
            ]
        )
        let sut = HomeViewModel(dashboardService: mockService)
        let successExpectation = expectation(description: "Content state published after retry")
        var errorCount = 0

        sut.onStateChange = { state in
            if case .error = state {
                errorCount += 1
                sut.retry()
            }

            if state == .content(expectedDashboard) {
                successExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [successExpectation], timeout: 1)

        XCTAssertEqual(errorCount, 1)
    }

    func test_load_withEmptyPayload_transitionsToEmptyState() async {
        let mockService = MockHomeDashboardService(results: [.success(nil)])
        let sut = HomeViewModel(dashboardService: mockService)
        let emptyExpectation = expectation(description: "Empty state published")

        sut.onStateChange = { state in
            if state == .empty {
                emptyExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [emptyExpectation], timeout: 1)

        XCTAssertEqual(sut.currentState, .empty)
    }

    private func makeDashboard() -> HomeDashboardViewData {
        HomeDashboardViewData(
            profileName: "Tester",
            switchAccountTitle: "Switch",
            balanceText: "₦10.00",
            accountMetadataText: "Individual · 1234567890 · Tier 2",
            updateAccountTitle: "Update Account",
            updateAccountMessage: "Update your account to continue.",
            updateAccountButtonTitle: "Update now",
            promoTiles: [],
            quickAccessItems: [],
            exploreItems: [],
            transactions: []
        )
    }
}

private final class MockHomeDashboardService: HomeDashboardServiceProtocol {
    private var results: [Result<HomeDashboardViewData?, Error>]

    init(results: [Result<HomeDashboardViewData?, Error>]) {
        self.results = results
    }

    func fetchDashboard() async throws -> HomeDashboardViewData? {
        guard !results.isEmpty else {
            return nil
        }

        let nextResult = results.removeFirst()
        switch nextResult {
        case .success(let dashboard):
            return dashboard
        case .failure(let error):
            throw error
        }
    }
}
