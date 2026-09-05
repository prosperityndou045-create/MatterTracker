//
//  FacilitatorDashboardView.swift
//  Matter Tracker
//
//  Created by Prosperity on 5/9/2026.
//

import SwiftUI

// MARK: - Facilitator Dashboard

struct FacilitatorDashboardView: View {
    
    @State private var students: [User] = []
    @State private var pendingEvidence: [Evidence] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    
    private var totalStudents: Int { students.count }
    private var pendingCount: Int { pendingEvidence.count }
    private var activeStudents: Int { students.filter { $0.isActive == true }.count }
    private var progressPercentage: Int {
        guard totalStudents > 0 else { return 0 }
        return Int((Double(activeStudents) / Double(totalStudents)) * 100)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if isLoading && !isRefreshing {
                        loadingView
                    } else if let error = errorMessage {
                        errorView(error)
                    } else {
                        // Header
                        Text("Monitor and support your assigned students.")
                            .foregroundStyle(.secondary)
                        
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
                                value: "\(totalStudents)",
                                icon: "person.2.fill",
                                color: .matterOrange
                            )
                            
                            DashboardCard(
                                title: "Pending",
                                value: "\(pendingCount)",
                                icon: "clock.fill",
                                color: pendingCount > 0 ? .orange : .green
                            )
                            
                            DashboardCard(
                                title: "Active",
                                value: "\(activeStudents)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            DashboardCard(
                                title: "Progress",
                                value: "\(progressPercentage)%",
                                icon: "chart.bar.fill",
                                color: .blue
                            )
                        }
                        
                        // MARK: - Quick Actions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Actions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.matterNavy)
                            
                            NavigationLink {
                                AssignedStudentsView()
                            } label: {
                                DashboardRow(
                                    title: "Assigned Students",
                                    subtitle: "View and manage your \(totalStudents) students",
                                    icon: "person.2.fill",
                                    badge: "\(totalStudents)"
                                )
                            }
                            
                            NavigationLink {
                                PendingReviewsListView()
                            } label: {
                                DashboardRow(
                                    title: "Pending Evidence",
                                    subtitle: "Review \(pendingCount) evidence submissions",
                                    icon: "doc.text.magnifyingglass",
                                    badge: pendingCount > 0 ? "\(pendingCount)" : nil,
                                    badgeColor: pendingCount > 0 ? .orange : .green
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Facilitator Dashboard")
            .refreshable {
                await refreshDashboard()
            }
            .task {
                await loadDashboard()
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading dashboard...")
                .font(.headline)
                .foregroundColor(.matterNavy)
            Text("Fetching your students and pending reviews")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to Load Dashboard",
            message: message,
            actionTitle: "Retry"
        ) {
            Task { await loadDashboard() }
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let studentsTask = ApiService.shared.facilitatorStudents()
            async let pendingTask = ApiService.shared.facilitatorPendingReviews()
            
            let (loadedStudents, loadedPending) = try await (studentsTask, pendingTask)
            students = loadedStudents
            pendingEvidence = loadedPending
        } catch {
            errorMessage = error.localizedDescription
            students = []
            pendingEvidence = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshDashboard() async {
        isRefreshing = true
        await loadDashboard()
    }
}

// MARK: - Dashboard Card

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            
            Text(title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// MARK: - Dashboard Row

struct DashboardRow: View {
    let title: String
    let subtitle: String
    let icon: String
    var badge: String? = nil
    var badgeColor: Color = .matterOrange
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.matterOrange)
                .frame(width: 45, height: 45)
                .background(Color.matterOrange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterNavy)
                    
                    if let badge = badge {
                        Text(badge)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(badgeColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// MARK: - Preview

#Preview {
    FacilitatorDashboardView()
}
