//
//  CandidateProfileView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct CandidateProfileView: View {
    let profile: StudentProfile
    var body: some View {
        
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                // MARK: Candidate Header
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    
                    HStack {
                        
                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {
                            
                            Text(profile.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(profile.cohort)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VerificationBadge()
                    }
                    
                    Text(profile.bio)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                    
                    Text("Profile ID: \(profile.profileID)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // MARK: Progress
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    
                    HStack {
                        
                        Text("Overall Progress")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(profile.completionPercent)%")
                            .fontWeight(.bold)
                    }
                    
                    ProgressView(
                        value: Double(
                            profile.completionPercent
                        ),
                        total: 100
                    )
                    
                    Text(
                        "\(profile.demonstratedCount) of \(profile.skills.count) skills demonstrated"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color.secondary.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
                
                // MARK: Summary
                
                HStack(spacing: 12) {
                    
                    ProfileSummaryCard(
                        value: "\(profile.demonstratedCount)",
                        title: "Skills"
                    )
                    
                    ProfileSummaryCard(
                        value: "\(profile.verifiedEvidenceCount)",
                        title: "Verified Evidence"
                    )
                    
                    ProfileSummaryCard(
                        value: "\(profile.projects.count)",
                        title: "Projects"
                    )
                }
                
                // MARK: Technical Skills
                
                let technicalSkills = profile.skills.filter {
                    $0.category == .technical
                }
                
                if !technicalSkills.isEmpty {
                    
                    ProfileSectionTitle(
                        title: "Technical Skills"
                    )
                    
                    ForEach(technicalSkills) { skill in
                        
                        NavigationLink {
                            
//                            SkillDetailView(
//                                skill: skill
//                            )
                            
                        } label: {
                            
                            SkillRow(
                                skill: skill
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: Essential Skills
                
                let essentialSkills = profile.skills.filter {
                    $0.category == .essential
                }
                
                if !essentialSkills.isEmpty {
                    
                    ProfileSectionTitle(
                        title: "Essential Skills"
                    )
                    
                    ForEach(essentialSkills) { skill in
                        
                        NavigationLink {
                            
//                            SkillDetailView(
//                                skill: skill
//                            )
                            
                        } label: {
                            
                            SkillRow(
                                skill: skill
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: Projects
                
                if !profile.projects.isEmpty {
                    
                    ProfileSectionTitle(
                        title: "Projects"
                    )
                    
                    ForEach(profile.projects) { project in
                        
                        NavigationLink {
                            
//                            ProjectDetailView(
//                                project: project
//                            )
                            
                        } label: {
                            
                            ProjectCard(
                                project: project
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: Achievements
                
                if !profile.achievements.isEmpty {
                    
                    ProfileSectionTitle(
                        title: "Achievements"
                    )
                    
                    ForEach(profile.achievements) { achievement in
                        
                        AchievementCard(
                            achievement: achievement
                        )
                    }
                }
                
                // MARK: Verification
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    
                    Label(
                        "Public profile verified",
                        systemImage: "checkmark.seal.fill"
                    )
                    .fontWeight(.semibold)
                    
                    Text("""
                    The information displayed here is intended
                    for public viewing. Private facilitator notes
                    and non-public evidence are not displayed.
                    """)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color.secondary.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
            }
            .padding()
        }
        .navigationTitle("Candidate Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileSummaryCard: View {
    
    let value: String
    let title: String
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}

struct ProfileSectionTitle: View {
    
    let title: String
    
    var body: some View {
        
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 5)
    }
}

struct ProjectCard: View {
    
    let project: Project
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            
            HStack {
                
                Image(systemName: "folder.fill")
                
                Text(project.name)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(project.description)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(
                project.technologies.joined(separator: " • ")
            )
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
}

struct AchievementCard: View {
    
    let achievement: Achievement
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            Image(systemName: "trophy.fill")
                .font(.title2)
                .frame(width: 35)
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(achievement.title)
                    .fontWeight(.semibold)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(achievement.type.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
}
