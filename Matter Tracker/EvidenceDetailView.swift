//
//  EvidenceDetailView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct EvidenceDetailView: View {

    let evidence: Evidence

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                Text(evidence.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack {

                    Text(evidence.type.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(evidence.status.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                Divider()

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text("Description")
                        .font(.headline)

                    Text(evidence.description)
                        .foregroundStyle(.secondary)
                }

                if let reviewer = evidence.reviewer {

                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {

                        Text("Verification")
                            .font(.headline)

                        Label(
                            "Verified by \(reviewer)",
                            systemImage: "checkmark.seal.fill"
                        )

                        if let role = evidence.reviewerRole {

                            Text(role)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Text(
                            "Status: \(evidence.status.rawValue)"
                        )
                        .font(.caption)
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

                if let attachmentURL = evidence.attachmentURL,
                   let url = URL(string: attachmentURL) {

                    Link(destination: url) {

                        HStack {

                            Image(
                                systemName: "arrow.up.right.square"
                            )

                            Text("View Evidence")

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
            }
            .padding()
        }
        .navigationTitle("Evidence")
        .navigationBarTitleDisplayMode(.inline)
    }
}
