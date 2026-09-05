//
//  CandidateDirectoryView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct CandidateDirectoryView: View {
    
    let candidates: [StudentProfile]
    
    @State private var searchText = ""
    @State private var selectedCohort = "All"
    @State private var selectedSkill = "All"
    
    private var cohorts: [String] {
        ["All"] + Array(
            Set(candidates.map { $0.cohort })
        ).sorted()
    }
    
    private var skills: [String] {
        let allSkills = candidates.flatMap { candidate in
            candidate.skills.map { $0.name }
        }
        
        return ["All"] + Array(
            Set(allSkills)
        ).sorted()
    }
    
    private var filteredCandidates: [StudentProfile] {
        candidates.filter { candidate in
            
            let matchesSearch =
                searchText.isEmpty ||
                candidate.name.localizedCaseInsensitiveContains(searchText) ||
                candidate.profileID.localizedCaseInsensitiveContains(searchText)
            
            let matchesCohort =
                selectedCohort == "All" ||
                candidate.cohort == selectedCohort
            
            let matchesSkill =
                selectedSkill == "All" ||
                candidate.skills.contains {
                    $0.name == selectedSkill
                }
            
            return matchesSearch &&
            matchesCohort &&
            matchesSkill &&
            candidate.isPublic
        }
    }
    
    var body: some View {
        List {
            
            // MARK: - Filters
            
            Section("Filters") {
                
                Picker(
                    "Cohort",
                    selection: $selectedCohort
                ) {
                    ForEach(cohorts, id: \.self) { cohort in
                        Text(cohort)
                            .tag(cohort)
                    }
                }
                
                Picker(
                    "Skill",
                    selection: $selectedSkill
                ) {
                    ForEach(skills, id: \.self) { skill in
                        Text(skill)
                            .tag(skill)
                    }
                }
            }
            
            // MARK: - Candidates
            
            Section(
                "\(filteredCandidates.count) Candidates"
            ) {
                
                ForEach(filteredCandidates) { candidate in
                    NavigationLink {
                        CandidateProfileView(
                            profile: candidate
                        )
                    } label: {
                        CandidateCard(
                            profile: candidate
                        )
                    }
                }
                
                if filteredCandidates.isEmpty {
                    ContentUnavailableView(
                        "No Candidates Found",
                        systemImage: "person.slash",
                        description: Text(
                            "Try changing your search or filters."
                        )
                    )
                }
            }
        }
        .navigationTitle("Candidates")
        .searchable(
            text: $searchText,
            prompt: "Search by name or profile ID"
        )
    }
}

struct CandidateCard: View {
    
    let profile: StudentProfile
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            HStack {
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(profile.name)
                        .font(.headline)
                    
                    Text(profile.cohort)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(
                    systemName: "checkmark.seal.fill"
                )
            }
            
            Text(
                "\(profile.completionPercent)% skills demonstrated"
            )
            .font(.subheadline)
            
            HStack {
                
                Label(
                    "\(profile.demonstratedCount) Skills",
                    systemImage: "checkmark.circle"
                )
                
                Spacer()
                
                Label(
                    "\(profile.verifiedEvidenceCount) Evidence",
                    systemImage: "doc"
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        CandidateDirectoryView(
            candidates: MockData.candidates
        )
    }
}
