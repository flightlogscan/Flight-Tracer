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
