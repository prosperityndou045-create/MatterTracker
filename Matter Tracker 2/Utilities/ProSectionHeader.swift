//
//  ProSectionHeader.swift
//  Matter Tracker
//
//  Created by admin on 5/9/2026.
//
//  Shared visual primitives for cards, section headers, and state views.
//  All colors and effects reference the central Design System (Colors.swift).
//

import SwiftUI

// MARK: - Card View Modifiers

extension View {
    /// Standard elevated card treatment – used for dashboards, stats, and menu rows.
    func proCard(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.shadowLight, radius: 10, x: 0, y: 4)
    }

    /// Prominent card for primary/actionable surfaces (e.g., hero stats) – includes a subtle border.
    func proCardProminent(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color.shadowMedium, radius: 14, x: 0, y: 6)
    }
}

// MARK: - Section Header

/// Consistent section heading used above grouped content (e.g., "OVERVIEW", "QUICK ACTIONS").
struct ProSectionHeader: View {
    let title: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(Color.brandAccent)
            }
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.brandPrimary)
        }
    }
}

// MARK: - State View (Empty/Loading/Error)

/// Reusable empty/loading/error state block – ensures every "nothing to show" state looks identical.
struct ProStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 46))
                .foregroundStyle(Color.brandAccent.opacity(0.6))

            Text(title)
                .font(.headline)
                .foregroundStyle(Color.brandPrimary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.bordered)
                    .tint(Color.brandAccent)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .proCard()
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ProSectionHeader(title: "Overview", systemImage: "chart.pie")
        ProStateView(
            systemImage: "tray",
            title: "No Data",
            message: "Add your first entry to get started.",
            actionTitle: "Add",
            action: {}
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}
