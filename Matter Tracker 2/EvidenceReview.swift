//
//  EvidenceReviewView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct EvidenceReviewView: View {
    let evidence: Evidence
    @Environment(\.dismiss) private var dismiss
    
    @State private var decision: ReviewDecision = .approve
    @State private var feedback = ""
    @State private var isSubmitting = false
    @State private var showConfirmation = false
    @State private var assessmentComplete = false
    
    var body: some View {
        List {
            // MARK: - Evidence Details
            Section("Evidence Details") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(evidence.title)
                        .font(.headline)
                        .foregroundColor(.matterNavy)
                    
                    if let description = evidence.description, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    if let skill = evidence.skill {
                        DetailRow(label: "Skill", value: skill.name)
                    }
                    
                    if let student = evidence.student {
                        DetailRow(label: "Student", value: "\(student.firstName) \(student.lastName)")
                    }
                    
                    DetailRow(label: "Type", value: evidence.type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                    
                    if let submittedAt = evidence.submittedAt {
                        DetailRow(label: "Submitted", value: submittedAt.formatted(date: .abbreviated, time: .shortened))
                    }
                    
                    if let status = evidence.status {
                        DetailRow(label: "Status", value: statusText(status))
                    }
                }
                .padding(.vertical, 8)
            }
            
            // MARK: - Links
            if evidence.attachmentUrl != nil || evidence.githubUrl != nil || evidence.videoUrl != nil {
                Section("Links") {
                    if let url = evidence.attachmentUrl, let urlObj = URL(string: url) {
                        Link(destination: urlObj) {
                            Label("📎 Attachment", systemImage: "paperclip")
                        }
                    }
                    if let url = evidence.githubUrl, let urlObj = URL(string: url) {
                        Link(destination: urlObj) {
                            Label("💻 GitHub Repository", systemImage: "chevron.left.forwardslash.chevron.right")
                        }
                    }
                    if let url = evidence.videoUrl, let urlObj = URL(string: url) {
                        Link(destination: urlObj) {
                            Label("🎥 Video", systemImage: "video.fill")
                        }
                    }
                }
            }
            
            // MARK: - Assessment Decision
            Section("Decision") {
                Picker("Decision", selection: $decision) {
                    ForEach(ReviewDecision.allCases, id: \.self) { decision in
                        Text(decision.rawValue.capitalized)
                            .tag(decision)
                    }
                }
                .pickerStyle(.segmented)
                .tint(.matterOrange)
            }
            
            // MARK: - Facilitator Feedback
            Section("Facilitator Feedback") {
                TextEditor(text: $feedback)
                    .frame(height: 120)
                    .overlay(
                        Group {
                            if feedback.isEmpty {
                                Text(decision == .approve ? "Explain what the student did well..." : "Explain what the student needs to improve...")
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                    .padding(.top, 8)
                            }
                        },
                        alignment: .topLeading
                    )
            }
            
            // MARK: - Submit
            Section {
                Button {
                    submitReview()
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
                        Text("Submit Review")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
                .buttonStyle(.borderedProminent)
                .tint(.matterOrange)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Review Evidence")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Review Submitted", isPresented: $showConfirmation) {
            Button("OK") {
                assessmentComplete = true
            }
        } message: {
            Text("Your review has been submitted successfully.")
        }
        .navigationDestination(isPresented: $assessmentComplete) {
            ReviewCompleteView(decision: decision, feedback: feedback)
        }
    }
    
    // MARK: - Helper Functions
    
    private func statusText(_ status: EvidenceStatus) -> String {
        switch status {
        case .pending_review: return "Pending Review"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        case .more_evidence_needed: return "More Evidence Needed"
        }
    }
    
    private func submitReview() {
        guard !feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isSubmitting = true
        
        Task {
            do {
                _ = try await ApiService.shared.reviewEvidence(
                    id: evidence.id,
                    decision: decision,
                    feedback: feedback
                )
                
                await MainActor.run {
                    isSubmitting = false
                    showConfirmation = true
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    // Show error alert
                }
            }
        }
    }
}

// MARK: - Review Complete View

struct ReviewCompleteView: View {
    let decision: ReviewDecision
    let feedback: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: decision == .approve ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(decision == .approve ? .green : .orange)
            
            Text("Review Submitted")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            
            Text(decision == .approve ? "The evidence has been approved." : "Changes have been requested from the student.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            // Decision Card
            VStack(alignment: .leading, spacing: 10) {
                Text("Decision")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                HStack {
                    Image(systemName: decision == .approve ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill")
                        .foregroundStyle(decision == .approve ? .green : .orange)
                    Text(decision.rawValue.capitalized)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color.matterNavy.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Feedback Card
            VStack(alignment: .leading, spacing: 10) {
                Text("Feedback")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(feedback)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.matterNavy.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            Button {
                dismiss()
                dismiss() // Dismiss both sheets
            } label: {
                Text("Back to Dashboard")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.matterOrange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Pending Reviews List View

struct PendingReviewsListView: View {
    @State private var pendingEvidence: [Evidence] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    @State private var selectedEvidence: Evidence?
    @State private var showingReview = false
    
    private var filteredEvidence: [Evidence] {
        if searchText.isEmpty {
            return pendingEvidence
        } else {
            return pendingEvidence.filter { evidence in
                evidence.title.localizedCaseInsensitiveContains(searchText) ||
                (evidence.skill?.name ?? "").localizedCaseInsensitiveContains(searchText) ||
                (evidence.student?.firstName ?? "").localizedCaseInsensitiveContains(searchText) ||
                (evidence.student?.lastName ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if pendingEvidence.isEmpty {
                emptyStateView
            } else {
                Section("\(filteredEvidence.count) Pending Reviews") {
                    ForEach(filteredEvidence) { evidence in
                        PendingEvidenceRow(evidence: evidence)
                            .onTapGesture {
                                selectedEvidence = evidence
                                showingReview = true
                            }
                    }
                }
            }
        }
        .navigationTitle("Pending Reviews")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by title, skill, or student"
        )
        .refreshable {
            await refreshPending()
        }
        .task {
            await loadPending()
        }
        .sheet(isPresented: $showingReview) {
            if let evidence = selectedEvidence {
                NavigationStack {
                    EvidenceReviewView(evidence: evidence)
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
                    Text("Loading pending reviews...")
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
                
                Text("Unable to Load Reviews")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task { await loadPending() }
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
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                
                Text("All Caught Up!")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("No pending evidence reviews at the moment.")
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
    private func loadPending() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pendingEvidence = try await ApiService.shared.facilitatorPendingReviews()
        } catch {
            errorMessage = error.localizedDescription
            pendingEvidence = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshPending() async {
        isRefreshing = true
        await loadPending()
    }
}

// MARK: - Pending Evidence Row

struct PendingEvidenceRow: View {
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
                
                Text("Pending")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.15))
                    .foregroundColor(.orange)
                    .clipShape(Capsule())
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
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PendingReviewsListView()
    }
}
