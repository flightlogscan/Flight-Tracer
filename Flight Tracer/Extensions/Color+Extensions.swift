import SwiftUI

// MARK: - Custom Colors
extension Color {
    /// A semi-transparent black color used throughout the app.
    static let semiTransparentBlack = Color.black.opacity(0.7)
        
    /// A navy blue color defined in the asset catalog.
    static let navyBlue = Color("NAVY_BLUE")
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let softgold = Color(red: 0.85, green: 0.65, blue: 0.13)
    static let warmgold = Color(red: 0.81, green: 0.71, blue: 0.23)
    static let deeppurple = Color(red: 0.4, green: 0.08, blue: 0.6)
    static let brightpurple = Color(red: 0.53, green: 0.18, blue: 0.85)
}

// Claude doin some weird color stuff lol
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
