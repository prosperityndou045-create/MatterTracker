//
//  EvidenceReview.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//
import SwiftUI

struct EvidenceReviewView: View {

    let skill: Skill

    let evidence = [
        
        Evidence(
            title: "Communication Presentation",
            type: "PDF",
            description:
                "Student presentation demonstrating communication skills.",
            date: "02 September 2026"
        ),
        
        Evidence(
            title: "Team Project",
            type: "Image",
            description:
                "Evidence from a collaborative team project.",
            date: "01 September 2026"
        )
    ]
    
    
    var body: some View {
        
        List {
        
            Section("Selected Skill") {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(skill.name)
                        .font(.headline)
                    
                    Text(skill.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }
            
        
            
            Section("Submitted Evidence") {
                
                ForEach(evidence) { item in
                    
                
                    NavigationLink {
                        
                        AssessmentView(
                            skill: skill,
                            evidence: item
                        )
                        
                    } label: {
                        
                        HStack(spacing: 15) {
                           
                            Image(
                                systemName:
                                    item.type == "PDF"
                                    ? "doc.text.fill"
                                    : "photo.fill"
                            )
                            .font(.title2)
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text(item.title)
                                    .fontWeight(.semibold)
                                
                                Text(item.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(item.date)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Evidence Review")
    }
}
