//
//  SkillFrameworkDetailView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillFrameworkDetailView: View {
    let entry: MockData.FrameworkEntry
    
    var body: some View {
        
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                Text(entry.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(entry.description)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Possible Evidence")
                    .font(.title2)
                    .fontWeight(.bold)
                
                EvidenceExample(
                    icon: "chevron.left.forwardslash.chevron.right",
                    title: "Code Sample"
                )
                
                EvidenceExample(
                    icon: "flag",
                    title: "LTC Challenge"
                )
                
                EvidenceExample(
                    icon: "folder",
                    title: "Project"
                )
                
                EvidenceExample(
                    icon: "play.rectangle",
                    title: "Video Demonstration"
                )
                
                EvidenceExample(
                    icon: "text.bubble",
                    title: "Facilitator Feedback"
                )
                
                EvidenceExample(
                    icon: "doc.text",
                    title: "Assessment"
                )
            }
            .padding()
        }
        .navigationTitle("Skill")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EvidenceExample: View {
    
    let icon: String
    let title: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: icon)
            
            Text(title)
            
            Spacer()
        }
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}
