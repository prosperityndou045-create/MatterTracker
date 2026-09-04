//
//  ManagerStudentsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//


import SwiftUI

struct ManagerStudentsView: View {
    
    var body: some View {
        VStack {
            Text("Students")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("View students and their individual progress here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Students")
    }
}