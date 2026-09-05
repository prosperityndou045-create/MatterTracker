//
//  Assessment.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct AssessmentView: View {

    let skill: Skill
    let evidence: Evidence

    @State private var decision = ""
    @State private var feedback = ""
    @State private var showConfirmation = false
    @State private var assessmentCompleted = false

    var body: some View {

        Form {

            // MARK: - Evidence
            Section("Evidence") {

                VStack(alignment: .leading, spacing: 8) {

                    Text(evidence.title)
                        .font(.headline)

                    Text(evidence.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Type")

                    Spacer()

                    Label(
                        evidence.type,
                        systemImage: iconForType(evidence.type)
                    )
                    .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Submitted")

                    Spacer()

                    Text(evidence.date)
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: - Assessment
            Section("Assessment") {

                Button {
                    decision = "Approved"
                } label: {

                    HStack {

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Approve Evidence")

                        Spacer()

                        if decision == "Approved" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }

                Button {
                    decision = "Changes Required"
                } label: {

                    HStack {

                        Image(systemName: "arrow.clockwise.circle.fill")
                            .foregroundStyle(.orange)

                        Text("Request Changes")

                        Spacer()

                        if decision == "Changes Required" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }

            // MARK: - Selected Decision
            if !decision.isEmpty {

                Section("Selected Decision") {

                    HStack {

                        Image(
                            systemName:
                                decision == "Approved"
                                ? "checkmark.circle.fill"
                                : "arrow.clockwise.circle.fill"
                        )
                        .foregroundStyle(
                            decision == "Approved"
                            ? .green
                            : .orange
                        )

                        Text(decision)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                }
            }

            // MARK: - Facilitator Feedback
            Section("Facilitator Feedback") {

                TextEditor(text: $feedback)
                    .frame(height: 120)

                Text(
                    decision == "Changes Required"
                    ? "Explain what the student needs to improve or resubmit."
                    : "Explain what the student did well and provide any additional feedback."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            // MARK: - Submit Assessment
            Section {

                Button {

                    showConfirmation = true

                } label: {

                    Text("Submit Assessment")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .disabled(
                    decision.isEmpty ||
                    feedback
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
            }
        }

        .navigationTitle("Assessment")

        // MARK: - Confirmation Alert
        .alert(
            "Assessment Submitted",
            isPresented: $showConfirmation
        ) {

            Button("OK") {
                assessmentCompleted = true
            }

        } message: {

            Text(
                "\(evidence.type) evidence for \(skill.name) has been marked as \(decision)."
            )
        }

        // MARK: - Assessment Complete
        .navigationDestination(
            isPresented: $assessmentCompleted
        ) {

            AssessmentCompleteView(
                decision: decision,
                feedback: feedback
            )
        }
    }

    // MARK: - Evidence Type Icon
    private func iconForType(_ type: String) -> String {

        switch type.lowercased() {

        case "pdf", "document":
            return "doc.text.fill"

        case "image", "photo":
            return "photo.fill"

        case "video":
            return "video.fill"

        case "code", "code sample":
            return "chevron.left.forwardslash.chevron.right"

        case "github", "repository":
            return "chevron.left.forwardslash.chevron.right"

        case "project":
            return "folder.fill"

        case "feedback":
            return "text.bubble.fill"

        case "ltc", "challenge":
            return "flag.fill"

        default:
            return "doc.fill"
        }
    }
}
