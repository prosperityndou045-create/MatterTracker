//
//  OverView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct OverviewView: View {
    
    // Controls the "Why Evidence Matters" sheet
    @State private var showEvidenceInfo = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: - Hero
                
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
                
                // MARK: - Why Evidence Matters

                Button {
                    showEvidenceInfo = true
                } label: {
                    Text("WHY EVIDENCE MATTERS")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(Color.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                        )
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showEvidenceInfo) {
                    EvidenceInfoSheet()
                }
                
                // MARK: - Evidence Types
                
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
                
                
                // MARK: - Guest Actions
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("EXPLORE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                    
                    NavigationLink {
                        // Add your SkillsFrameworkView here later
                        //
                        // SkillsFrameworkView(
                        //     groups: MockData.skillsFramework
                        // )
                    } label: {
                        ActionRow(
                            icon: "list.bullet.rectangle",
                            title: "Skills Framework",
                            description: "Explore the skills tracked by MCRI."
                        )
                    }
                    
                    // Add your VerifyView here later
                    //
                    // NavigationLink {
                    //     VerifyView()
                    // } label: {
                    
                    ActionRow(
                        icon: "checkmark.seal",
                        title: "Verify a Candidate",
                        description: "Check whether a candidate profile is authentic."
                    )
                }
            }
            .padding()
        }
    }
}


// MARK: - Evidence Information Sheet

struct EvidenceInfoSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Header
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 42))
                        
                        Text("WHY EVIDENCE MATTERS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.5)
                        
                        Text("Skills are stronger when they can be demonstrated.")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("""
                        A skill is more meaningful when there is clear evidence showing how and where it was demonstrated.
                        """)
                        .foregroundStyle(.secondary)
                    }
                    
                    
                    Divider()
                    
                    
                    // MARK: Building a Skills Record
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("BUILDING A COMPLETE SKILLS RECORD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.2)
                        
                        Text("""
                        Students connect their skills to real work, challenges, projects, assessments, videos and facilitator feedback.
                        """)
                        
                        Text("""
                        This creates a clearer picture of what a student can actually do, rather than simply listing the skills they have learned.
                        """)
                        .foregroundStyle(.secondary)
                    }
                    
                    
                    // MARK: Evidence Examples
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text("WHAT COUNTS AS EVIDENCE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.2)
                        
                        EvidenceInfoRow(
                            icon: "chevron.left.forwardslash.chevron.right",
                            title: "Code",
                            description: "Programming work that demonstrates technical ability."
                        )
                        
                        EvidenceInfoRow(
                            icon: "folder.fill",
                            title: "Projects",
                            description: "Real applications, products and project work."
                        )
                        
                        EvidenceInfoRow(
                            icon: "play.rectangle.fill",
                            title: "Videos",
                            description: "Presentations, demonstrations and walkthroughs."
                        )
                        
                        EvidenceInfoRow(
                            icon: "doc.text.fill",
                            title: "Assessments",
                            description: "Completed assessments that demonstrate understanding."
                        )
                        
                        EvidenceInfoRow(
                            icon: "person.fill.checkmark",
                            title: "Facilitator Feedback",
                            description: "Feedback from authorised facilitators and reviewers."
                        )
                    }
                    
                    
                    // MARK: Why This Helps
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text("WHY THIS HELPS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.2)
                        
                        BenefitRow(
                            icon: "eye",
                            text: "Makes student skills easier to see and understand."
                        )
                        
                        BenefitRow(
                            icon: "chart.line.uptrend.xyaxis",
                            text: "Shows progress over time."
                        )
                        
                        BenefitRow(
                            icon: "person.crop.circle.badge.checkmark",
                            text: "Provides confidence that skills have actually been demonstrated."
                        )
                        
                        BenefitRow(
                            icon: "briefcase",
                            text: "Creates a stronger connection between learning and real-world work."
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Evidence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


// MARK: - Evidence Info Row

struct EvidenceInfoRow: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 14
        ) {
            
            Image(systemName: icon)
                .font(.title3)
                .frame(
                    width: 35,
                    height: 35
                )
                .background(
                    Color.secondary.opacity(0.12)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}


// MARK: - Benefit Row

struct BenefitRow: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            
            Image(systemName: icon)
                .font(.body)
                .frame(width: 25)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}


// MARK: - Evidence Type Card

struct EvidenceTypeCard: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40)
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
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


// MARK: - Action Row

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
