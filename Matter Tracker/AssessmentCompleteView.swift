//
//  AssessmentCompleteView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct AssessmentCompleteView: View {
    let decision: String
    let feedback: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 25) {

            Image(
                systemName: decision == "Approved"
                    ? "checkmark.circle.fill"
                    : "arrow.clockwise.circle.fill"
            )
            .font(.system(size: 80))
            .foregroundStyle(
                decision == "Approved" ? .green : .orange
            )

            Text("Assessment Submitted")
                .font(.title)
                .fontWeight(.bold)

            Text(
                decision == "Approved"
                    ? "The evidence has been approved."
                    : "Changes have been requested from the student."
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)

            HStack {
                Image(
                    systemName: decision == "Approved"
                        ? "checkmark.circle.fill"
                        : "arrow.clockwise.circle.fill"
                )
                .foregroundStyle(
                    decision == "Approved" ? .green : .orange
                )

                Text(decision)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)

            VStack(alignment: .leading, spacing: 10) {
                Text("Facilitator Feedback")
                    .font(.headline)

                Text(feedback)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("Complete")
    }
}
