//
//  ManagerStatCard.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerStatCard: View {
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Image(systemName: icon)
                .font(.title2)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}