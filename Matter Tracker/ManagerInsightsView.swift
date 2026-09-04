//
//  ManagerInsightsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerInsightsView: View {
    
    var body: some View {
        VStack {
            Text("Program Insights")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Program trends and skill gaps will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Insights")
    }
}