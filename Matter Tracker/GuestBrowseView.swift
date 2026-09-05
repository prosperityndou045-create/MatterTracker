//
//  GuestBrowseView.swift
//  Matter Tracker
//

import SwiftUI

struct GuestBrowseView: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Hero Header
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MATTER CAREER READINESS INSTITUTE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1.3)
                                .foregroundColor(.matterOrange)
                            
                            Text("What We Do")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // View Only Badge
                        HStack(spacing: 6) {
                            Image(systemName: "eye.fill")
                                .font(.caption)
                            
                            Text("VIEW ONLY")
                                .font(.caption2)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    
                    Text("Student Skills Evidence & Portfolio Tracker")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.85))
                    
                    Text(
                        "Explore how students develop skills, document their learning and build evidence of what they can demonstrate."
                    )
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(24)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#153A55"),
                            Color(hex: "#153A55").opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: Color.black.opacity(0.12), radius: 12, y: 6)
                
                // MARK: - Introduction
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("OUR APPROACH")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.matterOrange)
                    
                    Text("Building Skills Through Evidence")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(
                        "The platform gives students a structured way to develop their skills and connect their learning to real evidence."
                    )
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                // MARK: - What We Do Cards
                
                VStack(spacing: 14) {
                    
                    GuestInfoCard(
                        icon: "star.fill",
                        title: "Skills Development",
                        description:
                            "Students develop technical and essential skills through learning, practice and real-world activities."
                    )
                    
                    GuestInfoCard(
                        icon: "checkmark.seal.fill",
                        title: "Skills Evidence",
                        description:
                            "Students connect their skills to evidence such as projects, code, assessments, presentations and demonstrations."
                    )
                    
                    GuestInfoCard(
                        icon: "folder.fill",
                        title: "Student Portfolio",
                        description:
                            "Student skills and demonstrated work are brought together into a structured portfolio."
                    )
                    
                    GuestInfoCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Learning Progress",
                        description:
                            "Students can document their development and build a record of their skills over time."
                    )
                }
                
                // MARK: - Guest Access
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack(spacing: 12) {
                        
                        Image(systemName: "eye.fill")
                            .font(.title3)
                            .foregroundColor(.matterOrange)
                            .frame(width: 44, height: 44)
                            .background(Color.matterOrange.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Guest Access")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Public information only")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.65))
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    Text(
                        "Explore the skills and learning paths that make up the Matter Career Readiness curriculum."
                    )
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                // MARK: - Footer
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("MATTER CAREER READINESS INSTITUTE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .tracking(1.2)
                            .foregroundColor(.matterOrange)
                        
                        Text("Student Skills Evidence & Portfolio Tracker")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .padding(20)
        }
        .background(
            Color(hex: "#153A55").ignoresSafeArea()
        )
        .navigationTitle("Guest")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

// MARK: - Guest Information Card

struct GuestInfoCard: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.matterOrange)
                .frame(width: 48, height: 48)
                .background(Color.matterOrange.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(18)
        .background(Color(hex: "#1F4A6B"))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.black.opacity(0.15), radius: 8, y: 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GuestBrowseView()
    }
}
