//
//  ManagerHomeView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerHomeView: View {
    @State private var selectedCohort = "All Cohorts"

    let cohorts = [
        "All Cohorts",
        "Cohort 1",
        "Cohort 2",
        "Cohort 3",
        "Cohort 4",
        "Cohort 5",
        "Cohort 6",
        "Cohort 7",
        "Cohort 8"
    ]

    let cohortData = [
        "All Cohorts": (students: 57, skills: 121, evidence: 146, pending: 40),
        "Cohort 1": (students: 4, skills: 10, evidence: 18, pending: 5),
        "Cohort 2": (students: 8, skills: 15, evidence: 19, pending: 5),
        "Cohort 3": (students: 10, skills: 15, evidence: 18, pending: 5),
        "Cohort 4": (students: 13, skills: 28, evidence: 26, pending: 5),
        "Cohort 5": (students: 4, skills: 14, evidence: 15, pending: 5),
        "Cohort 6": (students: 2, skills: 18, evidence: 17, pending: 5),
        "Cohort 7": (students: 9, skills: 15, evidence: 19, pending: 5),
        "Cohort 8": (students: 8, skills: 16, evidence: 14, pending: 5)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Manager")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Monitor student progress and program insights")
                            .foregroundStyle(.secondary)
                    }
                    
                    // MARK: - Cohort Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Cohort")
                            .font(.headline)

                        Picker("Cohort", selection: $selectedCohort) {
                            ForEach(cohorts, id: \.self) { cohort in
                                Text(cohort)
                                    .tag(cohort)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    // MARK: - Overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            
                            ManagerStatCard(
                                title: "Students",
                                value: "\(cohortData[selectedCohort]?.students ?? 0)",
                                icon: "person.3.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Skills Demonstrated",
                                value: "\(cohortData[selectedCohort]?.skills ?? 0)",
                                icon: "checkmark.seal.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Evidence Submitted",
                                value: "\(cohortData[selectedCohort]?.evidence ?? 0)",
                                icon: "doc.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Pending Reviews",
                                value: "\(cohortData[selectedCohort]?.pending ?? 0)",
                                icon: "clock.fill"
                            )
                        }
                    }
                    
                    // MARK: - Cohort
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cohort")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NavigationLink {
                            ManagerStudentsView(selectedCohort: selectedCohort)
                        } label: {
                            ManagerMenuCard(
                                icon: "person.2.fill", title: "View Students",
                                description: "View students and their progress"
                            )
                        }
                        
//                        NavigationLink {
//                            ManagerSkillsView(selectedCohort: selectedCohort)
//                        } label: {
//                            ManagerMenuCard(
//                                icon: "chart.bar.fill", title: "Skills Data",
//                                description: "View the most and least demonstrated skills"
//                            )
//                        }
                        
                        NavigationLink {
                            ManagerEvidenceView(selectedCohort: selectedCohort)
                        } label: {
                            ManagerMenuCard(
                                icon: "doc.text.fill", title: "Evidence Data",
                                description: "View submitted evidence and pending reviews"
                            )
                        }
                    }
                    
                    // MARK: - Reports
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reports & Insights")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NavigationLink {
                            ManagerReportsView(selectedCohort: selectedCohort)
                        } label: {
                            ManagerMenuCard(
                                icon: "chart.line.uptrend.xyaxis", title: "Generate Reports",
                                description: "View cohort progress and performance reports"
                            )
                        }
                        
                        NavigationLink {
                            ManagerInsightsView(selectedCohort: selectedCohort)
                        } label: {
                            ManagerMenuCard(
                                icon: "lightbulb.fill", title: "Program Insights",
                                description: "Identify trends and areas that need attention"
                            )
                        }
                    }
                }
                .padding()
            }
           // .navigationTitle("Manager")
        }
       
    }
}
#Preview {
    ManagerHomeView()
       
}
