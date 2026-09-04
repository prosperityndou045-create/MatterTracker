//
//  SkillStatusBadge.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillStatusBadge: View {
    
    let status: SkillStatus
    
    var body: some View {
        
        HStack(spacing: 6) {
            
            Image(systemName: icon)
            
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(
            .horizontal,
            10
        )
        .padding(
            .vertical,
            6
        )
        .background(
            Color.secondary.opacity(0.1)
        )
        .clipShape(
            Capsule()
        )
    }
    
    private var icon: String {
        
        switch status {
            
        case .demonstrated:
            return "checkmark.circle.fill"
            
        case .inProgress:
            return "clock.fill"
            
        case .notStarted:
            return "circle"
        }
    }
}
