//
//  StatusBadge.swift
//  Matter Tracker
//
//  Created by admin on 5/9/2026.
//
import SwiftUI

// MARK: - Status Badge

struct StatusBadge: View {
    let status: SkillStatus
    
    var body: some View {
        Text(status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor.opacity(0.15))
            .foregroundColor(statusColor)
            .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .not_started: return .gray
        case .in_progress: return .blue
        case .pending_review: return .orange
        case .demonstrated: return .green
        case .needs_more_evidence: return .red
        }
    }
}
