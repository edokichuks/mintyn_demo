import UIKit
import XCTest
@testable import mintyn_app

@MainActor
final class SettingsViewModelTests: XCTestCase {
    func test_load_transitionsFromLoadingToContent() async {
        let expectedContent = makeContent()
        let provider = MockSettingsContentProvider(results: [.success(expectedContent)])
        let sut = SettingsViewModel(contentProvider: provider)
        let contentExpectation = expectation(description: "Content state published")
        var observedStates = [SettingsScreenState]()

        sut.onStateChange = { state in
            observedStates.append(state)
            if state == .content(expectedContent) {
                contentExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [contentExpectation], timeout: 1)

        XCTAssertEqual(observedStates.first, .loading)
        XCTAssertEqual(observedStates.last, .content(expectedContent))
    }

    func test_load_withEmptyPayload_transitionsToEmptyState() async {
        let provider = MockSettingsContentProvider(results: [.success(nil)])
        let sut = SettingsViewModel(contentProvider: provider)
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

    func test_load_withError_transitionsToErrorState() async {
        let provider = MockSettingsContentProvider(results: [.failure(SettingsContentProviderError.unavailable)])
        let sut = SettingsViewModel(contentProvider: provider)
        let errorExpectation = expectation(description: "Error state published")

        sut.onStateChange = { state in
            if state == .error(message: "Unable to load settings right now. Please try again.") {
                errorExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [errorExpectation], timeout: 1)

        XCTAssertEqual(
            sut.currentState,
            .error(message: "Unable to load settings right now. Please try again.")
        )
    }

    func test_toggleSection_expandsSelectedSectionAndCollapsesOthers() async {
        let expectedContent = makeContent()
        let provider = MockSettingsContentProvider(results: [.success(expectedContent)])
        let sut = SettingsViewModel(contentProvider: provider)
        let contentExpectation = expectation(description: "Initial content published")
        var didCaptureInitialContent = false

        sut.onStateChange = { state in
            if !didCaptureInitialContent, state == .content(expectedContent) {
                didCaptureInitialContent = true
                contentExpectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [contentExpectation], timeout: 1)

        sut.toggleSection(.profile)
        XCTAssertTrue(isSectionExpanded(.profile, in: sut.currentState))
        XCTAssertFalse(isSectionExpanded(.helpAndSupport, in: sut.currentState))

        sut.toggleSection(.helpAndSupport)
        XCTAssertFalse(isSectionExpanded(.profile, in: sut.currentState))
        XCTAssertTrue(isSectionExpanded(.helpAndSupport, in: sut.currentState))

        sut.toggleSection(.helpAndSupport)
        XCTAssertFalse(isSectionExpanded(.helpAndSupport, in: sut.currentState))
    }

    func test_appearanceViewModel_load_publishesPersistedSelection() {
        let appearanceService = MockAppearanceService(currentAppearance: .dark)
        let sut = SettingsAppearanceViewModel(appearanceService: appearanceService)
        var observedState: SettingsAppearanceState?

        sut.onStateChange = { observedState = $0 }
        sut.load()

        XCTAssertEqual(
            observedState?.options.first(where: { $0.appearance == .dark })?.isSelected,
            true
        )
        XCTAssertEqual(
            observedState?.options.first(where: { $0.appearance == .system })?.isSelected,
            false
        )
    }

    func test_appearanceViewModel_selectAppearance_updatesPersistedSelection() {
        let appearanceService = MockAppearanceService(currentAppearance: .system)
        let sut = SettingsAppearanceViewModel(appearanceService: appearanceService)
        var observedState: SettingsAppearanceState?

        sut.onStateChange = { observedState = $0 }
        sut.selectAppearance(.light)

        XCTAssertEqual(appearanceService.currentAppearance, .light)
        XCTAssertEqual(
            observedState?.options.first(where: { $0.appearance == .light })?.isSelected,
            true
        )
        XCTAssertEqual(
            observedState?.options.first(where: { $0.appearance == .system })?.isSelected,
            false
        )
    }

    private func makeContent() -> SettingsScreenContent {
        SettingsScreenContent(
            sections: SettingsSectionID.allCases.map { SettingsSection(id: $0) }
        )
    }

    private func isSectionExpanded(_ sectionID: SettingsSectionID, in state: SettingsScreenState) -> Bool {
        guard case .content(let content) = state else { return false }
        return content.sections.first(where: { $0.id == sectionID })?.isExpanded == true
    }
}

private final class MockSettingsContentProvider: SettingsContentProviding {
    private var results: [Result<SettingsScreenContent?, Error>]

    init(results: [Result<SettingsScreenContent?, Error>]) {
        self.results = results
    }

    func fetchContent() async throws -> SettingsScreenContent? {
        guard !results.isEmpty else {
            return nil
        }

        let nextResult = results.removeFirst()
        switch nextResult {
        case .success(let content):
            return content
        case .failure(let error):
            throw error
        }
    }
}

private final class MockAppearanceService: AppAppearanceServing {
    var currentAppearance: AppAppearanceOption

    init(currentAppearance: AppAppearanceOption) {
        self.currentAppearance = currentAppearance
    }

    func saveAppearance(_ appearance: AppAppearanceOption) {
        currentAppearance = appearance
    }

    func applyStoredAppearance(to window: UIWindow?) {}

    func apply(_ appearance: AppAppearanceOption, to window: UIWindow?) {
        currentAppearance = appearance
    }
}
