//
//  Assessment.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//
import SwiftUI

struct AssessmentView: View {
    
    let skill: Skill

    let evidence: Evidence
    
    @State private var decision = ""
    
    @State private var feedback = ""
    
    
    var body: some View {
        
        Form {
        
            Section("Evidence") {
                
                Text(evidence.title)
                    .font(.headline)
                
                Text(evidence.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                
                HStack {
                    
                    Text("Type")
                    
                    Spacer()
                    
                    Text(evidence.type)
                        .foregroundStyle(.secondary)
                }
                
                
                HStack {
                    
                    Text("Submitted")
                    
                    Spacer()
                    
                    Text(evidence.date)
                        .foregroundStyle(.secondary)
                }
            }
            
            
            Section("Assessment") {
                
                Button {
                    
                    decision = "Approved"
                    
                } label: {
                    
                    HStack {
                        
                        Image(systemName: "checkmark.circle.fill")
                        
                        Text("Approve Evidence")
                        
                        Spacer()
                        
                        // Shows a checkmark if selected.
                        if decision == "Approved" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                
                Button {
                    
                    decision = "Changes Required"
                    
                } label: {
                    
                    HStack {
                        
                        Image(systemName: "arrow.clockwise.circle.fill")
                        
                        Text("Request Changes")
                        
                        Spacer()
                        
                        if decision == "Changes Required" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        
            
            Section("Facilitator Feedback") {
                
                TextEditor(text: $feedback)
                    .frame(height: 120)
                
                
                Text(
                    "Explain what the student did well "
                    + "and what they can improve."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            
            
            Section {
                
                NavigationLink {
                    
                    AssessmentCompleteView(
                        decision: decision,
                        feedback: feedback
                    )
                    
                } label: {
                    
                    Text("Submit Assessment")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            
                .disabled(
                    decision.isEmpty || feedback.isEmpty
                )
            }
        }
        .navigationTitle("Assessment")
    }
}



