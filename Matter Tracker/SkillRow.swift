//
//  SkillRow.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillRow: View {
    
    let skill: Skill
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            Image(
                systemName: skill.category == .technical
                ? "chevron.left.forwardslash.chevron.right"
                : "person.2"
            )
            .frame(width: 35)
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(skill.name)
                    .fontWeight(.semibold)
                
                Text(skill.status.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if skill.status == .demonstrated {
                
                Image(
                    systemName: "checkmark.circle.fill"
                )
                
            } else {
                
                Image(
                    systemName: "chevron.right"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
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
}
