//
//  WalkThrough.swift.
//  Matter Tracker.
//  Created by Prosperity on 4/9/2026.

import SwiftUI

struct WalkthroughView: View {
    
    let student: Student
    
    let skills = [
        
        Skill(
            name: "Communication",
            description: "Ability to communicate ideas clearly.",
            status: "Completed"
        ),
        
        Skill(
            name: "Teamwork",
            description: "Ability to work effectively with others.",
            status: "Completed"
        ),
        
        Skill(
            name: "Problem Solving",
            description: "Ability to identify and solve problems.",
            status: "In Progress"
        ),
        
        Skill(
            name: "Leadership",
            description: "Ability to guide and support others.",
            status: "Not Started"
        )
    ]
    
    
    var body: some View {
        
        List {
        
            Section {
                
                Text(student.name)
                    .font(.headline)
                
                Text("Review the student's skills and evidence.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        
            
            Section("Skills") {
                
                ForEach(skills) { skill in
                    
                    NavigationLink {
                        
                        EvidenceReviewView(skill: skill)
                        
                    } label: {
                        
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text(skill.name)
                                    .fontWeight(.semibold)
                                
                                Text(skill.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(skill.status)
                                    .font(.caption)
                                    .foregroundStyle(
                                        skill.status == "Completed"
                                        ? .green
                                        : .orange
                                    )
                            }
                            
                            Spacer()
                            
                            // Show a checkmark for completed skills.
                            // Otherwise show an arrow.
                            Image(
                                systemName:
                                    skill.status == "Completed"
                                    ? "checkmark.circle.fill"
                                    : "chevron.right"
                            )
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Walkthrough")
    }
}
