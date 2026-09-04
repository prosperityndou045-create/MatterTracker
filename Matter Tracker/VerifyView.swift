//
//  VerifyView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct VerifyView: View {
    @State private var profileID = ""
    @State private var showResult = false
    
    var body: some View {
        
        Form {
            
            Section {
                
                Text("""
                Enter a candidate's profile ID to verify
                their public portfolio.
                """)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                TextField(
                    "MCRI-2026-0472",
                    text: $profileID
                )
                .textInputAutocapitalization(.characters)
                
                Button("Verify Profile") {
                    
                    showResult = true
                }
                .frame(
                    maxWidth: .infinity
                )
                .disabled(
                    profileID
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
            }
            
            Section("How verification works") {
                
                Label(
                    "Enter a profile ID",
                    systemImage: "number"
                )
                
                Label(
                    "Check whether the profile exists",
                    systemImage: "checkmark.shield"
                )
                
                Label(
                    "View the candidate's public evidence",
                    systemImage: "person.text.rectangle"
                )
            }
        }
        .navigationTitle("Verify")
        .sheet(
            isPresented: $showResult
        ) {
            
            VerificationResultView(
                profileID: profileID
            )
        }
    }
}
