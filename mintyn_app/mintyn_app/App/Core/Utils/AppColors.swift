import UIKit

enum AppColors {
    static let screenBackground = dynamic(light: "#F2F0EC", dark: "#050505")
    static let surfacePrimary = dynamic(light: "#FCFBF8", dark: "#1D1A1A")
    static let surfaceSecondary = dynamic(light: "#FFFFFF", dark: "#1D1A1A")
    static let inputBackground = dynamic(light: "#FFFFFF", dark: "#2A2727")
    static let border = dynamic(light: "#403B36", dark: "#3A3535")
    static let brandPrimary = dynamic(light: "#D2A23B", dark: "#D3AE53")
    static let brandPrimaryPressed = dynamic(light: "#C1912F", dark: "#C59F48")
    static let brandPrimaryDisabled = dynamic(light: "#DCC588", dark: "#806A35")
    static let textPrimary = dynamic(light: "#181514", dark: "#F8F6F2")
    static let textSecondary = dynamic(light: "#B0ADA7", dark: "#AAA39A")
    static let textTertiary = dynamic(light: "#C7C2BC", dark: "#8E867E")
    static let textOnBrand = dynamic(light: "#FFFDF7", dark: "#FFFDF7")
    static let error = dynamic(light: "#B84B4B", dark: "#E97171")
    static let errorBackground = dynamic(light: "#F7E5E5", dark: "#3A2020")
    static let success = dynamic(light: "#2F8756", dark: "#70D39A")
    static let successMuted = dynamic(light: "#DDEE7A", dark: "#9EDB72")
    static let indicatorInactive = dynamic(light: "#4C4742", dark: "#5B5651")
    static let iconTint = dynamic(light: "#C0902B", dark: "#C7A04A")
    static let iconSuccessTint = dynamic(light: "#53B63D", dark: "#8BE16A")
    static let separator = dynamic(light: "#E2DBD1", dark: "#2F2B2B")
    static let homeHeaderActionBackground = dynamic(light: "#EEEAE3", dark: "#161616")
    static let homeHeaderActionBorder = dynamic(light: "#E2DDD4", dark: "#252525")
    static let homeProfileBackground = dynamic(light: "#151515", dark: "#242220")
    static let homeProfileTint = dynamic(light: "#F4EFE7", dark: "#F4EFE7")
    static let homeCardBackground = dynamic(light: "#F6F4EF", dark: "#1F1D1D")
    static let homeCardSecondaryBackground = dynamic(light: "#FFFFFF", dark: "#242121")
    static let homeQuickAccessIconBackground = dynamic(light: "#D9D7D2", dark: "#42403D")
    static let homeQuickAccessIconTint = dynamic(light: "#5C5953", dark: "#F5F1EA")
    static let homeNavigationBackground = dynamic(light: "#FFFFFF", dark: "#202020")
    static let homeNavigationSelectedBackground = dynamic(light: "#EFEBE3", dark: "#3B3936")
    static let homeNavigationShadow = dynamic(light: "#1F1A15", dark: "#000000", alpha: 0.18)
    static let homeNavigationInactive = dynamic(light: "#1F1B17", dark: "#F7F3EC")
    static let homeUpdateCardStart = dynamic(light: "#84652A", dark: "#705726")
    static let homeUpdateCardEnd = dynamic(light: "#3A3734", dark: "#2C2927")
    static let homeMarketplaceBackground = dynamic(light: "#6250EF", dark: "#6250EF")
    static let homeEasyCollectBackground = dynamic(light: "#4AA469", dark: "#4AA469")
    static let homeBusinessBackground = dynamic(light: "#F34D68", dark: "#F34D68")
    static let homePromoText = dynamic(light: "#FFF8EE", dark: "#FFF8EE")
    static let homeExploreIllustrationBackground = dynamic(light: "#E7E0D0", dark: "#37312A")
    static let homeEmptyStateIcon = dynamic(light: "#7A756D", dark: "#6E6861")
    static let homeEmptyStateBackground = dynamic(light: "#F6F4EF", dark: "#1F1D1D")

    static let background = screenBackground
    static let surfaceLevel1 = surfacePrimary
    static let surfaceLevel2 = surfaceSecondary
    static let primary = brandPrimary
    static let textWhite = textPrimary
    static let textGray = textSecondary

    private static func dynamic(light: String, dark: String, alpha: CGFloat = 1.0) -> UIColor {
        UIColor { traitCollection in
            let resolvedHex = traitCollection.userInterfaceStyle == .dark ? dark : light
            return UIColor(hex: resolvedHex, alpha: alpha)
        }
    }
}
