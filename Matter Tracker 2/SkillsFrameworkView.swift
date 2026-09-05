//
//  SkillsFrameworkView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillsFrameworkView: View {
    
    @State private var technicalSkills: [Skill] = []
    @State private var essentialSkills: [Skill] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        List {
            
            if isLoading {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.2)
                            Text("Loading skills...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
            } else if let error = errorMessage {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.matterOrange)
                        Text("Unable to load skills")
                            .font(.headline)
                            .foregroundColor(.matterNavy)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await loadSkills()
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.matterOrange)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            } else {
                // Technical Skills Section
                if !technicalSkills.isEmpty {
                    Section {
                        ForEach(technicalSkills) { skill in
                            NavigationLink {
                                SkillFrameworkDetailView(skill: skill)
                            } label: {
                                SkillRow(skill: skill)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundColor(.matterOrange)
                            Text("Technical Skills")
                                .font(.headline)
                                .foregroundColor(.matterNavy)
                        }
                    }
                }
                
                // Essential Skills Section
                if !essentialSkills.isEmpty {
                    Section {
                        ForEach(essentialSkills) { skill in
                            NavigationLink {
                                SkillFrameworkDetailView(skill: skill)
                            } label: {
                                SkillRow(skill: skill)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: "heart")
                                .foregroundColor(.matterOrange)
                            Text("Essential Skills")
                                .font(.headline)
                                .foregroundColor(.matterNavy)
                        }
                    }
                }
            }
        }
        .navigationTitle("Skills Framework")
        .refreshable {
            await loadSkills()
        }
        .task {
            await loadSkills()
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadSkills() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load all skills
            let allSkills = try await ApiService.shared.listSkills()
            
            // Separate into technical and essential
            technicalSkills = allSkills.filter { $0.category == .technical }
            essentialSkills = allSkills.filter { $0.category == .essential }
            
        } catch {
            errorMessage = error.localizedDescription
            technicalSkills = []
            essentialSkills = []
        }
        
        isLoading = false
    }
}

// MARK: - Skill Row

struct SkillRow: View {
    let skill: Skill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(skill.name)
                .fontWeight(.semibold)
                .foregroundColor(.matterNavy)
            
            if let description = skill.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SkillsFrameworkView()
    }
}
