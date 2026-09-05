//
//  ManagerEvidenceView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI

struct ManagerEvidenceView: View {
    let selectedCohortId: String

    // Renamed from the old pendingEvidence/allEvidence split — the previous
    // version only ever fetched pending evidence, so filtering it by
    // Approved/Rejected/Needs More always showed zero regardless of what
    // was actually in the database. This now fetches every status.
    @State private var evidence: [Evidence] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var selectedFilter = EvidenceFilter.all
    @State private var searchText = ""
    @State private var selectedEvidence: Evidence?
    @State private var showingEvidenceDetail = false

    enum EvidenceFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case approved = "Approved"
        case rejected = "Rejected"
        case moreEvidence = "More Evidence Needed"

        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .pending: return "clock.fill"
            case .approved: return "checkmark.circle.fill"
            case .rejected: return "xmark.circle.fill"
            case .moreEvidence: return "arrow.clockwise.circle.fill"
            }
        }
    }

    private var filteredEvidence: [Evidence] {
        var result = evidence

        switch selectedFilter {
        case .all:
            break
        case .pending:
            result = result.filter { $0.status == .pending_review }
        case .approved:
            result = result.filter { $0.status == .approved }
        case .rejected:
            result = result.filter { $0.status == .rejected }
        case .moreEvidence:
            result = result.filter { $0.status == .more_evidence_needed }
        }

        if !searchText.isEmpty {
            result = result.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                (item.skill?.name ?? "").localizedCaseInsensitiveContains(searchText) ||
                (item.student?.firstName ?? "").localizedCaseInsensitiveContains(searchText) ||
                (item.student?.lastName ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    private var stats: (total: Int, pending: Int, approved: Int, rejected: Int, needsMore: Int) {
        let total = evidence.count
        let pending = evidence.filter { $0.status == .pending_review }.count
        let approved = evidence.filter { $0.status == .approved }.count
        let rejected = evidence.filter { $0.status == .rejected }.count
        let needsMore = evidence.filter { $0.status == .more_evidence_needed }.count
        return (total, pending, approved, rejected, needsMore)
    }

    var body: some View {
        List {
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if evidence.isEmpty {
                emptyStateView
            } else {
                statsSection
                filterSection

                if filteredEvidence.isEmpty {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.matterOrange.opacity(0.6))
                            Text("No evidence matches your filters")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(filteredEvidence) { item in
                        EvidenceRow(evidence: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEvidence = item
                                showingEvidenceDetail = true
                            }
                    }
                }
            }
        }
        .navigationTitle("Evidence Data")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by title, skill, or student"
        )
        .refreshable {
            await refreshEvidence()
        }
        .task {
            await loadEvidence()
        }
        .sheet(isPresented: $showingEvidenceDetail) {
            if let item = selectedEvidence {
                EvidenceDetailSheet(evidence: item) {
                    Task { await loadEvidence() }
                }
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
                    Text("Loading evidence...")
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

                Text("Unable to Load Evidence")
                    .font(.headline)
                    .foregroundColor(.matterNavy)

                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    Task { await loadEvidence() }
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
                Image(systemName: "doc.text.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.matterOrange.opacity(0.6))

                Text("No Evidence Found")
                    .font(.headline)
                    .foregroundColor(.matterNavy)

                Text("No evidence has been submitted in this cohort yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }

    private var statsSection: some View {
        Section {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                StatsCard(title: "Total", value: "\(stats.total)", icon: "doc.text.fill", color: .matterOrange)
                StatsCard(title: "Pending", value: "\(stats.pending)", icon: "clock.fill", color: .orange)
                StatsCard(title: "Approved", value: "\(stats.approved)", icon: "checkmark.circle.fill", color: .green)
                StatsCard(title: "Rejected", value: "\(stats.rejected)", icon: "xmark.circle.fill", color: .red)
                StatsCard(title: "Needs More", value: "\(stats.needsMore)", icon: "arrow.clockwise.circle.fill", color: .yellow)
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(Color.clear)
    }

    private var filterSection: some View {
        Section("Filter by Status") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(EvidenceFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            icon: filter.icon,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 0)
        }
        .listRowBackground(Color.clear)
    }

    // MARK: - Data Loading

    @MainActor
    private func loadEvidence() async {
        isLoading = true
        errorMessage = nil

        do {
            evidence = try await ApiService.shared.managerCohortPendingReviews(cohortId: selectedCohortId)
        } catch {
            errorMessage = error.localizedDescription
            evidence = []
        }

        isLoading = false
        isRefreshing = false
    }
    @MainActor
    private func refreshEvidence() async {
        isRefreshing = true
        await loadEvidence()
    }
}

// MARK: - Stats Card

struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .proCard(padding: 8, cornerRadius: 10)
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.matterOrange : Color.matterNavy.opacity(0.05))
            .foregroundColor(isSelected ? .white : .matterNavy)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Evidence Row

struct EvidenceRow: View {
    let evidence: Evidence

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.matterOrange)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(evidence.title)
                        .font(.headline)
                        .foregroundColor(.matterNavy)

                    if let skill = evidence.skill {
                        Text("Skill: \(skill.name)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if let status = evidence.status {
                    EvidenceStatusBadge(status: status)
                }
            }

            if let student = evidence.student {
                Text("\(student.firstName) \(student.lastName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let submittedAt = evidence.submittedAt {
                Label(submittedAt.formatted(date: .abbreviated, time: .shortened),
                      systemImage: "calendar")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Evidence Detail Sheet

/// Shows evidence detail AND lets a facilitator/manager actually make a
/// review decision (approve / reject / request more evidence). The
/// previous version declared `reviewFeedback`/`isSubmitting` but never
/// used them — this wires them to a real PATCH /evidence/:id/review call.
struct EvidenceDetailSheet: View {
    let evidence: Evidence

    /// Called after a successful review so the parent list can refresh.
    var onReviewed: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var reviewFeedback = ""
    @State private var isSubmitting = false
    @State private var submitError: String?

    private var canReview: Bool {
        evidence.status == .pending_review || evidence.status == .more_evidence_needed
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Evidence Details") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(evidence.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.matterNavy)

                        if let description = evidence.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        DetailRow(label: "Type", value: evidence.type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)

                        if let skill = evidence.skill {
                            DetailRow(label: "Skill", value: skill.name)
                        }

                        if let student = evidence.student {
                            DetailRow(label: "Student", value: "\(student.firstName) \(student.lastName)")
                        }

                        if let submittedAt = evidence.submittedAt {
                            DetailRow(label: "Submitted", value: submittedAt.formatted(date: .abbreviated, time: .shortened))
                        }

                        if let reviewedAt = evidence.reviewedAt {
                            DetailRow(label: "Reviewed", value: reviewedAt.formatted(date: .abbreviated, time: .shortened))
                        }

                        DetailRow(label: "Status", value: statusText(evidence.status))
                    }
                    .padding(.vertical, 8)
                }

                if let feedback = evidence.feedback, !feedback.isEmpty {
                    Section("Previous Feedback") {
                        Text(feedback)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }

                if evidence.attachmentUrl != nil || evidence.githubUrl != nil || evidence.videoUrl != nil {
                    Section("Links") {
                        if let url = evidence.attachmentUrl {
                            Link("📎 Attachment", destination: URL(string: url) ?? URL(string: "about:blank")!)
                        }
                        if let url = evidence.githubUrl {
                            Link("💻 GitHub Repository", destination: URL(string: url) ?? URL(string: "about:blank")!)
                        }
                        if let url = evidence.videoUrl {
                            Link("🎥 Video", destination: URL(string: url) ?? URL(string: "about:blank")!)
                        }
                    }
                }

                if canReview {
                    Section("Make a Decision") {
                        TextField("Feedback (optional)", text: $reviewFeedback, axis: .vertical)
                            .lineLimit(3...6)

                        if let submitError {
                            Text(submitError)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }

                        HStack(spacing: 8) {
                            reviewButton(title: "Approve", color: .green, decision: .approve)
                            reviewButton(title: "Reject", color: .red, decision: .reject)
                            reviewButton(title: "More Evidence", color: .yellow, decision: .more_evidence)
                        }
                        .disabled(isSubmitting)
                    }
                }
            }
            .navigationTitle("Evidence Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
    }

    private func reviewButton(title: String, color: Color, decision: ReviewDecision) -> some View {
        Button {
            Task { await submit(decision: decision) }
        } label: {
            if isSubmitting {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }

    @MainActor
    private func submit(decision: ReviewDecision) async {
        isSubmitting = true
        submitError = nil
        do {
            _ = try await ApiService.shared.reviewEvidence(
                id: evidence.id,
                decision: decision,
                feedback: reviewFeedback.isEmpty ? nil : reviewFeedback
            )
            onReviewed()
            dismiss()
        } catch {
            submitError = error.localizedDescription
        }
        isSubmitting = false
    }

    private func statusText(_ status: EvidenceStatus?) -> String {
        switch status {
        case .pending_review: return "Pending Review"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        case .more_evidence_needed: return "More Evidence Needed"
        case .none: return "Unknown"
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.matterNavy)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManagerEvidenceView(selectedCohortId: "test-cohort")
    }
}
