//
//  SkillFrameworkDetailView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillFrameworkDetailView: View {
    
    let skill: Skill
    
    @State private var relatedCandidates: [PublicCandidateSummary] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                // MARK: - Skill Header
                
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    Image(systemName: skillIcon)
                        .font(.largeTitle)
                        .foregroundColor(.matterOrange)
                    
                    Text(skill.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    if let description = skill.description, !description.isEmpty {
                        Text(description)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Category badge
                    HStack {
                        Image(systemName: skill.category == .technical ? "cpu" : "heart")
                            .font(.caption)
                        Text(skill.category.rawValue.capitalized)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.matterOrange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.matterOrange.opacity(0.12))
                    .clipShape(Capsule())
                }
                
                Divider()
                    .background(Color.matterNavy.opacity(0.2))
                
                // MARK: - What Demonstrates This Skill
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Text("What Demonstrates This Skill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    Text(skillExplanation)
                        .foregroundStyle(.secondary)
                }
                
                // MARK: - Evidence Examples
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    Text("Examples of Evidence")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    ForEach(evidenceExamples, id: \.title) { evidence in
                        EvidenceExample(
                            icon: evidence.icon,
                            title: evidence.title,
                            description: evidence.description
                        )
                    }
                }
                
                // MARK: - Verification
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Label(
                        "Evidence is verified",
                        systemImage: "checkmark.seal.fill"
                    )
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                    
                    Text("""
                    Evidence submitted by a student can be reviewed and verified by an MCRI facilitator before it contributes to the student's demonstrated skills.
                    """)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color.matterNavy.opacity(0.05)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
                
                // MARK: - Related Candidates
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    Text("Candidates with this skill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    } else if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if relatedCandidates.isEmpty {
                        Text("No candidates have demonstrated this skill yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(relatedCandidates.prefix(5)) { candidate in
                            NavigationLink {
                                CandidateProfileView(candidateId: candidate.id)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(candidate.firstName) \(candidate.lastName)")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
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
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundColor(.matterOrange)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        if relatedCandidates.count > 5 {
                            Text("And \(relatedCandidates.count - 5) more candidates...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Skill")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await loadRelatedCandidates()
        }
        .task {
            await loadRelatedCandidates()
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadRelatedCandidates() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Search for candidates with this skill
            relatedCandidates = try await ApiService.shared.publicCandidates(
                skill: skill.name
            )
        } catch {
            errorMessage = "Could not load related candidates"
            relatedCandidates = []
        }
        
        isLoading = false
    }
    
    // MARK: - Skill Icon
    
    private var skillIcon: String {
        switch skill.name.lowercased() {
        case let name where name.contains("swift"):
            return "swift"
            
        case let name where name.contains("programming") || name.contains("fundamentals"):
            return "chevron.left.forwardslash.chevron.right"
            
        case let name where name.contains("git") || name.contains("github"):
            return "arrow.triangle.branch"
            
        case let name where name.contains("api"):
            return "network"
            
        case let name where name.contains("database"):
            return "cylinder"
            
        case let name where name.contains("communication"):
            return "bubble.left.and.bubble.right"
            
        case let name where name.contains("teamwork") || name.contains("collaboration"):
            return "person.3"
            
        case let name where name.contains("problem") || name.contains("solving"):
            return "lightbulb"
            
        case let name where name.contains("leadership"):
            return "person.badge.key"
            
        case let name where name.contains("time") || name.contains("management"):
            return "clock"
            
        default:
            return "star"
        }
    }
    
    // MARK: - Skill Explanation
    
    private var skillExplanation: String {
        switch skill.name.lowercased() {
        case let name where name.contains("swift"):
            return """
            Demonstrates the ability to write, understand and maintain applications using Swift, including variables, functions, control flow, collections, structures and classes.
            """
            
        case let name where name.contains("programming") || name.contains("fundamentals"):
            return """
            Demonstrates an understanding of core programming concepts such as variables, conditions, loops, functions, arrays and dictionaries.
            """
            
        case let name where name.contains("git") || name.contains("github"):
            return """
            Demonstrates the ability to use Git and GitHub to manage source code, maintain repositories and collaborate on software projects.
            """
            
        case let name where name.contains("api"):
            return """
            Demonstrates an understanding of how applications communicate with external services and exchange data through APIs.
            """
            
        case let name where name.contains("database"):
            return """
            Demonstrates the ability to store, retrieve and manage application data using database technologies.
            """
            
        case let name where name.contains("communication"):
            return """
            Demonstrates the ability to clearly explain ideas, technical decisions and project outcomes to different audiences.
            """
            
        case let name where name.contains("teamwork") || name.contains("collaboration"):
            return """
            Demonstrates the ability to collaborate with others, contribute to shared goals and work effectively within a team.
            """
            
        case let name where name.contains("problem") || name.contains("solving"):
            return """
            Demonstrates the ability to analyse problems, identify possible solutions and implement effective approaches.
            """
            
        case let name where name.contains("leadership"):
            return """
            Demonstrates the ability to take responsibility, guide others and contribute toward achieving a shared goal.
            """
            
        case let name where name.contains("time") || name.contains("management"):
            return """
            Demonstrates the ability to plan tasks, prioritise work and complete responsibilities within expected timelines.
            """
            
        default:
            return skill.description ?? "Demonstrates proficiency in this skill through practical evidence and verification."
        }
    }
    
    // MARK: - Evidence Examples
    
    private var evidenceExamples: [(icon: String, title: String, description: String)] {
        
        switch skill.name.lowercased() {
            
        case let name where name.contains("swift"):
            return [
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Swift code demonstrating programming concepts."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A completed application built using Swift."
                ),
                (
                    "arrow.triangle.branch",
                    "GitHub Repository",
                    "A repository containing the student's Swift development work."
                ),
                (
                    "doc.text",
                    "Assessment",
                    "An assessment demonstrating knowledge of Swift."
                )
            ]
            
        case let name where name.contains("git") || name.contains("github"):
            return [
                (
                    "arrow.triangle.branch",
                    "GitHub Repository",
                    "A public repository containing the student's development work."
                ),
                (
                    "clock.arrow.circlepath",
                    "Commit History",
                    "Evidence showing how the student manages changes to their code."
                ),
                (
                    "arrow.triangle.pull",
                    "Pull Request",
                    "Evidence of collaboration and contribution to a project."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A project managed using Git and GitHub."
                )
            ]
            
        case let name where name.contains("communication"):
            return [
                (
                    "play.rectangle.fill",
                    "Video Demonstration",
                    "A presentation explaining a project or technical concept."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback evaluating the student's communication."
                ),
                (
                    "folder.fill",
                    "Project Presentation",
                    "Evidence of clearly explaining a completed project."
                )
            ]
            
        case let name where name.contains("teamwork") || name.contains("collaboration"):
            return [
                (
                    "person.3.fill",
                    "Group Project",
                    "Evidence showing contribution to a collaborative project."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback on collaboration and teamwork."
                ),
                (
                    "person.2.fill",
                    "Peer Feedback",
                    "Feedback from other members of the project team."
                )
            ]
            
        case let name where name.contains("problem") || name.contains("solving"):
            return [
                (
                    "flag.fill",
                    "LTC Challenge",
                    "A programming challenge demonstrating analytical thinking."
                ),
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Code demonstrating how a problem was analysed and solved."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A practical project demonstrating solution development."
                )
            ]
            
        default:
            return [
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Code demonstrating the skill."
                ),
                (
                    "flag.fill",
                    "LTC Challenge",
                    "A challenge demonstrating the skill."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A project demonstrating the skill."
                ),
                (
                    "play.rectangle.fill",
                    "Video Demonstration",
                    "A video demonstrating the skill."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback from an MCRI facilitator."
                ),
                (
                    "doc.text",
                    "Assessment",
                    "An assessment demonstrating the skill."
                )
            ]
        }
    }
}

// MARK: - Evidence Example View

struct EvidenceExample: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.matterOrange)
                .frame(width: 30)
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            Color.matterNavy.opacity(0.05)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SkillFrameworkDetailView(
            skill: Skill(
                id: "1",
                name: "Swift",
                category: .technical,
                description: "iOS and macOS development using Swift programming language",
                createdAt: Date()
            )
        )
    }
}
