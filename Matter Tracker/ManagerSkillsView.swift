//
//  ManagerSkillsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerSkillsView: View {
    
    var body: some View {
        VStack {
            Text("Skills Data")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Most and least demonstrated skills will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Skills Data")
    }
}