//
//  WalkthroughView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

// MARK: - Walkthrough View

struct WalkthroughView: View {
    let studentId: String
    
    @State private var student: User?
    @State private var portfolio: Portfolio?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        List {
            if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if let student = student, let portfolio = portfolio {
                // Student Information
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(student.firstName) \(student.lastName)")
                            .font(.headline)
                            .foregroundColor(.matterNavy)
                        
                        Text("Review the student's projects, skills and evidence.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                // Student Evidence
                Section("Student Evidence") {
                    // Projects
                    if !portfolio.projects.isEmpty {
                        NavigationLink {
                            StudentProjectsView(projects: portfolio.projects)
                        } label: {
                            WalkthroughRow(
                                title: "Projects",
                                description: "View \(portfolio.projects.count) projects created by the student.",
                                icon: "folder.fill"
                            )
                        }
                    }
                    
                    // Essential Skills
                    if !portfolio.essentialSkills.isEmpty {
                        NavigationLink {
                            EssentialSkillsView(
                                studentId: student.id,
                                skills: portfolio.essentialSkills
                            )
                        } label: {
                            WalkthroughRow(
                                title: "Essential Skills",
                                description: "Rate Communication, Teamwork, Problem Solving and Leadership.",
                                icon: "star.fill"
                            )
                        }
                    }
                    
                    // Evidence
                    if !portfolio.evidence.isEmpty {
                        NavigationLink {
                            StudentEvidenceListView(evidence: portfolio.evidence)
                        } label: {
                            WalkthroughRow(
                                title: "Evidence",
                                description: "View \(portfolio.evidence.count) evidence submissions.",
                                icon: "doc.text.fill"
                            )
                        }
                    }
                    
                    // Achievements
                    if !portfolio.achievements.isEmpty {
                        NavigationLink {
                            StudentAchievementsView(achievements: portfolio.achievements)
                        } label: {
                            WalkthroughRow(
                                title: "Achievements",
                                description: "View \(portfolio.achievements.count) achievements.",
                                icon: "star.circle.fill"
                            )
                        }
                    }
                }
            } else {
                emptyStateView
            }
        }
        .navigationTitle("Walkthrough")
        .refreshable {
            await loadData()
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                        .scaleEffect(1.2)
                    Text("Loading student data...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 40)
        }
        .listRowBackground(Color.clear)
    }
    
    private func errorView(_ message: String) -> some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.matterOrange)
                
                Text("Unable to Load Data")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task { await loadData() }
                }
                .buttonStyle(.bordered)
                .tint(.matterOrange)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    private var emptyStateView: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "person.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.matterOrange.opacity(0.6))
                
                Text("No Data Available")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("Unable to load student portfolio data.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let userTask = ApiService.shared.getUser(id: studentId)
            async let portfolioTask = ApiService.shared.facilitatorStudentPortfolio(studentId: studentId)
            
            let (loadedUser, loadedPortfolio) = try await (userTask, portfolioTask)
            student = loadedUser
            portfolio = loadedPortfolio
        } catch {
            errorMessage = error.localizedDescription
            student = nil
            portfolio = nil
        }
        
        isLoading = false
    }
}

// MARK: - Walkthrough Row

