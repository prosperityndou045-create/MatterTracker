//
//  ManagerEvidenceView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI
import SwiftUI

struct ManagerEvidenceView: View {
    
    struct Evidence {
        let student: String
        let cohort: String
        let skill: String
        let evidence: String
        let status: String
    }
    
    let selectedCohort: String
    
    let evidence = [
        // Cohort 1
        Evidence(
            student: "Tendai Moyo",
            cohort: "Cohort 1",
            skill: "Communication",
            evidence: "Presentation Video",
            status: "Verified"
        ),
        Evidence(
            student: "Rudo Chikore",
            cohort: "Cohort 1",
            skill: "Functions",
            evidence: "GitHub Project",
            status: "Pending"
        ),
        Evidence(
            student: "Brian Dube",
            cohort: "Cohort 1",
            skill: "Teamwork",
            evidence: "Team Project",
            status: "Verified"
        ),
        Evidence(
            student: "Nyasha Ncube",
            cohort: "Cohort 1",
            skill: "Loops",
            evidence: "Code Sample",
            status: "Pending"
        ),
        
        // Cohort 2
        Evidence(
            student: "Tatenda Zhou",
            cohort: "Cohort 2",
            skill: "Problem Solving",
            evidence: "LTC Challenge",
            status: "Verified"
        ),
        Evidence(
            student: "Shamiso Mlambo",
            cohort: "Cohort 2",
            skill: "Communication",
            evidence: "Presentation",
            status: "Pending"
        ),
        Evidence(
            student: "Blessing Chirwa",
            cohort: "Cohort 2",
            skill: "Teamwork",
            evidence: "Group Project",
            status: "Verified"
        )
    ]
    
    var filteredEvidence: [Evidence] {
        evidence.filter {
            $0.cohort == selectedCohort
        }
    }
    
    var verifiedCount: Int {
        filteredEvidence.filter {
            $0.status == "Verified"
        }.count
    }
    
    var pendingCount: Int {
        filteredEvidence.filter {
            $0.status == "Pending"
        }.count
    }
    
    var body: some View {
        List {
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Evidence Submitted")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(filteredEvidence.count)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Pending Reviews")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(pendingCount)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Evidence") {
                ForEach(filteredEvidence, id: \.student) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(item.student)
                                    .font(.headline)
                                
                                Text(item.skill)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(item.status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    item.status == "Verified"
                                    ? Color.green.opacity(0.15)
                                    : Color.orange.opacity(0.15)
                                )
                                .clipShape(Capsule())
                        }
                        
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundStyle(.secondary)
                            
                            Text(item.evidence)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("\(selectedCohort) Evidence")
    }
}

#Preview {
    NavigationStack {
        ManagerEvidenceView(selectedCohort: "Cohort 1")
    }
}
