//
//  ManagerStudentsView.swift
//  Matter Tracker
//
//  Created by admin on 5/9/2026.
//


//
//  ManagerStudentsView.swift
//  Matter Tracker
//
//  Created by Tana on 4/9/2026.
//

import SwiftUI

struct ManagerStudentsView: View {
    let selectedCohortId: String
    
    @State private var students: [User] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    @State private var selectedStudent: User?
    @State private var showingStudentDetail = false
    
    private var filteredStudents: [User] {
        if searchText.isEmpty {
            return students
        } else {
            return students.filter { student in
                student.firstName.localizedCaseInsensitiveContains(searchText) ||
                student.lastName.localizedCaseInsensitiveContains(searchText) ||
                "\(student.firstName) \(student.lastName)".localizedCaseInsensitiveContains(searchText) ||
                student.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if students.isEmpty {
                emptyStateView
            } else {
                // Stats Header
                Section {
                    HStack {
                        StatBadge(
                            icon: "person.3.fill",
                            value: "\(students.count)",
                            label: "Total Students",
                            color: .matterOrange
                        )
                        
                        Spacer()
                        
                        StatBadge(
                            icon: "checkmark.circle.fill",
                            value: "\(students.filter { $0.isActive == true }.count)",
                            label: "Active",
                            color: .green
                        )
                        
                        Spacer()
                        
                        StatBadge(
                            icon: "person.slash.fill",
                            value: "\(students.filter { $0.isActive == false }.count)",
                            label: "Inactive",
                            color: .red
                        )
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
                
                // Students List
                ForEach(filteredStudents) { student in
                    StudentRow(student: student)
                        .onTapGesture {
                            selectedStudent = student
                            showingStudentDetail = true
                        }
                }
            }
        }
        .navigationTitle("Students")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by name or email"
        )
        .refreshable {
            await refreshStudents()
        }
        .task {
            await loadStudents()
        }
        .sheet(isPresented: $showingStudentDetail) {
            if let student = selectedStudent {
                StudentDetailSheet(student: student)
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                        .scaleEffect(1.2)
                    Text("Loading students...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 40)
        }
        .listRowBackground(Color.clear)
    }
    
    private func errorView(_ message: String) -> some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.matterOrange)
                
                Text("Unable to Load Students")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task { await loadStudents() }
                }
                .buttonStyle(.bordered)
                .tint(.matterOrange)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    private var emptyStateView: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "person.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.matterOrange.opacity(0.6))
                
                Text("No Students Found")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("This cohort doesn't have any students enrolled yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadStudents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            students = try await ApiService.shared.managerCohortStudents(cohortId: selectedCohortId)
        } catch {
            errorMessage = error.localizedDescription
            students = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshStudents() async {
        isRefreshing = true
        await loadStudents()
    }
}

// MARK: - Student Row

struct StudentRow: View {
    let student: User
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            if let profilePicture = student.profilePictureUrl {
                AsyncImage(url: URL(string: profilePicture)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 45))
                        .foregroundColor(.matterOrange)
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.matterOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(student.firstName) \(student.lastName)")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(student.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    // Role badge
                    Text(student.role.rawValue.capitalized)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(roleColor(student.role).opacity(0.15))
                        .foregroundColor(roleColor(student.role))
                        .clipShape(Capsule())
                    
                    // Status badge
                    if let isActive = student.isActive {
                        Text(isActive ? "Active" : "Inactive")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(isActive ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                            .foregroundColor(isActive ? .green : .red)
                            .clipShape(Capsule())
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.matterOrange)
        }
        .padding(.vertical, 4)
    }
    
    private func roleColor(_ role: UserRole) -> Color {
        switch role {
        case .student: return .blue
        case .facilitator: return .matterOrange
        case .manager: return .purple
        case .external_reviewer: return .green
        }
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManagerStudentsView(selectedCohortId: "test-cohort")
    }
}