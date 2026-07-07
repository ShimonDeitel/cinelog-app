import SwiftUI

enum Theme {
    static let background = Color(hex: "#140F1A")
    static let foreground = Color(hex: "#F1ECF6")
    static let accent = Color(hex: "#D4145A")
    static let accentSecondary = Color(hex: "#8FBC94")

    static var titleFont: Font { .system(.title2, design: .default).weight(.bold) }
    static var bodyFont: Font { .system(.body, design: .default) }
    static var captionFont: Font { .system(.caption, design: .default) }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
