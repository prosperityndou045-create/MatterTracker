//
//  ManagerDashboardView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI

struct ManagerDashboardView: View {
    @State private var selectedCohortId = "all"
    @State private var cohorts: [Cohort] = []
    @State private var cohortAnalytics: [String: CohortAnalytics] = [:]
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var lastRefreshTime: Date?
    @State private var showingErrorAlert = false
    @State private var selectedStudentForDetail: User?
    @State private var showingStudentDetail = false

    // Quick Action sheets — these replace the old print()-only buttons with
    // real, functional flows backed by the API.
    @State private var showingAddStaff = false
    @State private var showingGrantAccess = false

    private var currentAnalytics: CohortAnalytics? {
        if selectedCohortId == "all" {
            return aggregatedAnalytics
        } else {
            return cohortAnalytics[selectedCohortId]
        }
    }

    /// Whether a single, real cohort is selected (as opposed to the
    /// synthetic "all" aggregate). Several actions — reviewing evidence,
    /// viewing reports — only make sense against one real cohort id, since
    /// the API has no cross-cohort equivalent of those endpoints.
    private var hasSpecificCohortSelected: Bool {
        selectedCohortId != "all"
    }

    private var aggregatedAnalytics: CohortAnalytics? {
        guard !cohortAnalytics.isEmpty else { return nil }

        let allStudents = cohortAnalytics.values.reduce(0) { $0 + $1.totalStudents }
        let allPending = cohortAnalytics.values.reduce(0) { $0 + $1.evidencePending }

        // Aggregate skills by combining and averaging
        var skillMap: [String: (name: String, total: Double, count: Int)] = [:]

        for analytics in cohortAnalytics.values {
            for skill in analytics.mostDemonstrated {
                let existing = skillMap[skill.id] ?? (name: skill.name, total: 0, count: 0)
                skillMap[skill.id] = (
                    name: skill.name,
                    total: existing.total + skill.percentDemonstrated,
                    count: existing.count + 1
                )
            }
        }

        let aggregatedSkills = skillMap.values.map { stat in
            SkillStat(
                skillId: UUID().uuidString,
                name: stat.name,
                percentDemonstrated: stat.total / Double(stat.count)
            )
        }.sorted { $0.percentDemonstrated > $1.percentDemonstrated }

        let topSkills = Array(aggregatedSkills.prefix(5))

        // Only take the bottom 5 as "gaps" if there are more than 5 skills
        // total — otherwise the same handful of skills would show up in
        // both the "most demonstrated" and "skill gaps" lists at once,
        // which reads as a bug rather than real data.
        let gapSkills: [SkillStat] = aggregatedSkills.count > topSkills.count
            ? Array(aggregatedSkills.suffix(5))
            : []

        return CohortAnalytics(
            cohortId: "all",
            totalStudents: allStudents,
            mostDemonstrated: topSkills,
            skillGaps: gapSkills,
            evidencePending: allPending
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    if isLoading && !isRefreshing {
                        loadingView
                    } else if let error = errorMessage, !isRefreshing {
                        errorView(error)
                    } else {
                        // MARK: - Header
                        headerView

                        // MARK: - Cohort Selection
                        cohortSelectionView

                        // MARK: - Overview
                        if let analytics = currentAnalytics {
                            overviewView(analytics)
                        }

                        // MARK: - Quick Actions
                        quickActionsView

                        // MARK: - Cohort Management
                        cohortManagementView

                        // MARK: - Reports & Insights
                        reportsAndInsightsView

                        // MARK: - Recent Activity
                        if let analytics = currentAnalytics {
                            recentActivityView(analytics)
                        }

                        // MARK: - Last Updated
                        lastUpdatedView
                    }
                }
                .padding()
            }
            .refreshable {
                await refreshDashboard()
            }
            .task {
                if cohorts.isEmpty {
                    await loadDashboard()
                }
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .sheet(isPresented: $showingStudentDetail) {
                if let student = selectedStudentForDetail {
                    StudentDetailSheet(student: student)
                }
            }
            .sheet(isPresented: $showingAddStaff) {
                AddStaffSheet {
                    Task { await refreshDashboard() }
                }
            }
            .sheet(isPresented: $showingGrantAccess) {
                GrantExternalAccessSheet(
                    cohortId: hasSpecificCohortSelected ? selectedCohortId : nil
                )
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
                .foregroundColor(.matterNavy)
            Text("Fetching cohort data and analytics")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func errorView(_ error: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to Load Dashboard",
            message: error,
            actionTitle: "Retry"
        ) {
            Task { await loadDashboard() }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Manager")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)

                Spacer()

                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                        .scaleEffect(0.8)
                }
            }

            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)

