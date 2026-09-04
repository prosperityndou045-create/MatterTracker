//
//  GuestShell.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct GuestShellView: View {
    var body: some View {
        TabView {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "house") }

            SampleProfileView(profile: MockData.sampleProfile)
                .tabItem { Label("Sample profile", systemImage: "person.text.rectangle") }

            SkillsFrameworkView(groups: MockData.skillsFramework)
                .tabItem { Label("Skills framework", systemImage: "list.bullet.rectangle") }

            VerifyView()
                .tabItem { Label("Verify", systemImage: "checkmark.seal") }
        }
    }
}
struct OverviewView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("MCRI Ledger")
                    .font(.title)
                Text("Every skill a student claims, backed by something you can look at.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .navigationTitle("Overview")
        }
    }
}

struct SampleProfileView: View {
    let profile: StudentProfile

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(profile.name).font(.headline)
                    Text(profile.cohort).font(.subheadline).foregroundStyle(.secondary)
                    Text("\(profile.completionPercent)% demonstrated — \(profile.demonstratedCount) of \(profile.skills.count) skills")
                        .font(.caption)
                }
                Section("Skills") {
                    ForEach(profile.skills) { skill in
                        HStack {
                            Text(skill.name)
                            Spacer()
                            Text(skill.status.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Sample profile")
        }
    }
}

struct SkillsFrameworkView: View {
    let groups: [MockData.FrameworkGroup]

    var body: some View {
        NavigationStack {
            List {
                ForEach(groups) { group in
                    Section(group.category) {
                        ForEach(group.entries) { entry in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.name).font(.body)
                                Text(entry.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Skills framework")
        }
    }
}

struct VerifyView: View {
    @State private var profileID: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Profile ID, e.g. MCRI-2026-0472", text: $profileID)
                    Button("Check") {
                        if profileID.trimmingCharacters(in: .whitespaces).isEmpty {
                            errorMessage = "Enter a profile ID first."
                        } else {
                            errorMessage = nil
                        }
                    }
                }
                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red).font(.caption)
                }
            }
            .navigationTitle("Verify a credential")
        }
    }
}

#Preview {
    GuestShellView()
}
