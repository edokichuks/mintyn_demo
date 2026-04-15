import UIKit

enum MainTab: String, CaseIterable {
    case home
    case invest
    case menu
    case transactions
    case settings

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .invest:
            return "Invest"
        case .menu:
            return "Menu"
        case .transactions:
            return "Transactions"
        case .settings:
            return "Settings"
        }
    }

    var symbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .invest:
            return "chart.bar.fill"
        case .menu:
            return "square.grid.2x2.fill"
        case .transactions:
            return "creditcard.fill"
        case .settings:
            return "gearshape.fill"
        }
    }

    var accessibilityIdentifier: String {
        "mainTab\(title.replacingOccurrences(of: " ", with: ""))Button"
    }

    var isFloatingCenterTab: Bool {
        self == .menu
    }

    static func fallback(from rawValue: String?) -> MainTab {
        guard let rawValue, let tab = MainTab(rawValue: rawValue) else {
            return .home
        }

        return tab
    }
}
