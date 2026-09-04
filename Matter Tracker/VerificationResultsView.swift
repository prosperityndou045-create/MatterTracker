//
//  VerificationResultsView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct VerificationResultView: View {

    let profileID: String

    @Environment(\.dismiss)
    private var dismiss

    private var profile: StudentProfile? {

        let cleanedID = profileID
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .uppercased()

        return MockData.candidates.first {
            $0.profileID.uppercased() == cleanedID
        }
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    if let profile {

                        // MARK: Verified

                        VStack(
                            alignment: .center,
                            spacing: 12
                        ) {

                            Image(
                                systemName: "checkmark.seal.fill"
                            )
                            .font(.system(size: 65))

                            Text("VERIFIED")
                                .font(.title)
                                .fontWeight(.bold)

                            Text("""
                            This candidate profile is authentic
                            and currently available for public viewing.
                            """)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        }
                        .frame(
                            maxWidth: .infinity
                        )

                        Divider()

                        VerificationInfoRow(
                            title: "Candidate",
                            value: profile.name
                        )

                        VerificationInfoRow(
                            title: "Profile ID",
                            value: profile.profileID
                        )

                        VerificationInfoRow(
                            title: "Cohort",
                            value: profile.cohort
                        )

                        VerificationInfoRow(
                            title: "Skills Demonstrated",
                            value: "\(profile.demonstratedCount)"
                        )

                        VerificationInfoRow(
                            title: "Verified Evidence",
                            value: "\(profile.verifiedEvidenceCount)"
                        )

                        NavigationLink {

                            CandidateProfileView(
                                profile: profile
                            )

                        } label: {

                            Text("View Candidate Profile")
                                .frame(
                                    maxWidth: .infinity
                                )
                                .padding()
                                .background(
                                    Color.primary
                                )
                                .foregroundStyle(
                                    Color(.systemBackground)
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 12
                                    )
                                )
                        }

                    } else {

                        // MARK: Invalid

                        VStack(
                            alignment: .center,
                            spacing: 12
                        ) {

                            Image(
                                systemName: "xmark.circle"
                            )
                            .font(.system(size: 65))

                            Text("PROFILE NOT FOUND")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("""
                            No public candidate profile could
                            be found for \(profileID).
                            """)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Verification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct VerificationInfoRow: View {

    let title: String
    let value: String

    var body: some View {

        HStack {

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}
