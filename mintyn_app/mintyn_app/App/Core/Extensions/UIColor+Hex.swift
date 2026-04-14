import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var intValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&intValue)

        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat

        switch hexString.count {
        case 3:
            red = CGFloat((intValue >> 8) & 0xF) / 15.0
            green = CGFloat((intValue >> 4) & 0xF) / 15.0
            blue = CGFloat(intValue & 0xF) / 15.0
        default:
            red = CGFloat((intValue >> 16) & 0xFF) / 255.0
            green = CGFloat((intValue >> 8) & 0xFF) / 255.0
            blue = CGFloat(intValue & 0xFF) / 255.0
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
