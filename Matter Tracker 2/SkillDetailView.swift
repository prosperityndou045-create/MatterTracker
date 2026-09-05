//
//  SkillDetailView.swift
//  Matter Tracker
//
//  Created by admin on 5/9/2026.
//


//
//  SkillDetailView.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import AVKit
import AVFoundation

// MARK: - Skill Detail View

struct SkillDetailView: View {
    let skillId: String
    let skillName: String
    let skillCategory: SkillCategory
    
    @State private var skillDetail: ApiService.SkillDetailResponse?
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var showingAddEvidenceSheet = false
    
    var body: some View {
        ZStack {
            // Background
            Color.matterNavy
                .ignoresSafeArea()
            
            // Decorative gradient
            VStack {
                Circle()
                    .fill(Color.matterOrange.opacity(0.08))
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: -100)
                
                Spacer()
                
                Circle()
                    .fill(Color.matterOrange.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .offset(x: -120, y: 100)
            }
            .ignoresSafeArea()
            
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if let detail = skillDetail {
                ScrollView {
                    VStack(spacing: 20) {
                        // Skill Overview Card
                        SkillOverviewCard(
                            skillName: skillName,
                            skillCategory: skillCategory,
                            description: detail.skill.description,
                            status: detail.status
                        )
                        
                        // Evidence Section
                        if detail.evidence.isEmpty {
                            emptyEvidenceView
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Evidence (\(detail.evidence.count))")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button {
                                        showingAddEvidenceSheet = true
                                    } label: {
                                        Label("Add", systemImage: "plus.circle.fill")
                                            .font(.subheadline)
                                            .foregroundColor(.matterOrange)
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                ForEach(detail.evidence) { evidence in
                                    EvidenceCardView(evidence: evidence)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
                .refreshable {
                    await refreshSkillDetail()
                }
            }
        }
        .navigationTitle(skillName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(skillName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddEvidenceSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.matterOrange)
                }
            }
        }
        .task {
            await loadSkillDetail()
        }
        .sheet(isPresented: $showingAddEvidenceSheet) {
            AddEvidenceSheet(skillId: skillId)
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            
            Text("Loading skill details...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.matterOrange)
            
            Text("Unable to Load Skill")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                Task { await loadSkillDetail() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.matterOrange)
                    .cornerRadius(10)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
    }
    
    private var emptyEvidenceView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.matterOrange.opacity(0.6))
            
            Text("No Evidence Yet")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Submit evidence to demonstrate this skill.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                showingAddEvidenceSheet = true
            } label: {
                Label("Add Evidence", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.matterOrange)
                    .cornerRadius(10)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadSkillDetail() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await ApiService.shared.me()
            skillDetail = try await ApiService.shared.studentSkill(studentId: user.id, skillId: skillId)
        } catch {
            errorMessage = error.localizedDescription
            skillDetail = nil
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshSkillDetail() async {
        isRefreshing = true
        await loadSkillDetail()
    }
}

// MARK: - Skill Overview Card

struct SkillOverviewCard: View {
    let skillName: String
    let skillCategory: SkillCategory
    let description: String?
    let status: SkillStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(skillName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.matterNavy)
                
                Spacer()
                
                Text(skillCategory.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background((skillCategory == .technical ? Color.matterOrange : Color.green).opacity(0.12))
                    .foregroundColor(skillCategory == .technical ? .matterOrange : .green)
                    .clipShape(Capsule())
            }
            
            if let description = description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Divider()
                .background(Color.matterNavy.opacity(0.1))
            
            HStack {
                Label("Status", systemImage: "circle.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                StatusBadge(status: status)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.matterNavy.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
   
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SkillDetailView(
            skillId: "test-skill-id",
            skillName: "Swift Programming",
            skillCategory: .technical
        )
    }
}


