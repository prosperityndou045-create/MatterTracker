//
//  StudentProfileView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct StudentProfileView: View {
    let studentId: String
    
    @State private var student: User?
    @State private var portfolio: Portfolio?
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading && !isRefreshing {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if let student = student, let portfolio = portfolio {
                    // Header
                    headerView(student)
                    
                    // Progress
                    progressView(portfolio)
                    
                    // Stats
                    statsView(portfolio)
                    
                    // Walkthrough Button
                    NavigationLink {
                        WalkthroughView(studentId: student.id)
                    } label: {
                        Text("Start Walkthrough")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.matterOrange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    emptyStateView
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.matterNavy.ignoresSafeArea())
        .refreshable {
            await refreshData()
        }
        .task {
            await loadStudentData()
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading profile...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.matterOrange)
            Text("Unable to Load Profile")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Button {
                Task { await loadStudentData() }
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.matterOrange)
                    .cornerRadius(8)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.slash")
                .font(.system(size: 44))
                .foregroundColor(.matterOrange.opacity(0.5))
            Text("Student Not Found")
                .font(.headline)
                .foregroundColor(.white)
            Text("Unable to load profile data.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Header
    
    private func headerView(_ student: User) -> some View {
        VStack(spacing: 10) {
            if let profilePicture = student.profilePictureUrl,
               let url = URL(string: profilePicture) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 72))
                        .foregroundColor(.matterOrange)
                }
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.matterOrange, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.matterOrange)
            }
            
            Text("\(student.firstName) \(student.lastName)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(student.email)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            if let cohort = student.cohort {
                Text(cohort.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                    .background(Color.matterOrange.opacity(0.15))
                    .foregroundColor(.matterOrange)
                    .cornerRadius(6)
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Progress
    
    private func progressView(_ portfolio: Portfolio) -> some View {
        let totalSkills = portfolio.demonstratedSkills.count + portfolio.essentialSkills.count
        let demonstratedSkills = portfolio.demonstratedSkills.filter { $0.status == .demonstrated }.count
        let progress = totalSkills > 0 ? Int((Double(demonstratedSkills) / Double(totalSkills)) * 100) : 0
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(progress)%")
                    .font(.headline)
                    .foregroundColor(.matterOrange)
            }
            
            ProgressView(value: Double(progress), total: 100)
                .tint(.matterOrange)
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
    }
    
    // MARK: - Stats
    
    private func statsView(_ portfolio: Portfolio) -> some View {
        let totalSkills = portfolio.demonstratedSkills.count + portfolio.essentialSkills.count
        let demonstratedSkills = portfolio.demonstratedSkills.filter { $0.status == .demonstrated }.count
        let remainingSkills = totalSkills - demonstratedSkills
        
        return HStack(spacing: 0) {
            StatItem(value: "\(demonstratedSkills)", label: "Demonstrated")
            Divider()
                .frame(height: 30)
                .background(Color.white.opacity(0.1))
            StatItem(value: "\(remainingSkills)", label: "Remaining")
            Divider()
                .frame(height: 30)
                .background(Color.white.opacity(0.1))
            StatItem(value: "\(totalSkills)", label: "Total")
        }
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadStudentData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let userTask = ApiService.shared.getUser(id: studentId)
            async let portfolioTask = ApiService.shared.facilitatorStudentPortfolio(studentId: studentId)
            
            let (loadedUser, loadedPortfolio) = try await (userTask, portfolioTask)
            student = loadedUser
            portfolio = loadedPortfolio
        } catch {
            errorMessage = error.localizedDescription
            student = nil
            portfolio = nil
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshData() async {
        isRefreshing = true
        await loadStudentData()
    }
}

// MARK: - Stat Item

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        StudentProfileView(studentId: "test-student-id")
    }
}