            Text("Monitor student progress and program insights")
                .foregroundStyle(.secondary)
        }
    }

    private var cohortSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Cohort")
                .font(.headline)
                .foregroundColor(.matterNavy)

            Picker("Cohort", selection: $selectedCohortId) {
                Text("All Cohorts")
                    .tag("all")

                ForEach(cohorts) { cohort in
                    Text(cohort.name)
                        .tag(cohort.id)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .proCard()
            .tint(.matterOrange)
            .onChange(of: selectedCohortId) { _ in
                if !isLoading {
                    Task { await refreshDashboard() }
                }
            }
        }
    }

    private func overviewView(_ analytics: CohortAnalytics) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ProSectionHeader(title: "Overview")

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ManagerStatCard(
                    title: "Students",
                    value: "\(analytics.totalStudents)",
                    icon: "person.3.fill",
                    subtitle: "Active learners"
                )

                ManagerStatCard(
                    title: "Skills",
                    value: "\(analytics.mostDemonstrated.count + analytics.skillGaps.count)",
                    icon: "checklist",
                    subtitle: "Total tracked"
                )

                ManagerStatCard(
                    title: "Demonstrated",
                    value: "\(analytics.mostDemonstrated.count)",
                    icon: "checkmark.seal.fill",
                    subtitle: "Skills achieved"
                )

                ManagerStatCard(
                    title: "Pending Reviews",
                    value: "\(analytics.evidencePending)",
                    icon: "clock.fill",
                    subtitle: "Awaiting review",
                    color: analytics.evidencePending > 10 ? .orange : .matterOrange
                )
            }
        }
    }

    /// Every action here now does something real:
    ///  - Add Staff opens a form that calls POST /users (provision a
    ///    facilitator/manager/external reviewer account)
    ///  - Grant Access opens a form that calls POST /manager/external-access
    ///  - Review Evidence / View Reports navigate to the real screens for
    ///    the selected cohort, and are disabled when "All Cohorts" is
    ///    selected since neither endpoint has a cross-cohort equivalent
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProSectionHeader(title: "Quick Actions")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    QuickActionButton(
                        icon: "person.badge.plus",
                        title: "Add Staff",
                        color: .blue
                    ) {
                        showingAddStaff = true
                    }

                    QuickActionButton(
                        icon: "person.crop.circle.badge.checkmark",
                        title: "Grant Access",
                        color: .purple
                    ) {
                        showingGrantAccess = true
                    }

                    NavigationLink {
                        ManagerEvidenceView(selectedCohortId: selectedCohortId)
                    } label: {
                        QuickActionButtonContent(
                            icon: "checkmark.circle.badge.checkmark",
                            title: "Review Evidence",
                            color: .orange
                        )
                    }
                    .disabled(!hasSpecificCohortSelected)
                    .opacity(hasSpecificCohortSelected ? 1 : 0.4)

                    NavigationLink {
                        ManagerReportsView(selectedCohortId: selectedCohortId)
                    } label: {
                        QuickActionButtonContent(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "View Reports",
                            color: .green
                        )
                    }
                    .disabled(!hasSpecificCohortSelected)
                    .opacity(hasSpecificCohortSelected ? 1 : 0.4)
                }
            }

            if !hasSpecificCohortSelected {
                Text("Select a specific cohort above to review evidence or view reports.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var cohortManagementView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProSectionHeader(title: "Cohort Management")

            if hasSpecificCohortSelected {
                NavigationLink {
                    ManagerStudentsView(selectedCohortId: selectedCohortId)
                } label: {
                    ManagerMenuCard(
                        icon: "person.2.fill",
                        title: "View Students",
                        description: "View students and their progress",
                        badge: currentAnalytics.map { "\($0.totalStudents)" } ?? "0"
                    )
                }

                NavigationLink {
                    ManagerSkillsView(selectedCohortId: selectedCohortId)
                } label: {
                    ManagerMenuCard(
                        icon: "chart.bar.fill",
                        title: "Skills Data",
                        description: "View the most and least demonstrated skills",
                        badge: currentAnalytics.map { "\($0.mostDemonstrated.count + $0.skillGaps.count)" } ?? "0"
                    )
                }

                NavigationLink {
                    ManagerEvidenceView(selectedCohortId: selectedCohortId)
                } label: {
                    ManagerMenuCard(
                        icon: "doc.text.fill",
                        title: "Evidence Data",
                        description: "View submitted evidence and pending reviews",
                        badge: currentAnalytics.map { "\($0.evidencePending)" } ?? "0",
                        badgeColor: (currentAnalytics?.evidencePending ?? 0) > 10 ? .orange : .matterOrange
                    )
                }
            } else {
                ManagerMenuCard(
                    icon: "info.circle",
                    title: "Select a Specific Cohort",
                    description: "Choose a cohort above to view detailed data"
                )
                .opacity(0.6)
            }
        }
    }

    private var reportsAndInsightsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProSectionHeader(title: "Reports & Insights")

            if hasSpecificCohortSelected {
                NavigationLink {
                    ManagerReportsView(selectedCohortId: selectedCohortId)
                } label: {
                    ManagerMenuCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Generate Reports",
                        description: "View cohort progress and performance reports"
                    )
                }

                NavigationLink {
                    ManagerInsightsView(selectedCohortId: selectedCohortId)
                } label: {
                    ManagerMenuCard(
                        icon: "lightbulb.fill",
                        title: "Program Insights",
                        description: "Identify trends and areas that need attention"
                    )
                }
            } else {
                ManagerMenuCard(
                    icon: "info.circle",
                    title: "Select a Specific Cohort",
                    description: "Choose a cohort above to view reports and insights"
                )
                .opacity(0.6)
            }
        }
    }

    private func recentActivityView(_ analytics: CohortAnalytics) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ProSectionHeader(title: "Recent Activity")

            if analytics.evidencePending > 0 {
                ActivityCard(
                    icon: "clock.fill",
                    title: "Pending Reviews",
                    description: "\(analytics.evidencePending) evidence submissions need your review",
                    color: .orange
                )
            }

            if !analytics.skillGaps.isEmpty {
                ActivityCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "Skill Gaps Detected",
                    description: "\(analytics.skillGaps.count) skills need attention in this cohort",
                    color: .red
                )
            }

            if analytics.mostDemonstrated.count > 0 {
                ActivityCard(
                    icon: "checkmark.circle.fill",
                    title: "Skills Demonstrated",
                    description: "\(analytics.mostDemonstrated.count) skills have been demonstrated",
                    color: .green
                )
            }

            if analytics.evidencePending == 0 && analytics.skillGaps.isEmpty && analytics.mostDemonstrated.isEmpty {
                Text("No recent activity to show yet.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var lastUpdatedView: some View {
        VStack(spacing: 8) {
            Divider()
                .background(Color.matterNavy.opacity(0.2))

            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(.caption)
                    .foregroundColor(.matterOrange)

                Text("Last updated: \(lastRefreshTime?.formatted(date: .abbreviated, time: .shortened) ?? "Never")")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    Task { await refreshDashboard() }
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.matterOrange)
                }
                .disabled(isRefreshing)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Data Loading

    @MainActor
    private func loadDashboard() async {
        isLoading = true
        errorMessage = nil

        do {
            cohorts = try await ApiService.shared.listCohorts()
            await loadAllCohortAnalytics()

            if selectedCohortId == "all" && !cohorts.isEmpty {
                selectedCohortId = cohorts.first?.id ?? "all"
            }

            lastRefreshTime = Date()

        } catch {
            errorMessage = error.localizedDescription
            showingErrorAlert = true
            cohorts = []
            cohortAnalytics = [:]
        }

        isLoading = false
        isRefreshing = false
    }

    @MainActor
    private func refreshDashboard() async {
        isRefreshing = true
        errorMessage = nil

        do {
            cohorts = try await ApiService.shared.listCohorts()
            await loadAllCohortAnalytics()
            lastRefreshTime = Date()
        } catch {
            errorMessage = error.localizedDescription
            showingErrorAlert = true
        }

        isRefreshing = false
    }

    @MainActor
    private func loadAllCohortAnalytics() async {
        for cohort in cohorts {
            do {
                let analytics = try await ApiService.shared.managerCohortAnalytics(cohortId: cohort.id)
                cohortAnalytics[cohort.id] = analytics
            } catch {
                print("Failed to load analytics for cohort \(cohort.id): \(error)")
            }
        }
    }
}

