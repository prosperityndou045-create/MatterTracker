//
//  EvidenceReview.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.

import SwiftUI

struct EvidenceReviewView: View {
    let skill: Skill

    let evidence = [
        Evidence(
            title: "Communication Presentation",
            type: "PDF",
            description: "Student presentation demonstrating clear communication, explanation of ideas and confidence when presenting.",
            date: "02 September 2026"
        ),
        Evidence(
            title: "Team Project",
            type: "Image",
            description: "Evidence from a collaborative team project demonstrating teamwork, contribution and coordination with other students.",
            date: "01 September 2026"
        ),
        Evidence(
            title: "Food Review App",
            type: "Project",
            description: "Student project demonstrating how the student planned, developed and presented an application.",
            date: "30 August 2026"
        ),
        Evidence(
            title: "Swift Calculator",
            type: "Code Sample",
            description: "Code sample demonstrating the student's ability to write, explain and organize Swift code.",
            date: "29 August 2026"
        ),
        Evidence(
            title: "LTC Challenge",
            type: "Challenge",
            description: "Completed LTC challenge showing the student's ability to solve problems and apply learned skills.",
            date: "28 August 2026"
        ),
        Evidence(
            title: "Project Demonstration",
            type: "Video",
            description: "Video demonstrating the student's project and explaining the decisions made during development.",
            date: "27 August 2026"
        ),
        Evidence(
            title: "GitHub Repository",
            type: "GitHub",
            description: "Student's GitHub repository containing project source code and development work.",
            date: "26 August 2026"
        ),
        Evidence(
            title: "Facilitator Feedback",
            type: "Feedback",
            description: "Feedback provided by the facilitator based on the student's participation, performance and demonstrated skills.",
            date: "25 August 2026"
        )
    ]

    var body: some View {
        List {
            Section("Selected Skill") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(skill.name)
                        .font(.headline)

                    Text(skill.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }

            Section("Evidence Submitted") {
                ForEach(evidence) { item in
                    NavigationLink {
                        AssessmentView(
                            skill: skill,
                            evidence: item
                        )
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: iconForEvidence(item.type))
                                .font(.title2)
                                .frame(width: 35)
                                .foregroundStyle(.blue)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.title)
                                    .fontWeight(.semibold)

                                Text(item.type)
                                    .font(.caption)
                                    .fontWeight(.medium)

                                Text(item.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Text(item.date)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                }
            }

            Section("Skill Demonstration") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("What the facilitator should look for")
                        .font(.headline)

                    Text(skillEvidenceDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }

            Section("Evidence Categories") {
                EvidenceCategoryRow(
                    title: "Projects",
                    description: "Review projects created and submitted by the student.",
                    icon: "folder.fill"
                )

                EvidenceCategoryRow(
                    title: "Code Samples",
                    description: "Review uploaded code and how the student applies technical skills.",
                    icon: "chevron.left.forwardslash.chevron.right"
                )

                EvidenceCategoryRow(
                    title: "LTC Challenges",
                    description: "Review completed challenges and problem-solving activities.",
                    icon: "flag.fill"
                )

                EvidenceCategoryRow(
                    title: "GitHub Repositories",
                    description: "Review source code, commits and project development work.",
                    icon: "chevron.left.forwardslash.chevron.right"
                )

                EvidenceCategoryRow(
                    title: "Videos",
                    description: "Review demonstrations and explanations provided by the student.",
                    icon: "video.fill"
                )

                EvidenceCategoryRow(
                    title: "Facilitator Feedback",
                    description: "Review observations and feedback recorded by facilitators.",
                    icon: "text.bubble.fill"
                )
            }
        }
        .navigationTitle("Evidence Review")
    }

    private func iconForEvidence(_ type: String) -> String {
        switch type {
        case "PDF":
            return "doc.text.fill"
        case "Image":
            return "photo.fill"
        case "Project":
            return "folder.fill"
        case "Code Sample":
            return "chevron.left.forwardslash.chevron.right"
        case "Challenge":
            return "flag.fill"
        case "Video":
            return "video.fill"
        case "GitHub":
            return "chevron.left.forwardslash.chevron.right"
        case "Feedback":
            return "text.bubble.fill"
        default:
            return "doc.fill"
        }
    }

    private var skillEvidenceDescription: String {
        switch skill.name {
        case "Communication":
            return "Look for clear explanations, presentations, documentation, videos and the student's ability to communicate ideas effectively."

        case "Teamwork":
            return "Look for evidence of collaboration, contribution to team projects, cooperation with others and constructive participation."

        case "Problem Solving":
            return "Look for how the student approaches challenges, identifies problems, develops solutions and applies technical knowledge."

        case "Leadership":
            return "Look for initiative, responsibility, decision-making, supporting others and taking ownership of tasks."

        default:
            return "Review the submitted evidence to determine how the student demonstrates this skill in practical situations."
        }
    }
}

struct EvidenceCategoryRow: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 35)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 5)
    }
}

