//
//  ManagerInsightsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI

struct ManagerInsightsView: View {
    let selectedCohortId: String

    @State private var analytics: CohortAnalytics?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                if isLoading {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if let analytics = analytics {
                    insightsContentView(analytics)
                } else {
                    emptyStateView
                }
            }
            .padding()
        }
        .navigationTitle("Program Insights")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await loadInsights()
        }
        .task {
            await loadInsights()
        }
    }

    // MARK: - View Components

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Analyzing cohort data...")
                .font(.headline)
                .foregroundColor(.matterNavy)
            Text("Generating insights and trends")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func errorView(_ message: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to Load Insights",
            message: message,
            actionTitle: "Retry"
        ) {
            Task { await loadInsights() }
        }
    }

    private var emptyStateView: some View {
        ProStateView(
            systemImage: "lightbulb.slash",
            title: "No Insights Available",
            message: "Not enough data has been collected yet.\nCheck back after students have submitted more evidence."
        )
    }

    // MARK: - Insights Content

    private func insightsContentView(_ analytics: CohortAnalytics) -> some View {
        Group {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.matterOrange)
                    Text("Program Insights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                }

                Text("A quick overview of what is happening in this cohort")
                    .foregroundStyle(.secondary)
            }

            InsightCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "Overall Progress",
                text: overallInsight(analytics)
            )

            InsightCard(
                icon: "arrow.up.circle.fill",
                title: "Strongest Skill",
                text: strongestSkillInsight(analytics)
            )

            InsightCard(
                icon: "exclamationmark.triangle.fill",
                title: "Needs Attention",
                text: weakestSkillInsight(analytics)
            )

            InsightCard(
                icon: "doc.text.fill",
                title: "Evidence Activity",
                text: evidenceInsight(analytics)
            )

            InsightCard(
                icon: "person.3.fill",
                title: "Student Engagement",
                text: engagementInsight(analytics)
            )

            InsightCard(
                icon: "lightbulb.fill",
                title: "Recommendation",
                text: recommendationInsight(analytics)
            )

            VStack(alignment: .leading, spacing: 12) {
                Text("Key Metrics")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
                
                KeyMetricsGrid(analytics: analytics)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Progress Trend")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
                
                ProgressTrendView(analytics: analytics)
            }
        }
    }

    // MARK: - Insight Calculations

    private func overallInsight(_ data: CohortAnalytics) -> String {
        let skills = data.mostDemonstrated + data.skillGaps
        guard !skills.isEmpty else { return "No skills have been demonstrated yet." }

        let average = skills.reduce(0.0) { $0 + $1.percentDemonstrated } / Double(skills.count)
        let demonstratedCount = data.mostDemonstrated.count
        let totalCount = skills.count

        if average >= 70 {
            return "The cohort is performing well with an average demonstration rate of \(String(format: "%.1f", average))%. \(demonstratedCount) of \(totalCount) skills have been demonstrated."
        } else if average >= 40 {
            return "The cohort is making progress with an average demonstration rate of \(String(format: "%.1f", average))%. \(demonstratedCount) of \(totalCount) skills have been demonstrated."
        } else {
            return "The cohort needs more engagement with a current demonstration rate of \(String(format: "%.1f", average))%. Only \(demonstratedCount) of \(totalCount) skills have been demonstrated."
        }
    }

    private func strongestSkillInsight(_ data: CohortAnalytics) -> String {
        guard let strongest = data.mostDemonstrated.first else {
            return "No skills have been demonstrated yet."
        }

        return "\(strongest.name) is currently the strongest demonstrated skill at \(String(format: "%.1f", strongest.percentDemonstrated))%."
    }

    private func weakestSkillInsight(_ data: CohortAnalytics) -> String {
        let allSkills = data.mostDemonstrated + data.skillGaps
        guard let weakest = allSkills.min(by: { $0.percentDemonstrated < $1.percentDemonstrated }) else {
            return "No skills have been demonstrated yet."
        }

        return "\(weakest.name) is currently the least demonstrated skill at \(String(format: "%.1f", weakest.percentDemonstrated))%. This area may require additional support."
    }

    private func evidenceInsight(_ data: CohortAnalytics) -> String {
        // Calculate total evidence from demonstrated skills
        let totalEvidence = data.mostDemonstrated.reduce(0) { $0 + Int($1.percentDemonstrated / 10) }
        return "\(totalEvidence) piece\(totalEvidence == 1 ? "" : "s") of evidence has been submitted, with \(data.evidencePending) currently awaiting review."
    }

    private func engagementInsight(_ data: CohortAnalytics) -> String {
        let avgPerStudent = Double(data.mostDemonstrated.count) / Double(max(data.totalStudents, 1))

        if avgPerStudent >= 3 {
            return "Students are highly engaged with an average of \(String(format: "%.1f", avgPerStudent)) skills demonstrated per student."
        } else if avgPerStudent >= 1 {
            return "Students are showing engagement with an average of \(String(format: "%.1f", avgPerStudent)) skills demonstrated per student."
        } else {
            return "Student engagement is low. Consider encouraging more evidence submission."
        }
    }

    private func recommendationInsight(_ data: CohortAnalytics) -> String {
        let allSkills = data.mostDemonstrated + data.skillGaps
        guard let weakest = allSkills.min(by: { $0.percentDemonstrated < $1.percentDemonstrated }) else {
            return "Continue encouraging students to submit evidence for all skills."
        }

        let avg = allSkills.reduce(0.0) { $0 + $1.percentDemonstrated } / Double(allSkills.count)

        if avg < 40 {
            return "Focus on increasing overall skill demonstration. Consider hosting workshops and providing more opportunities for students to demonstrate skills."
        } else if weakest.percentDemonstrated < 30 {
            return "Consider providing additional learning opportunities and support around '\(weakest.name)'. This skill has the lowest demonstration rate at \(String(format: "%.1f", weakest.percentDemonstrated))%."
        } else {
            return "Continue supporting skill development across all areas. The cohort is making good progress."
        }
    }

    // MARK: - Data Loading

    @MainActor
    private func loadInsights() async {
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

// MARK: - Key Metrics Grid

struct KeyMetricsGrid: View {
    let analytics: CohortAnalytics

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {
            MetricCard(
                title: "Students",
                value: "\(analytics.totalStudents)",
                icon: "person.3.fill",
                color: .blue
            )
            
            MetricCard(
                title: "Skills",
                value: "\(analytics.mostDemonstrated.count + analytics.skillGaps.count)",
                icon: "checklist",
                color: .matterOrange
            )
            
            MetricCard(
                title: "Demonstrated",
                value: "\(analytics.mostDemonstrated.count)",
                icon: "checkmark.seal.fill",
                color: .green
            )
            
            MetricCard(
                title: "Pending Reviews",
                value: "\(analytics.evidencePending)",
                icon: "clock.fill",
                color: analytics.evidencePending > 10 ? .orange : .yellow
            )
        }
    }
}