// MARK: - Supporting Views

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            QuickActionButtonContent(icon: icon, title: title, color: color)
        }
    }
}

/// Extracted so NavigationLink labels (Review Evidence / View Reports) can
/// share the exact same visual as the sheet-presenting buttons.
struct QuickActionButtonContent: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.matterNavy)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

struct ActivityCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .proCard()
    }
}

struct ManagerMenuCard: View {
    let icon: String
    let title: String
    let description: String
    var badge: String? = nil
    var badgeColor: Color = .matterOrange

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.matterOrange)
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterNavy)

                    if let badge = badge {
                        Spacer()
                        Text(badge)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(badgeColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.matterOrange)
        }
        .proCard()
    }
}

struct ManagerStatCard: View {
    let title: String
    let value: String
    let icon: String
    var subtitle: String? = nil
    var color: Color = .matterOrange

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .opacity(0.7)
            }
        }
        .proCard()
    }
}

struct StudentDetailSheet: View {
    let student: User
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Personal Information") {
                    LabeledContent("Name", value: "\(student.firstName) \(student.lastName)")
                    LabeledContent("Email", value: student.email)
                    LabeledContent("Role", value: student.role.rawValue.capitalized)
                    if let bio = student.bio {
                        LabeledContent("Bio", value: bio)
                    }
                }

                if let cohort = student.cohort {
                    Section("Cohort Information") {
                        LabeledContent("Cohort", value: cohort.name)
                        if let startDate = cohort.startDate {
                            LabeledContent("Start Date", value: startDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        if let endDate = cohort.endDate {
                            LabeledContent("End Date", value: endDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                }

                Section("Account Status") {
                    LabeledContent("Active", value: student.isActive == true ? "Yes" : "No")
                    if let createdAt = student.createdAt {
                        LabeledContent("Joined", value: createdAt.formatted(date: .abbreviated, time: .shortened))
                    }
                }
            }
            .navigationTitle("Student Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ManagerDashboardView()
}
