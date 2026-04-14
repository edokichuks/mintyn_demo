import UIKit

enum AppFonts {
    static func appFont(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }

    static func scaledFont(size: CGFloat, weight: UIFont.Weight = .regular, textStyle: UIFont.TextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: textStyle).scaledFont(for: appFont(size: size, weight: weight))
    }
}
