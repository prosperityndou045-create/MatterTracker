//
//  FacilitatorDashboardView.swift
//  Matter Tracker
//
//  Created by Prosperity on 5/9/2026.
//


import SwiftUI

// MARK: - Facilitator Dashboard

struct FacilitatorDashboardView: View {
    
    var body: some View {
        
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    Text("Monitor and support your assigned students.")
                        .foregroundColor(.gray)
                    
                    
                    // MARK: - Summary Cards
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {
                        
                        DashboardCard(
                            title: "Students",
                            value: "24",
                            icon: "person.2.fill"
                        )
                        
                        DashboardCard(
                            title: "Pending",
                            value: "8",
                            icon: "clock.fill"
                        )
                        
                        DashboardCard(
                            title: "Completed",
                            value: "16",
                            icon: "checkmark.circle.fill"
                        )
                        
                        DashboardCard(
                            title: "Progress",
                            value: "72%",
                            icon: "chart.bar.fill"
                        )
                    }
                    
                    
                    // MARK: - Quick Actions
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Quick Actions")
                            .font(.title2)
                            .fontWeight(.bold)
                    
                        
                        NavigationLink {
                            AssignedStudentsView()
                        } label: {
                            
                            DashboardRow(
                                title: "Assigned Students",
                                subtitle: "View and manage your students",
                                icon: "person.2.fill"
                            )
                        }
                        
                        
                        NavigationLink {
                            EvidenceReviewView(skill: Skill(name: "Communication Presentation", description: "Student presented a topic to the group", status: "Pending Review"))
                        } label: {
                            
                            DashboardRow(
                                title: "Pending Evidence",
                                subtitle: "Review submitted evidence",
                                icon: "doc.text.magnifyingglass"
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Facilitator Dashboard")
        }
    }
}

struct DashboardCard: View {
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            // Icon
            Image(systemName: icon)
                .font(.title2)
            // Main number
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            // Card title
            Text(title)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


// MARK: - Dashboard Row

struct DashboardRow: View {
    
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            // Left icon
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            
            Spacer()
            
            
            // Arrow showing that this row is clickable
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


#Preview {
    FacilitatorDashboardView()
}
