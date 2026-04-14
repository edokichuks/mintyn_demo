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
