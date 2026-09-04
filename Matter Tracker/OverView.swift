//
//  OverView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct OverviewView: View {
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: Hero
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("SKILLS EVIDENCE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(2)
                    
                    Text("Show what you can actually demonstrate.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("""
                    A verified record of technical and essential
                    skills backed by real evidence.
                    """)
                    .foregroundStyle(.secondary)
                    
                    NavigationLink {
                        CandidateDirectoryView(
                            candidates: MockData.candidates
                        )
                    } label: {
                        
                        Text("Explore Candidates")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundStyle(
                                Color(.systemBackground)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                            )
                    }
                }
                
                Divider()
                
                // MARK: Evidence
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("WHY EVIDENCE MATTERS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                    
                    Text("Skills are stronger when they can be demonstrated.")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("""
                    Students connect their skills to real work,
                    challenges, projects, assessments, videos
                    and facilitator feedback.
                    """)
                    .foregroundStyle(.secondary)
                }
                
                // MARK: Evidence Types
                
                VStack(spacing: 12) {
                    
                    EvidenceTypeCard(
                        icon: "chevron.left.forwardslash.chevron.right",
                        title: "Code",
                        description: "Code samples and programming challenges."
                    )
                    
                    EvidenceTypeCard(
                        icon: "folder",
                        title: "Projects",
                        description: "Real applications and project work."
                    )
                    
                    EvidenceTypeCard(
                        icon: "play.rectangle",
                        title: "Videos",
                        description: "Presentations and demonstrations."
                    )
                    
                    EvidenceTypeCard(
                        icon: "checkmark.seal",
                        title: "Verification",
                        description: "Evidence reviewed by authorised reviewers."
                    )
                }
                
                Divider()
                
                // MARK: Guest Actions
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("EXPLORE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                    
                    NavigationLink {
//                        SkillsFrameworkView(
//                            groups: MockData.skillsFramework
//                        )
                    } label: {
                        
                        ActionRow(
                            icon: "list.bullet.rectangle",
                            title: "Skills Framework",
                            description: "Explore the skills tracked by MCRI."
                        )
                    }
                    
//                    NavigationLink {
//                        VerifyView()
//                    } label: {
                        
                        ActionRow(
                            icon: "checkmark.seal",
                            title: "Verify a Candidate",
                            description: "Check whether a candidate profile is authentic."
                        )
                    }
                }
            }
            .padding()
        }
//        .navigationTitle("Overview")
    }
//}

struct EvidenceTypeCard: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
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

struct ActionRow: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 35)
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
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
}
