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
            
            NavigationStack {
                OverviewView()
            }
            .tabItem {
                Label(
                    "Overview",
                    systemImage: "house"
                )
            }
            
            NavigationStack {
                CandidateDirectoryView(
                    candidates: MockData.candidates
                )
            }
            .tabItem {
                Label(
                    "Candidates",
                    systemImage: "person.3"
                )
            }
            
            NavigationStack {
                SkillsFrameworkView(
                    groups: MockData.skillsFramework
                )
            }
            .tabItem {
                Label(
                    "Skills",
                    systemImage: "list.bullet.rectangle"
                )
            }
            
            NavigationStack {
                VerifyView()
            }
            .tabItem {
                Label(
                    "Verify",
                    systemImage: "checkmark.seal"
                )
            }
        }
    }
}

#Preview {
    GuestShellView()
}
