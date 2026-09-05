//
//  ManagerReportsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI
import Charts

struct ManagerReportsView: View {
    let selectedCohortId: String
    
    @State private var analytics: CohortAnalytics?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTimeRange = "All Time"
    
    let timeRanges = ["All Time", "Last 30 Days", "Last 90 Days"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if isLoading {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if let analytics = analytics {
                    reportContentView(analytics)
                } else {
                    emptyStateView
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Cohort Reports")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await loadReport()
        }
        .task(id: selectedCohortId) {
            await loadReport()
        }
    }
    
    // MARK: - Main Content Layout
    
    @ViewBuilder
    private func reportContentView(_ analytics: CohortAnalytics) -> some View {
        // Header
        ReportHeader(cohortId: selectedCohortId)
        
        // Time Range Picker
        VStack(alignment: .leading, spacing: 8) {
            Text("Time Range")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.matterNavy)
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(timeRanges, id: \.self) { range in
                    Text(range).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .tint(.matterOrange)
        }
        
        // Overview Stats
        OverviewStatsGrid(analytics: analytics)
        
        // Skill Performance Chart
        if !analytics.mostDemonstrated.isEmpty || !analytics.skillGaps.isEmpty {
            SkillPerformanceChartSection(analytics: analytics)
        }
        
        // Top Skills
        if !analytics.mostDemonstrated.isEmpty {
            TopSkillsSection(skills: Array(analytics.mostDemonstrated.prefix(5)))
        }
        
        // Skill Gaps
        if !analytics.skillGaps.isEmpty {
            SkillGapsSection(skills: Array(analytics.skillGaps.prefix(5)))
        }
        
        // Export Button
        exportButton
        
        // Summary
        SummarySection(analytics: analytics)
        
        // Last Updated
        Text("Last updated: \(Date().formatted(date: .abbreviated, time: .shortened))")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
    }
    
    // MARK: - State Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            
            Text("Analyzing cohort metrics...")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            Text("Fetching student progress and skill data")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to Load Analytics",
            message: message,
            actionTitle: "Retry"
        ) {
            Task { await loadReport() }
        }
    }
    
    private var emptyStateView: some View {
        ProStateView(
            systemImage: "chart.bar.doc.horizontal",
            title: "No Analytics Available",
            message: "This cohort doesn't have enough data yet.\nCheck back after students have submitted evidence."
        )
    }
    
    // MARK: - Export Button
    
    private var exportButton: some View {
        Button(action: exportReport) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export Report")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding()
            .background(Color.matterOrange)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Actions
    
    private func exportReport() {
        // TODO: Implement export functionality
        print("Exporting report for cohort: \(selectedCohortId)")
    }
    
    // MARK: - Data Fetching
    
    @MainActor
    private func loadReport() async {
        isLoading = true
        errorMessage = nil
        
        do {
            analytics = try await ApiService.shared.managerCohortAnalytics(cohortId: selectedCohortId)
        } catch {
            errorMessage = error.localizedDescription
            analytics = nil
        }
        
        isLoading = false
    }
}

// MARK: - Header Component

private struct ReportHeader: View {
    let cohortId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundColor(.matterOrange)
                
                Text("Cohort Report")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
            }
            
            HStack(spacing: 6) {
                Label("ID: \(cohortId)", systemImage: "number.square")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 4)
    }
}

// MARK: - Overview Grid

private struct OverviewStatsGrid: View {
    let analytics: CohortAnalytics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ReportStatCard(
                    title: "Students",
                    value: "\(analytics.totalStudents)",
                    icon: "person.3.fill",
                    color: .matterOrange
                )
                
                ReportStatCard(
                    title: "Skills Tracked",
                    value: "\(analytics.mostDemonstrated.count + analytics.skillGaps.count)",
                    icon: "checklist",
                    color: .blue
                )
                
                ReportStatCard(
                    title: "Pending Reviews",
                    value: "\(analytics.evidencePending)",
                    icon: "clock.fill",
                    color: .yellow
                )
            }
        }
    }
}

// MARK: - Chart Section

private struct SkillPerformanceChartSection: View {
    let analytics: CohortAnalytics
    
