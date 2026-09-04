//
//  ManagerHomeView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerHomeView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Monitor student progress and program insights")
                            .foregroundStyle(.secondary)
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
                                value: "45",
                                icon: "person.3.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Skills Demonstrated",
                                value: "128",
                                icon: "checkmark.seal.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Evidence Submitted",
                                value: "237",
                                icon: "doc.fill"
                            )
                            
                            ManagerStatCard(
                                title: "Pending Reviews",
                                value: "18",
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
                            ManagerStudentsView()
                        } label: {
                            ManagerMenuCard(
                                icon: "person.2.fill", title: "View Students",
                                description: "View students and their progress"
                            )
                        }
                        
                        NavigationLink {
                            ManagerSkillsView()
                        } label: {
                            ManagerMenuCard(
                                icon: "chart.bar.fill", title: "Skills Data",
                                description: "View the most and least demonstrated skills"
                            )
                        }
                        
                        NavigationLink {
                            ManagerEvidenceView()
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
                            ManagerReportsView()
                        } label: {
                            ManagerMenuCard(
                                icon: "chart.line.uptrend.xyaxis", title: "Generate Reports",
                                description: "View cohort progress and performance reports"
                            )
                        }
                        
                        NavigationLink {
                            ManagerInsightsView()
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
            .navigationTitle("Manager")
        }
       
    }
}
#Preview {
    ManagerHomeView()
       
}
