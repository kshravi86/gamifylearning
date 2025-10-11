import SwiftUI

enum WaterTheme {
    static let tint: Color = Color.blue

    static let primary: Color = Color.blue
    static let secondary: Color = Color.cyan
    static let accent: Color = Color.indigo

    static func gradient(for scheme: ColorScheme) -> LinearGradient {
        switch scheme {
        case .light:
            return LinearGradient(
                colors: [Color.blue.opacity(0.25), Color.cyan.opacity(0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [Color.indigo.opacity(0.45), Color.blue.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    static func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(.ultraThinMaterial)
    }

    static func softStroke(corner: CGFloat = 16) -> some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
    }
}