struct WalkthroughRow: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40)
                .foregroundColor(.matterOrange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Student Projects View

struct StudentProjectsView: View {
    let projects: [Project]
    
    var body: some View {
        List {
            Section("Student Projects") {
                ForEach(projects) { project in
                    NavigationLink {
                        ProjectDetailView(project: project)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(project.name)
                                .fontWeight(.semibold)
                                .foregroundColor(.matterNavy)
                            
                            if let description = project.description, !description.isEmpty {
                                Text(description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Projects")
    }
}

// MARK: - Project Detail View

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        List {
            Section("Project") {
                Text(project.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
                
                if let description = project.description {
                    Text(description)
                        .foregroundStyle(.secondary)
                }
                
                if let createdAt = project.createdAt {
                    Label("Created: \(createdAt.formatted(date: .abbreviated, time: .omitted))",
                          systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if let url = project.url, let urlObj = URL(string: url) {
                Section("Project Links") {
                    Link(destination: urlObj) {
                        HStack {
                            Image(systemName: "link.circle.fill")
                                .foregroundColor(.matterOrange)
                            Text("Open Project Link")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.up.forward.square")
                        }
                    }
                }
            }
        }
        .navigationTitle(project.name)
    }
}

// MARK: - Essential Skills View

struct EssentialSkillsView: View {
    let studentId: String
    let skills: [SkillWithStatus]
    
    @State private var ratings: [String: Int] = [:]
    @State private var isSubmitting = false
    @State private var showConfirmation = false
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Rate the student's essential skills from 1 to 5 stars.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }
            
            Section("Essential Skills") {
                ForEach(skills) { skill in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(skill.name)
                                .fontWeight(.semibold)
                                .foregroundColor(.matterNavy)
                            Spacer()
                            Text("\(ratings[skill.id] ?? 0)/5")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button {
                                    ratings[skill.id] = star
                                } label: {
                                    Image(systemName: star <= (ratings[skill.id] ?? 0) ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundStyle(star <= (ratings[skill.id] ?? 0) ? .yellow : .gray)
                                }
                                .buttonStyle(.plain)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            if !ratings.isEmpty {
                Section("Rating Summary") {
                    ForEach(skills) { skill in
                        HStack {
                            Text(skill.name)
                                .font(.subheadline)
                                .foregroundColor(.matterNavy)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= (ratings[skill.id] ?? 0) ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundStyle(star <= (ratings[skill.id] ?? 0) ? .yellow : .gray)
                                }
                            }
                        }
                    }
                }
            }
            
            Section {
                Button {
                    submitRatings()
                } label: {
                    if isSubmitting {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("Submitting...")
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit Ratings")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(ratings.isEmpty || isSubmitting)
                .buttonStyle(.borderedProminent)
                .tint(.matterOrange)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Essential Skills")
        .alert("Ratings Submitted", isPresented: $showConfirmation) {
            Button("OK") { }
        } message: {
            Text("Essential skills ratings have been submitted successfully.")
        }
    }
    
    private func submitRatings() {
        isSubmitting = true
        
        Task {
            for (skillId, rating) in ratings {
                if let skill = skills.first(where: { $0.id == skillId }) {
                    do {
                        _ = try await ApiService.shared.rateEssentialSkill(
                            studentId: studentId,
                            skillName: skill.name,
                            rating: rating
                        )
                    } catch {
                        print("Failed to submit rating for skill \(skill.name): \(error)")
                    }
                }
            }
            
            await MainActor.run {
                isSubmitting = false
                showConfirmation = true
                ratings.removeAll()
            }
        }
    }
}

// MARK: - Student Evidence List View

struct StudentEvidenceListView: View {
    let evidence: [Evidence]
    
    var body: some View {
        List {
            ForEach(evidence) { item in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.matterOrange)
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.matterNavy)
                        Spacer()
                        if item.verifiedByFacilitator == true {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    
                    if let description = item.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    HStack {
                        Label(item.type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized,
                              systemImage: "tag")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        if let submittedAt = item.submittedAt {
                            Spacer()
                            Label(submittedAt.formatted(date: .abbreviated, time: .omitted),
                                  systemImage: "calendar")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Evidence")
    }
}

// MARK: - Student Achievements View

struct StudentAchievementsView: View {
    let achievements: [Achievement]
    
    var body: some View {
        List {
            ForEach(achievements) { achievement in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.matterOrange)
                        Text(achievement.title)
                            .font(.headline)
                            .foregroundColor(.matterNavy)
                        Spacer()
                        if let dateAwarded = achievement.dateAwarded {
                            Text(dateAwarded.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if let description = achievement.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Achievements")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        WalkthroughView(studentId: "test-student-id")
    }
}
