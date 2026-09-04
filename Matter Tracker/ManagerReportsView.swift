//
//  ManagerReportsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerReportsView: View {
    
    var body: some View {
        VStack {
            Text("Reports")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Generate and view program reports here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Reports")
    }
}