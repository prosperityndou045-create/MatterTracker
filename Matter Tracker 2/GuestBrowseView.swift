//
//  GuestBrowseView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct GuestBrowseView: View {
    
    // Controls the "Why Evidence Matters" sheet
    @State private var showEvidenceInfo = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var candidateCount = 0
    @State private var skillCount = 0
    @State private var featuredCandidates: [PublicCandidateSummary] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: - Hero
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("SKILLS EVIDENCE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(2)
                        .foregroundColor(.matterOrange)
                    
                    Text("Show what you can actually demonstrate.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    Text("""
                    A verified record of technical and essential
                    skills backed by real evidence.
                    """)
                    .foregroundStyle(.secondary)
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.2)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    
                    NavigationLink {
                        CandidateDirectoryView()
                    } label: {
                        Text("Explore Candidates (\(candidateCount))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.matterOrange)
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                            )
                    }
                    .disabled(featuredCandidates.isEmpty)
                }
                
                Divider()
                    .background(Color.matterNavy.opacity(0.2))
                
                // MARK: - Why Evidence Matters
                
                Button {
                    showEvidenceInfo = true
                } label: {
                    HStack {
                        Text("WHY EVIDENCE MATTERS")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "info.circle")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.matterNavy)
                    .foregroundStyle(.white)
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
                    .background(Color.matterNavy.opacity(0.2))
                
                // MARK: - Guest Actions
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("EXPLORE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.matterNavy)
                    
                    NavigationLink {
                        SkillsFrameworkView()
                    } label: {
                        ActionRow(
                            icon: "list.bullet.rectangle",
                            title: "Skills Framework (\(skillCount) skills)",
                            description: "Explore the skills tracked by MCRI."
                        )
                    }
                    
                    NavigationLink {
                        VerifyView()
                    } label: {
                        ActionRow(
                            icon: "checkmark.seal",
                            title: "Verify a Candidate",
                            description: "Check whether a candidate profile is authentic."
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .refreshable {
            await loadData()
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load featured candidates (first 3)
            let allCandidates = try await ApiService.shared.publicCandidates()
            featuredCandidates = Array(allCandidates.prefix(3))
            candidateCount = allCandidates.count
            
            // Load skills count
            let skills = try await ApiService.shared.listSkills()
            skillCount = skills.count
            
        } catch {
            errorMessage = error.localizedDescription
            // If API fails, show empty state
            featuredCandidates = []
            candidateCount = 0
            skillCount = 0
        }
        
        isLoading = false
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
                                .foregroundColor(.matterOrange)
                            
                            Text("WHY EVIDENCE MATTERS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.matterNavy)
                            
                            Text("Skills are stronger when they can be demonstrated.")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.matterNavy)
                            
                            Text("""
                        A skill is more meaningful when there is clear evidence showing how and where it was demonstrated.
                        """)
                            .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .background(Color.matterNavy.opacity(0.2))
                        
                        // MARK: Building a Skills Record
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("BUILDING A COMPLETE SKILLS RECORD")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1.2)
                                .foregroundColor(.matterNavy)
                            
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
                                .foregroundColor(.matterNavy)
                            
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
                                .foregroundColor(.matterNavy)
                            
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
                        .foregroundColor(.matterOrange)
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
                    .foregroundColor(.matterOrange)
                    .frame(
                        width: 35,
                        height: 35
                    )
                    .background(
                        Color.matterOrange.opacity(0.12)
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
                        .foregroundColor(.matterNavy)
                    
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
                    .foregroundColor(.matterOrange)
                    .frame(width: 25)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.matterNavy)
                
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
                    .foregroundColor(.matterOrange)
                    .frame(width: 40)
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterNavy)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                Color.matterNavy.opacity(0.05)
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
                    .foregroundColor(.matterOrange)
                    .frame(width: 35)
                
                VStack(alignment: .leading) {
                    
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterNavy)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.matterOrange)
            }
            .padding()
            .background(
                Color.matterNavy.opacity(0.05)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12
                )
            )
        }
    }
}
