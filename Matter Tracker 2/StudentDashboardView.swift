//
//  StudentDashboardView.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI

struct StudentDashboardView: View {
    @State private var currentUser: User?
    @State private var skills: [SkillWithStatus] = []
    @State private var evidence: [Evidence] = []
    @State private var weeklyReports: [WeeklyStatusEntry] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    
    // MARK: Derived data
    
    private var skillsDemonstratedCount: Int {
        skills.filter { $0.status == .demonstrated }.count
    }
    
    private var totalEvidenceCount: Int {
        evidence.count
    }
    
    private var pendingReviewCount: Int {
        evidence.filter { $0.status == .pending_review }.count
    }
    
    private var overallProgressPercent: Int {
        guard !skills.isEmpty else { return 0 }
        return Int((Double(skillsDemonstratedCount) / Double(skills.count)) * 100)
    }
    
    private var latestWeeklyReport: WeeklyStatusEntry? {
        weeklyReports.max(by: { $0.date < $1.date })
    }
    
    private var displayedSkills: [SkillWithStatus] {
        Array(skills.prefix(4))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.matterNavy.ignoresSafeArea()
                
                if isLoading && !isRefreshing {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            headerView
                            
                            // Stats Grid
                            statsGridView
                            
                            // Weekly Check-in
                            weeklyStatusView
                            
                            // Skills Evidence
                            skillsEvidenceView
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dashboard")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .refreshable {
                await refreshDashboard()
            }
            .task {
                await loadDashboard()
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading dashboard...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.matterOrange)
            Text("Unable to Load Dashboard")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Button {
                Task { await loadDashboard() }
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.matterOrange)
                    .cornerRadius(8)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 14) {
            // Avatar - Navigate to Profile
            if let userId = currentUser?.id {
                NavigationLink(destination: StudentProfileView(studentId: userId)) {
                    profileImage
                }
            } else {
                profileImage
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome back,")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                
                Text(currentUser?.firstName ?? "Student")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let cohort = currentUser?.cohort {
                    Text(cohort.name)
                        .font(.caption)
                        .foregroundColor(.matterOrange)
                }
            }
            
            Spacer()
        }
    }

    private var profileImage: some View {
        Group {
            if let profilePicture = currentUser?.profilePictureUrl,
               let url = URL(string: profilePicture) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.matterOrange)
                }
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.matterOrange, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 52))
                    .foregroundColor(.matterOrange)
                    .overlay(Circle().stroke(Color.matterOrange, lineWidth: 2))
            }
        }
    }
    
    // MARK: - Stats Grid
    
    private var statsGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            StatCard(icon: "graduationcap.fill", value: "\(skillsDemonstratedCount)", label: "Demonstrated", color: .green)
            StatCard(icon: "doc.text.fill", value: "\(totalEvidenceCount)", label: "Evidence", color: .blue)
            StatCard(icon: "clock.fill", value: "\(pendingReviewCount)", label: "Pending", color: pendingReviewCount > 0 ? .orange : .gray)
            StatCard(icon: "chart.line.uptrend.xyaxis", value: "\(overallProgressPercent)%", label: "Progress", color: .matterOrange)
        }
    }
    
    // MARK: - Weekly Check-in
    
    private var weeklyStatusView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Weekly Check-in")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: WeeklyStatusReportView()) {
                    Text("View All")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterOrange)
                }
            }
            
            NavigationLink(destination: WeeklyStatusReportView()) {
                HStack(spacing: 14) {
                    Image(systemName: "waveform")
                        .font(.title2)
                        .foregroundColor(.matterOrange)
                        .frame(width: 44, height: 44)
                        .background(Color.matterOrange.opacity(0.12))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if let latest = latestWeeklyReport {
                            Text("Last: \(latest.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.matterNavy)
                            Text("Score: \(latest.boldVoiceScore) • \(latest.book.shortName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("No check-ins yet")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.matterNavy)
                            Text("Tap to log your progress")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Skills Evidence
    
    private var skillsEvidenceView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Skills Evidence")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: SkillTrackerView()) {
                    Text("See All")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterOrange)
                }
            }
            
            if displayedSkills.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.3))
                    Text("No skills yet")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    NavigationLink(destination: SkillTrackerView()) {
                        Text("Add Your First Skill")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.matterOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.matterOrange.opacity(0.12))
                            .cornerRadius(6)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            } else {
                VStack(spacing: 8) {
                    ForEach(displayedSkills) { skill in
                        NavigationLink(destination: SkillDetailView(
                            skillId: skill.id,
                            skillName: skill.name,
                            skillCategory: skill.category ?? .technical
                        )) {
                            HStack(spacing: 12) {
                                Image(systemName: skill.category == .technical ? "chevron.left.forwardslash.chevron.right" : "person.fill.checkmark")
                                    .font(.headline)
                                    .foregroundColor(.matterOrange)
                                    .frame(width: 32)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(skill.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.matterNavy)
                                    Text(skill.description ?? "")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                if let status = skill.status {
                                    Text(status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(statusColor(status).opacity(0.12))
                                        .foregroundColor(statusColor(status))
                                        .cornerRadius(4)
                                }
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // Add skill button
            NavigationLink(destination: SkillTrackerView()) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Skill")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.matterOrange)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func statusColor(_ status: SkillStatus) -> Color {
        switch status {
        case .not_started: return .gray
        case .in_progress: return .blue
        case .pending_review: return .orange
        case .demonstrated: return .green
        case .needs_more_evidence: return .red
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await ApiService.shared.me()
            currentUser = user
            skills = try await ApiService.shared.studentSkills(studentId: user.id)
            evidence = try await ApiService.shared.studentEvidence(studentId: user.id)
            weeklyReports = try await ApiService.shared.getWeeklyReports()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshDashboard() async {
        isRefreshing = true
        await loadDashboard()
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
    }
}

// MARK: - Preview

#Preview {
    StudentDashboardView()
}
