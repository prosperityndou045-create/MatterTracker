//
//  FacilitatorStudentDetailView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct FacilitatorStudentDetailView: View {
    let studentId: String
    
    @State private var portfolio: Portfolio?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if let portfolio = portfolio {
                    // Student Header
                    studentHeader(portfolio)
                    
                    // Stats
                    statsView(portfolio)
                    
                    // Technical Skills
                    if !portfolio.demonstratedSkills.isEmpty {
                        skillsSection(title: "Technical Skills", skills: portfolio.demonstratedSkills, color: .matterOrange)
                    }
                    
                    // Essential Skills
                    if !portfolio.essentialSkills.isEmpty {
                        skillsSection(title: "Essential Skills", skills: portfolio.essentialSkills, color: .matterNavy)
                    }
                    
                    // Evidence
                    if !portfolio.evidence.isEmpty {
                        evidenceSection(portfolio.evidence)
                    }
                    
                    // Projects
                    if !portfolio.projects.isEmpty {
                        projectsSection(portfolio.projects)
                    }
                    
                    // Achievements
                    if !portfolio.achievements.isEmpty {
                        achievementsSection(portfolio.achievements)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Student Details")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await loadStudentData()
        }
        .task {
            await loadStudentData()
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading student data...")
                .font(.headline)
                .foregroundColor(.matterNavy)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to Load Student",
            message: message,
            actionTitle: "Retry"
        ) {
            Task { await loadStudentData() }
        }
    }
    
    // MARK: - Content Components
    
    private func studentHeader(_ portfolio: Portfolio) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(portfolio.student.firstName) \(portfolio.student.lastName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    if let cohort = portfolio.student.cohort {
                        Text(cohort.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if let imageUrl = portfolio.student.profilePictureUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.matterOrange)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.matterOrange)
                }
            }
            
            if let bio = portfolio.student.bio, !bio.isEmpty {
                Text(bio)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func statsView(_ portfolio: Portfolio) -> some View {
        HStack(spacing: 12) {
            StatBadgeView(
                icon: "checkmark.circle.fill",
                value: "\(portfolio.demonstratedSkills.count)",
                label: "Technical"
            )
            
            StatBadgeView(
                icon: "heart.circle.fill",
                value: "\(portfolio.essentialSkills.count)",
                label: "Essential"
            )
            
            StatBadgeView(
                icon: "doc.circle.fill",
                value: "\(portfolio.evidence.count)",
                label: "Evidence"
            )
        }
    }
    
    private func skillsSection(title: String, skills: [SkillWithStatus], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            FlowLayout(spacing: 8) {
                ForEach(skills) { skill in
                    VStack(spacing: 2) {
                        Text(skill.name)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(color.opacity(0.12))
                            .foregroundColor(color)
                            .clipShape(Capsule())
                        
                        if let status = skill.status {
                            Text(status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func evidenceSection(_ evidence: [Evidence]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evidence")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(evidence) { item in
                EvidenceCardView(evidence: item)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func projectsSection(_ projects: [Project]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Projects")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(projects) { project in
                ProjectCardView(project: project)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func achievementsSection(_ achievements: [Achievement]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Achievements")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(achievements) { achievement in
                AchievementCardView(achievement: achievement)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadStudentData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            portfolio = try await ApiService.shared.facilitatorStudentPortfolio(studentId: studentId)
        } catch {
            errorMessage = error.localizedDescription
            portfolio = nil
        }
        
        isLoading = false
    }
}
