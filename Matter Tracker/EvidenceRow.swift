//
//  EvidenceRow.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct EvidenceRow: View {
    
    let evidence: Evidence
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Evidence icon
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 35)
            
            // Evidence information
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(evidence.title)
                    .fontWeight(.semibold)
                
                Text(evidence.type.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Verification status
            if evidence.status == .verified {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            }
            
            // Navigation indicator
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
    
    // MARK: - Evidence Icon
    
    private var icon: String {
        switch evidence.type {
        case .codeSample:
            return "chevron.left.forwardslash.chevron.right"
            
        case .challenge:
            return "flag"
            
        case .github:
            return "folder"
            
        case .video:
            return "play.rectangle"
            
        case .project:
            return "hammer"
            
        case .feedback:
            return "text.bubble"
            
        case .assessment:
            return "doc.text"
        }
    }
}
