//
//  ManagerReportsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

//
//  ManagerReportsView 2.swift
//  matter hackathon
//
//  Created by Tana on 5/9/2026.
//

import SwiftUI
import Charts

struct ManagerReportsView: View {

    let selectedCohort: String

    var data: CohortInsightData? {
        sampleCohortData[selectedCohort]
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header

                VStack(alignment: .leading, spacing: 6) {

                    Text("Cohort Report")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(selectedCohort)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                if let data = data {

                    // MARK: - Overview

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.bold)

                        HStack(spacing: 16) {

                            ReportStatCard(
                                title: "Students",
                                value: "\(data.students)",
                                icon: "person.3.fill"
                            )

                            ReportStatCard(
                                title: "Evidence",
                                value: "\(data.evidenceSubmitted)",
                                icon: "doc.text.fill"
                            )

                            ReportStatCard(
                                title: "Pending",
                                value: "\(data.pendingReviews)",
                                icon: "clock.fill"
                            )
                        }
                    }

                    // MARK: - Skill Performance

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Skill Performance")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Cohort performance across demonstrated skills")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Chart {

                            LineMark(
                                x: .value("Skill", "Communication"),
                                y: .value("Score", data.communication)
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Skill", "Teamwork"),
                                y: .value("Score", data.teamwork)
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Skill", "Problem Solving"),
                                y: .value("Score", data.problemSolving)
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Skill", "Loops"),
                                y: .value("Score", data.loops)
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Skill", "Functions"),
                                y: .value("Score", data.functions)
                            )
                            .interpolationMethod(.catmullRom)

                            PointMark(
                                x: .value("Skill", "Communication"),
                                y: .value("Score", data.communication)
                            )

                            PointMark(
                                x: .value("Skill", "Teamwork"),
                                y: .value("Score", data.teamwork)
                            )

                            PointMark(
                                x: .value("Skill", "Problem Solving"),
                                y: .value("Score", data.problemSolving)
                            )

                            PointMark(
                                x: .value("Skill", "Loops"),
                                y: .value("Score", data.loops)
                            )

                            PointMark(
                                x: .value("Skill", "Functions"),
                                y: .value("Score", data.functions)
                            )
                        }
                        .chartYScale(domain: 0...100)
                        .frame(height: 280)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .shadow(
                        color: .black.opacity(0.08),
                        radius: 8,
                        y: 4
                    )

                    // MARK: - Key Insights

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Key Insights")
                            .font(.title2)
                            .fontWeight(.bold)

                        InsightRow(
                            title: "Skills Demonstrated",
                            value: "\(data.skillsDemonstrated)",
                            icon: "checkmark.circle.fill"
                        )

                        InsightRow(
                            title: "Evidence Submitted",
                            value: "\(data.evidenceSubmitted)",
                            icon: "doc.text.fill"
                        )

                        InsightRow(
                            title: "Pending Reviews",
                            value: "\(data.pendingReviews)",
                            icon: "exclamationmark.circle.fill"
                        )
                    }

                } else {

                    Text("No report data available for this cohort.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Reports")
    }
}
