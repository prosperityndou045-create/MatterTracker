//
//  AssignedStudentsView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

// MARK: - Assigned Students View

struct AssignedStudentsView: View {
    
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
        NavigationStack {
            List {
                if isLoading && !isRefreshing {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if students.isEmpty {
                    emptyStateView
                } else {
                    Section("Assigned Students (\(filteredStudents.count))") {
                        ForEach(filteredStudents) { student in
                            NavigationLink {
                                FacilitatorStudentDetailView(studentId: student.id)
                            } label: {
                                AssignedStudentRow(student: student)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assigned Students")
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
                
                Text("No Assigned Students")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("You don't have any students assigned to you yet.")
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
            students = try await ApiService.shared.facilitatorStudents()
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

// MARK: - Assigned Student Row

struct AssignedStudentRow: View {
    let student: User
    
    var body: some View {
        HStack(spacing: 15) {
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(student.firstName) \(student.lastName)")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text(student.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let cohort = student.cohort {
                    Text(cohort.name)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.matterOrange.opacity(0.15))
                        .foregroundColor(.matterOrange)
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.matterOrange)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    AssignedStudentsView()
}
