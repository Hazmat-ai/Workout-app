import SwiftUI

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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static let ffBackground     = Color(hex: "#000000")
    static let ffSurface        = Color(hex: "#0A0A0A")
    static let ffCard           = Color(hex: "#111111")
    static let ffAccentBlue     = Color(hex: "#007AFF")
    static let ffAccentBlueMid  = Color(hex: "#0099DD")
    static let ffAccentBlueBright = Color(hex: "#00C3FF")
    static let ffTextPrimary    = Color.white
    static let ffTextSecondary  = Color(hex: "#8E8E93")
    static let ffSuccess        = Color(hex: "#30D158")
    static let ffDanger         = Color(hex: "#FF3B30")
    static let ffWarning        = Color(hex: "#FF9F0A")
}
