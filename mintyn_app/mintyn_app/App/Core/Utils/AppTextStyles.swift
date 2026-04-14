import UIKit

enum AppTextStyles {
    static let screenTitle = AppFonts.scaledFont(size: 18, weight: .medium, textStyle: .title2)
    static let sectionLabel = AppFonts.scaledFont(size: 16, weight: .regular, textStyle: .body)
    static let quickActionTitle = AppFonts.scaledFont(size: 15, weight: .regular, textStyle: .subheadline)
    static let fieldLabel = AppFonts.scaledFont(size: 16, weight: .regular, textStyle: .subheadline)
    static let input = AppFonts.scaledFont(size: 16, weight: .regular, textStyle: .body)
    static let body = AppFonts.scaledFont(size: 15, weight: .regular, textStyle: .body)
    static let button = AppFonts.scaledFont(size: 20, weight: .semibold, textStyle: .headline)
    static let link = AppFonts.scaledFont(size: 15, weight: .medium, textStyle: .subheadline)
    static let checkbox = AppFonts.scaledFont(size: 14, weight: .regular, textStyle: .subheadline)
    static let footnote = AppFonts.scaledFont(size: 12, weight: .regular, textStyle: .footnote)
    static let caption = AppFonts.scaledFont(size: 11, weight: .regular, textStyle: .caption1)
    static let placeholderTitle = AppFonts.scaledFont(size: 28, weight: .semibold, textStyle: .largeTitle)
    static let inlineError = AppFonts.scaledFont(size: 14, weight: .medium, textStyle: .footnote)
}