// MARK: - Metric Card

struct MetricCard: View {
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
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Progress Trend View

struct ProgressTrendView: View {
    let analytics: CohortAnalytics

    private var averageDemonstration: Double {
        let skills = analytics.mostDemonstrated
        guard !skills.isEmpty else { return 0.0 }
        let total = skills.reduce(0.0) { $0 + $1.percentDemonstrated }
        return total / Double(skills.count)
    }

    private var demonstrationLevel: String {
        if averageDemonstration >= 70 {
            return "Advanced"
        } else if averageDemonstration >= 40 {
            return "Intermediate"
        } else {
            return "Early Stage"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Level")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(demonstrationLevel)
                        .font(.headline)
                        .foregroundColor(.matterNavy)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Average Rate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f%%", averageDemonstration))
                        .font(.headline)
                        .foregroundColor(.matterOrange)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.matterNavy.opacity(0.1))
                            .frame(width: geometry.size.width, height: 12)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                averageDemonstration >= 70 ? Color.green :
                                averageDemonstration >= 40 ? Color.matterOrange :
                                Color.orange
                            )
                            .frame(width: max(geometry.size.width * CGFloat(averageDemonstration / 100), 12), height: 12)
                            .animation(.easeInOut(duration: 0.8), value: averageDemonstration)
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("0%").font(.caption2).foregroundStyle(.secondary)
                    Spacer()
                    Text("50%").font(.caption2).foregroundStyle(.secondary)
                    Spacer()
                    Text("100%").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManagerInsightsView(selectedCohortId: "test-cohort")
    }
}
