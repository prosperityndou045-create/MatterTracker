//
//  Colors.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

// MARK: - Hex Initializer
extension Color {
    /// Creates a Color from a hex string.
    /// - Parameter hex: A hex string like `"FF6825"` or `"#FF6825"`.
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

// MARK: - Design System Colors
extension Color {
    // MARK: Brand
    /// Primary brand color – deep navy.
    static let brandPrimary = Color(hex: "153A55")
    /// Brand accent – vibrant orange.
    static let brandAccent = Color(hex: "FF6825")
    /// Darker variant of the accent for pressed states.
    static let brandAccentDark = Color(hex: "CC4E12")

    // MARK: Text
    /// Primary text color – white.
    static let textPrimary = Color.white
    /// Secondary text – slightly transparent white.
    static let textSecondary = Color.white.opacity(0.8)
    /// Tertiary / placeholder text.
    static let textTertiary = Color.white.opacity(0.45)

    // MARK: Background & Surfaces
    /// Main app background – uses brand primary.
    static let backgroundPrimary = Color.brandPrimary
    /// Secondary background for cards or sheets.
    static let backgroundSecondary = Color.white.opacity(0.06)
    /// Card background with subtle transparency.
    static let cardBackground = Color.white.opacity(0.08)
    /// Card border stroke.
    static let cardBorder = Color.white.opacity(0.15)

    // MARK: Fields & Inputs
    /// Border for text fields.
    static let fieldBorder = Color.white.opacity(0.25)
    /// Background for text fields.
    static let fieldBackground = Color.white.opacity(0.06)

    // MARK: Status & Feedback
    static let success = Color.green
    static let warning = Color.yellow
    static let error   = Color.red
    static let info    = Color.blue

    // MARK: Dividers & Separators
    static let divider = Color.white.opacity(0.12)

    // MARK: Legacy Aliases
    // The screens across the app were written against these three names.
    // Keeping them as aliases to the brand tokens above means every screen
    // stays connected to one single source of truth for colour, without
    // having to touch 25+ view files individually.
    /// Alias for `brandPrimary` — used throughout the view layer.
    static let matterNavy = Color.brandPrimary
    /// Alias for `brandAccent` — used throughout the view layer.
    static let matterOrange = Color.brandAccent
    /// Alias for `brandAccentDark` — used for pressed/gradient states.
    static let matterOrangeDk = Color.brandAccentDark

    // MARK: Shadows & Overlays
    static let shadowLight = Color.black.opacity(0.08)
    static let shadowMedium = Color.black.opacity(0.15)
    static let overlayDark = Color.black.opacity(0.4)
}

// MARK: - Gradients
extension LinearGradient {
    /// Default brand gradient from navy to slightly lighter navy.
    static let brandGradient = LinearGradient(
        colors: [Color.brandPrimary, Color.brandPrimary.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Accent gradient (orange → dark orange).
    static let accentGradient = LinearGradient(
        colors: [Color.brandAccent, Color.brandAccentDark],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Subtle card gradient for depth.
    static let cardGradient = LinearGradient(
        colors: [Color.cardBackground, Color.cardBackground.opacity(0.4)],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Dynamic Color Support (Light/Dark Mode)
extension Color {
    /// Returns a color that adapts to the current user interface style.
    /// - Parameters:
    ///   - light: Color for light mode.
    ///   - dark: Color for dark mode.
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - Accessibility Helpers
extension Color {
    /// Returns a high-contrast version of the color (suitable for text on backgrounds).
    func accessibleContrast() -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // Simple luminance-based adjustment – can be refined.
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.5 ? Color.black : Color.white
    }
}

// MARK: - Design Tokens (Centralized Reference)
enum DesignTokens {
    enum Colors {
        static let primary = Color.brandPrimary
        static let accent = Color.brandAccent
        static let background = Color.backgroundPrimary
        static let text = Color.textPrimary
        // Add more tokens as needed.
    }
}

// MARK: - UIColor & CGColor Bridges (for UIKit compatibility)
extension Color {
    /// Convert to UIColor.
    var uiColor: UIColor { UIColor(self) }
    /// Convert to CGColor.
    var cgColor: CGColor { UIColor(self).cgColor }
}
