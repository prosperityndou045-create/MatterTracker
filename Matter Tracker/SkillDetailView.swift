//
//  SkillDetailView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct SkillDetailView: View {

    let skill: Skill

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                Text(skill.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SkillStatusBadge(
                    status: skill.status
                )

                Text(skill.description)
                    .foregroundStyle(.secondary)

                Divider()

                Text("Evidence")
                    .font(.title2)
                    .fontWeight(.bold)

                if skill.evidence.isEmpty {

                    Text("No public evidence has been attached.")
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(skill.evidence) { evidence in

                        NavigationLink {

                            EvidenceDetailView(
                                evidence: evidence
                            )

                        } label: {

                            EvidenceRow(
                                evidence: evidence
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Skill")
        .navigationBarTitleDisplayMode(.inline)
    }
}