    private var sortedSkills: [SkillStat] {
        (analytics.mostDemonstrated + analytics.skillGaps)
            .sorted { $0.percentDemonstrated > $1.percentDemonstrated }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.matterOrange)
                Text("Skill Performance")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
            }
            
            Text("Demonstration rates across all active competencies")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Chart {
                ForEach(sortedSkills) { skill in
                    BarMark(
                        x: .value("Skill", skill.name),
                        y: .value("Percentage", skill.percentDemonstrated)
                    )
                    .foregroundStyle(barColor(for: skill.percentDemonstrated))
                    .cornerRadius(6)
                }
            }
            .chartYScale(domain: 0...100)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                    AxisGridLine()
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                }
            }
            .frame(height: 250)
            .padding()
            .background(Color.matterNavy.opacity(0.03))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.matterNavy.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    private func barColor(for percentage: Double) -> Color {
        switch percentage {
        case 70...100:
            return .matterOrange
        case 40..<70:
            return .matterOrange.opacity(0.6)
        default:
            return .red.opacity(0.7)
        }
    }
}

// MARK: - Top Skills Section

private struct TopSkillsSection: View {
    let skills: [SkillStat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.matterOrange)
                Text("Top Demonstrated Skills")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
            }
            
            Text("Skills with the highest demonstration rates")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ForEach(Array(skills.enumerated()), id: \.element.id) { index, skill in
                SkillPerformanceRow(
                    rank: index + 1,
                    skillName: skill.name,
                    percentage: skill.percentDemonstrated,
                    color: .matterOrange
                )
            }
        }
    }
}

// MARK: - Skill Gaps Section

private struct SkillGapsSection: View {
    let skills: [SkillStat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Areas Needing Attention")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
            }
            
            Text("Skills with the lowest demonstration rates")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ForEach(Array(skills.enumerated()), id: \.element.id) { index, skill in
                SkillPerformanceRow(
                    rank: index + 1,
                    skillName: skill.name,
                    percentage: skill.percentDemonstrated,
                    color: .red
                )
            }
        }
    }
}

// MARK: - Summary Section

private struct SummarySection: View {
    let analytics: CohortAnalytics
    
    private var averageDemonstration: Double {
        let skills = analytics.mostDemonstrated
        guard !skills.isEmpty else { return 0.0 }
        let total = skills.reduce(0.0) { $0 + $1.percentDemonstrated }
        return total / Double(skills.count)
    }
    
    private var totalSkills: Int {
        analytics.mostDemonstrated.count + analytics.skillGaps.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "list.clipboard.fill")
                    .foregroundColor(.matterOrange)
                Text("Summary & Insights")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
            }
            
            InsightCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "Average Demonstration Rate",
                text: String(format: "%.1f%% of %d tracked skills have been demonstrated across this cohort.", averageDemonstration, totalSkills)
            )
            
            InsightCard(
                icon: "doc.text.fill",
                title: "Evidence Queue",
                text: "\(analytics.evidencePending) submission\(analytics.evidencePending == 1 ? "" : "s") currently awaiting review."
            )
            
            if let lowestSkill = analytics.skillGaps.min(by: { $0.percentDemonstrated < $1.percentDemonstrated }) {
                InsightCard(
                    icon: "lightbulb.fill",
                    title: "Recommended Focus Area",
                    text: "Consider organizing workshop sessions for '\(lowestSkill.name)' (currently \(String(format: "%.1f", lowestSkill.percentDemonstrated))% demonstrated)."
                )
            }
            
            if let highestSkill = analytics.mostDemonstrated.max(by: { $0.percentDemonstrated < $1.percentDemonstrated }) {
                InsightCard(
                    icon: "crown.fill",
                    title: "Strength Area",
                    text: "'\(highestSkill.name)' is the strongest skill at \(String(format: "%.1f", highestSkill.percentDemonstrated))% demonstration."
                )
            }
        }
    }
}

// MARK: - Supporting Subviews

struct ReportStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
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
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SkillPerformanceRow: View {
    let rank: Int
    let skillName: String
    let percentage: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("#\(rank)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                    .background(color.opacity(0.12))
                    .clipShape(Circle())
                
                Text(skillName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.matterNavy)
                
                Spacer()
                
                Text(String(format: "%.1f%%", percentage))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.15))
                        .frame(width: geometry.size.width, height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: max(geometry.size.width * CGFloat(min(max(percentage, 0), 100) / 100), 8), height: 8)
                        .animation(.easeInOut(duration: 0.8), value: percentage)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.matterOrange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.matterNavy.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManagerReportsView(selectedCohortId: "cohort-4-uuid")
    }
}
