//
//  SkillTrackerView.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI

struct SkillTrackerView: View {
    @State private var skills: [SkillWithStatus] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var showingAddSkillSheet = false
    @State private var currentUserId: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.matterNavy.ignoresSafeArea()
                
                if isLoading && !isRefreshing {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if skills.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(skills) { skill in
                                NavigationLink(destination: SkillDetailView(
                                    skillId: skill.id,
                                    skillName: skill.name,
                                    skillCategory: skill.category ?? .technical
                                )) {
                                    SkillRowView(
                                        name: skill.name,
                                        description: skill.description ?? "",
                                        category: skill.category ?? .technical,
                                        status: skill.status ?? .not_started
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Skills")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSkillSheet = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.matterOrange)
                    }
                }
            }
            .refreshable {
                await refreshSkills()
            }
            .task {
                await loadUserAndSkills()
            }
            .sheet(isPresented: $showingAddSkillSheet) {
                if let userId = currentUserId {
                    AddSkillSheet(studentId: userId)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading skills...")
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
            Text("Unable to Load Skills")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Button {
                Task { await loadUserAndSkills() }
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
    
    private var emptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 44))
                .foregroundColor(.matterOrange.opacity(0.5))
            Text("No Skills Tracked")
                .font(.headline)
                .foregroundColor(.white)
            Text("Start tracking your skills by adding your first one.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
            Button {
                showingAddSkillSheet = true
            } label: {
                Text("Add Your First Skill")
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
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadUserAndSkills() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await ApiService.shared.me()
            currentUserId = user.id
            skills = try await ApiService.shared.studentSkills(studentId: user.id)
        } catch {
            errorMessage = error.localizedDescription
            skills = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshSkills() async {
        isRefreshing = true
        await loadUserAndSkills()
    }
}

// MARK: - Skill Row View

struct SkillRowView: View {
    let name: String
    let description: String
    let category: SkillCategory
    let status: SkillStatus
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: category == .technical ? "chevron.left.forwardslash.chevron.right" : "person.fill.checkmark")
                .font(.headline)
                .foregroundColor(category == .technical ? .matterOrange : .green)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(status.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(statusColor(status).opacity(0.12))
                .foregroundColor(statusColor(status))
                .cornerRadius(4)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private func statusColor(_ status: SkillStatus) -> Color {
        switch status {
        case .not_started: return .gray
        case .in_progress: return .blue
        case .pending_review: return .orange
        case .demonstrated: return .green
        case .needs_more_evidence: return .red
        }
    }
}

// MARK: - Add Skill Sheet

struct AddSkillSheet: View {
    @Environment(\.dismiss) private var dismiss
    let studentId: String
    
    @State private var skillName = ""
    @State private var skillDescription = ""
    @State private var skillType: SkillCategory = .technical
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Skill Information") {
                    TextField("Skill Name", text: $skillName)
                    TextField("Description", text: $skillDescription, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Type", selection: $skillType) {
                        Text("Technical").tag(SkillCategory.technical)
                        Text("Essential").tag(SkillCategory.essential)
                    }
                    .pickerStyle(.segmented)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button {
                        addSkill()
                    } label: {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Add Skill")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(skillName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
                    .buttonStyle(.borderedProminent)
                    .tint(.matterOrange)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
    }
    
    @MainActor
    private func addSkill() {
        let trimmedName = skillName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                let newSkill = ApiService.CreateSkillBody(
                    name: trimmedName,
                    category: skillType,
                    description: skillDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                _ = try await ApiService.shared.createSkill(newSkill)
                
                await MainActor.run {
                    isSubmitting = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SkillTrackerView()
}
