//
//  AssessmentCompleteView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct AssessmentCompleteView: View {
    
    // The decision made by the facilitator.
    let decision: String
    
    // The feedback given by the facilitator.
    let feedback: String
    
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
            
            
            // Confirmation message
            Text("Assessment Submitted")
                .font(.title)
                .fontWeight(.bold)
            
            
            // Tell facilitator what happened.
            Text(
                decision == "Approved"
                ? "The evidence has been approved."
                : "Changes have been requested from the student."
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Feedback")
                    .font(.headline)
                
                Text(feedback)
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("Complete")
    }
}
#Preview {
    AssignedStudentsView()
}
