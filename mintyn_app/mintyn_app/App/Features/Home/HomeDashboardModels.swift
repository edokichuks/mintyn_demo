import Foundation

struct HomeDashboardViewData: Equatable {
    let profileName: String
    let switchAccountTitle: String
    let balanceText: String
    let accountMetadataText: String
    let updateAccountTitle: String
    let updateAccountMessage: String
    let updateAccountButtonTitle: String
    let promoTiles: [HomePromoTile]
    let quickAccessItems: [HomeQuickAccessItem]
    let exploreItems: [HomeExploreItem]
    let transactions: [HomeTransactionItem]
}

struct HomeQuickAccessItem: Equatable {
    let title: String
    let symbolName: String
    let accessibilityIdentifier: String
}

struct HomePromoTile: Equatable {
    enum Style: String, Equatable {
        case marketplace
        case easyCollect
        case business
    }

    let title: String
    let symbolName: String
    let style: Style
}

struct HomeExploreItem: Equatable {
    enum IllustrationStyle: String, Equatable {
        case investment
        case marketplace
    }

    let title: String
    let subtitle: String
    let symbolName: String
    let style: IllustrationStyle
}

struct HomeTransactionItem: Equatable {
    let title: String
    let amountText: String
}
