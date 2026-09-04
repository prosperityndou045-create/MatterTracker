//
//  ManagerEvidenceView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerEvidenceView: View {
    
    var body: some View {
        VStack {
            Text("Evidence Data")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Submitted evidence and pending reviews will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Evidence")
    }
}