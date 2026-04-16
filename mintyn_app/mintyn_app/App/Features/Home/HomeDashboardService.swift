import Foundation

protocol HomeDashboardServiceProtocol {
    func fetchDashboard() async throws -> HomeDashboardViewData?
}

enum HomeDashboardServiceError: LocalizedError, Equatable {
    case networkUnavailable

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Unable to load your dashboard right now. Check your connection and try again."
        }
    }
}

final class HomeDashboardService: HomeDashboardServiceProtocol {
    private let delayNanoseconds: UInt64

    init(delayNanoseconds: UInt64 = AppLaunchArguments.isUITesting ? 150_000_000 : 900_000_000) {
        self.delayNanoseconds = delayNanoseconds
    }

    func fetchDashboard() async throws -> HomeDashboardViewData? {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }

        if AppLaunchArguments.shouldShowHomeDashboardError {
            throw HomeDashboardServiceError.networkUnavailable
        }

        if AppLaunchArguments.shouldShowHomeDashboardEmpty {
            return nil
        }

        return HomeDashboardViewData(
            profileName: "Edoki, Chukwuyem Edoki",
            switchAccountTitle: "Switch Account",
            balanceText: "₦0.00",
            accountMetadataText: "Individual · 1101336895 · Tier 2",
            updateAccountTitle: "Update Account",
            updateAccountMessage: "Update your account to get unlimited access to\nyour account",
            updateAccountButtonTitle: "Update now",
            promoTiles: [
                HomePromoTile(title: "Marketplace", symbolName: "cart.fill", style: .marketplace),
                HomePromoTile(title: "EasyCollect", symbolName: "banknote.fill", style: .easyCollect),
                HomePromoTile(title: "Business", symbolName: "briefcase.fill", style: .business)
            ],
            quickAccessItems: [
                HomeQuickAccessItem(title: "Remita", symbolName: "building.columns.fill", accessibilityIdentifier: "homeQuickAccessRemita"),
                HomeQuickAccessItem(title: "Airtime & Data", symbolName: "iphone.gen3", accessibilityIdentifier: "homeQuickAccessAirtime"),
                HomeQuickAccessItem(title: "Betting", symbolName: "sportscourt.fill", accessibilityIdentifier: "homeQuickAccessBetting"),
                HomeQuickAccessItem(title: "Business", symbolName: "briefcase.fill", accessibilityIdentifier: "homeQuickAccessBusiness"),
                HomeQuickAccessItem(title: "Card", symbolName: "creditcard.fill", accessibilityIdentifier: "homeQuickAccessCard"),
                HomeQuickAccessItem(title: "Gift Card", symbolName: "giftcard.fill", accessibilityIdentifier: "homeQuickAccessGiftCard"),
                HomeQuickAccessItem(title: "Other bills", symbolName: "bag.fill", accessibilityIdentifier: "homeQuickAccessOtherBills"),
                HomeQuickAccessItem(title: "Savings", symbolName: "arrow.trianglehead.clockwise", accessibilityIdentifier: "homeQuickAccessSavings")
            ],
            exploreItems: [
                HomeExploreItem(
                    title: "Mutual Investment",
                    subtitle: "Get up to 20% per annum ROI",
                    symbolName: "leaf.fill",
                    style: .investment
                ),
                HomeExploreItem(
                    title: "Marketplace",
                    subtitle: "Buy household food supplies at cheaper prices",
                    symbolName: "cart.fill",
                    style: .marketplace
                )
            ],
            transactions: []
        )
    }
}
