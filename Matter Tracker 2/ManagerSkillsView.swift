//
//  ManagerSkillsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI

struct ManagerSkillsView: View {
    let selectedCohortId: String
    
    @State private var analytics: CohortAnalytics?
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var selectedSkill: SkillStat?
    @State private var showingSkillDetail = false
    @State private var searchText = ""
    
    private var allSkills: [SkillStat] {
        (analytics?.mostDemonstrated ?? []) + (analytics?.skillGaps ?? [])
    }
    
    private var filteredSkills: [SkillStat] {
        if searchText.isEmpty {
            return allSkills
        } else {
            return allSkills.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        List {
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if let analytics = analytics {
                // Stats Header
                statsHeader(analytics)
                
                // Most Demonstrated Skills
                if !analytics.mostDemonstrated.isEmpty {
                    Section {
                        ForEach(analytics.mostDemonstrated) { skill in
                            ManagerSkillRow(
                                skill: skill,
                                type: .demonstrated,
                                onTap: {
                                    selectedSkill = skill
                                    showingSkillDetail = true
                                }
                            )
                        }
                    } header: {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.matterOrange)
                            Text("Most Demonstrated")
                                .foregroundColor(.matterNavy)
                        }
                    } footer: {
                        Text("Skills with the highest demonstration rates")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Skill Gaps
                if !analytics.skillGaps.isEmpty {
                    Section {
                        ForEach(analytics.skillGaps) { skill in
                            ManagerSkillRow(
                                skill: skill,
                                type: .gap,
                                onTap: {
                                    selectedSkill = skill
                                    showingSkillDetail = true
                                }
                            )
                        }
                    } header: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Skill Gaps")
                                .foregroundColor(.matterNavy)
                        }
                    } footer: {
                        Text("Skills that need additional attention")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                emptyStateView
            }
        }
        .navigationTitle("Skills Data")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search skills"
        )
        .refreshable {
            await refreshSkills()
        }
        .task {
            await loadSkills()
        }
        .sheet(isPresented: $showingSkillDetail) {
            if let skill = selectedSkill {
                ManagerSkillDetailSheet(
                    skill: skill,
                    cohortId: selectedCohortId
                )
            }
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
                    Text("Loading skills data...")
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
                
                Text("Unable to Load Skills")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task { await loadSkills() }
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
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.system(size: 50))
                    .foregroundColor(.matterOrange.opacity(0.6))
                
                Text("No Skills Data")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("No skills have been tracked or demonstrated in this cohort yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    private func statsHeader(_ analytics: CohortAnalytics) -> some View {
        Section {
            VStack(spacing: 12) {
                HStack {
                    ManagerStatBadge(
                        icon: "checklist",
                        value: "\(analytics.mostDemonstrated.count + analytics.skillGaps.count)",
                        label: "Total Skills",
                        color: .matterOrange
                    )
                    
                    Spacer()
                    
                    ManagerStatBadge(
                        icon: "star.circle.fill",
                        value: "\(analytics.mostDemonstrated.count)",
                        label: "Demonstrated",
                        color: .green
                    )
                    
                    Spacer()
                    
                    ManagerStatBadge(
                        icon: "exclamationmark.triangle.fill",
                        value: "\(analytics.skillGaps.count)",
                        label: "Gaps",
                        color: .red
                    )
                }
                
                // Overall progress
                let average = calculateAverage(analytics)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Overall Demonstration Rate")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "%.1f%%", average))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.matterOrange)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.matterNavy.opacity(0.1))
                                .frame(width: geometry.size.width, height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(progressColor(average))
                                .frame(width: max(geometry.size.width * CGFloat(average / 100), 8), height: 8)
                                .animation(.easeInOut(duration: 0.8), value: average)
                        }
                    }
                    .frame(height: 8)
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.clear)
    }
    
    private func calculateAverage(_ analytics: CohortAnalytics) -> Double {
        let allSkills = analytics.mostDemonstrated + analytics.skillGaps
        guard !allSkills.isEmpty else { return 0.0 }
        let total = allSkills.reduce(0.0) { $0 + $1.percentDemonstrated }
        return total / Double(allSkills.count)
    }
    
    private func progressColor(_ percentage: Double) -> Color {
        if percentage >= 70 {
            return .green
        } else if percentage >= 40 {
            return .matterOrange
        } else {
            return .red
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadSkills() async {
        isLoading = true
        errorMessage = nil
        
        do {
            analytics = try await ApiService.shared.managerCohortAnalytics(cohortId: selectedCohortId)
        } catch {
            errorMessage = error.localizedDescription
            analytics = nil
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshSkills() async {
        isRefreshing = true
        await loadSkills()
    }
}

// MARK: - Manager Skill Row

struct ManagerSkillRow: View {
    let skill: SkillStat
    let type: SkillType
    let onTap: () -> Void
    
    enum SkillType {
        case demonstrated
        case gap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: type == .demonstrated ? "star.fill" : "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(type == .demonstrated ? .matterOrange : .red)
                    .frame(width: 20)
                
                Text(skill.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.matterNavy)
                
                Spacer()
                
                Text(String(format: "%.1f%%", skill.percentDemonstrated))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(type == .demonstrated ? .matterOrange : .red)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.matterNavy.opacity(0.1))
                        .frame(width: geometry.size.width, height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(type == .demonstrated ? Color.matterOrange : Color.red)
                        .frame(width: max(geometry.size.width * CGFloat(skill.percentDemonstrated / 100), 6), height: 6)
                        .animation(.easeInOut(duration: 0.6), value: skill.percentDemonstrated)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Manager Stat Badge

struct ManagerStatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Manager Skill Detail Sheet

struct ManagerSkillDetailSheet: View {
    let skill: SkillStat
    let cohortId: String
    @Environment(\.dismiss) private var dismiss
    @State private var candidates: [PublicCandidateSummary] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Skill Overview") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(skill.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.matterNavy)
                        
                        HStack {
                            Label("Demonstration Rate", systemImage: "chart.bar.fill")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.1f%%", skill.percentDemonstrated))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.matterOrange)
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.matterNavy.opacity(0.1))
                                    .frame(width: geometry.size.width, height: 12)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(skill.percentDemonstrated >= 70 ? Color.green : skill.percentDemonstrated >= 40 ? Color.matterOrange : Color.red)
                                    .frame(width: max(geometry.size.width * CGFloat(skill.percentDemonstrated / 100), 12), height: 12)
                                    .animation(.easeInOut(duration: 0.8), value: skill.percentDemonstrated)
                            }
                        }
                        .frame(height: 12)
                        
                        Text(performanceLevel(skill.percentDemonstrated))
                            .font(.caption)
                            .foregroundColor(skill.percentDemonstrated >= 70 ? .green : skill.percentDemonstrated >= 40 ? .matterOrange : .red)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Candidates") {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    } else if candidates.isEmpty {
                        Text("No candidates have demonstrated this skill yet.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(candidates) { candidate in
                            NavigationLink {
                                CandidateProfileView(candidateId: candidate.id)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(candidate.firstName) \(candidate.lastName)")
                                            .font(.subheadline)
                                            .foregroundColor(.matterNavy)
                                        if let cohort = candidate.cohort {
                                            Text(cohort.name)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    if let bio = candidate.bio, !bio.isEmpty {
                                        Text(bio)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Skill Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
        .task {
            await loadCandidates()
        }
    }
    
    private func performanceLevel(_ percentage: Double) -> String {
        if percentage >= 70 {
            return "✅ Strong performance - this skill is well demonstrated"
        } else if percentage >= 40 {
            return "📈 Moderate performance - room for improvement"
        } else {
            return "⚠️ Low performance - needs attention"
        }
    }
    
    @MainActor
    private func loadCandidates() async {
        isLoading = true
        do {
            candidates = try await ApiService.shared.publicCandidates(skill: skill.name)
        } catch {
            candidates = []
        }
        isLoading = false
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManagerSkillsView(selectedCohortId: "test-cohort")
    }
}
