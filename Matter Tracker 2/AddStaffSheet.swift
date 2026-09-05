//
//  AddStaffSheet.swift
//  Matter Tracker
//
//  Created by admin on 5/9/2026.
//


//
//  ManagerActionSheets.swift
//  Matter Tracker
//
//  Real, functional forms behind the Manager Dashboard's Quick Actions.
//  Replaces the previous print()-only placeholder buttons.
//

import SwiftUI

// MARK: - Add Staff

/// Provisions a facilitator, manager, or external reviewer account.
/// (Students are never created here — they self-register via /auth/register;
/// a manager can only assign an existing student to a cohort/facilitator via
/// PATCH /users/:id, which lives in ManagerStudentsView/StudentDetailSheet.)
struct AddStaffSheet: View {

    var onCreated: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var role: UserRole = .facilitator

    @State private var isSubmitting = false
    @State private var errorMessage: String?

    private var canSubmit: Bool {
        !email.isEmpty && password.count >= 8 && !firstName.isEmpty && !lastName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Password (min. 8 characters)", text: $password)
                }

                Section("Name") {
                    TextField("First name", text: $firstName)
                    TextField("Last name", text: $lastName)
                }

                Section("Role") {
                    Picker("Role", selection: $role) {
                        Text("Facilitator").tag(UserRole.facilitator)
                        Text("Manager").tag(UserRole.manager)
                        Text("External Reviewer").tag(UserRole.external_reviewer)
                    }
                    .pickerStyle(.segmented)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Staff")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await submit() }
                    } label: {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text("Create")
                        }
                    }
                    .disabled(!canSubmit || isSubmitting)
                    .tint(.matterOrange)
                }
            }
        }
    }

    @MainActor
    private func submit() async {
        isSubmitting = true
        errorMessage = nil
        do {
            _ = try await ApiService.shared.provisionUser(
                .init(email: email, password: password, role: role, firstName: firstName, lastName: lastName)
            )
            onCreated()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        isSubmitting = false
    }
}

// MARK: - Grant External Access

/// Grants an external reviewer access to a specific student's approved
/// evidence (POST /manager/external-access).
struct GrantExternalAccessSheet: View {

    /// Restrict the student picker to a cohort if one is already selected
    /// on the dashboard; nil shows every student.
    let cohortId: String?

    @Environment(\.dismiss) private var dismiss

    @State private var students: [User] = []
    @State private var reviewers: [User] = []
    @State private var selectedStudentId: String?
    @State private var selectedReviewerId: String?

    @State private var isLoading = true
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading students & reviewers…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if students.isEmpty || reviewers.isEmpty {
                    ProStateView(
                        systemImage: "person.crop.circle.badge.exclamationmark",
                        title: "Nothing to Grant Yet",
                        message: students.isEmpty
                            ? "There are no students to grant access to."
                            : "There are no external reviewer accounts yet. Add one first."
                    )
                    .padding()
                } else {
                    Form {
                        Section("Student") {
                            Picker("Student", selection: $selectedStudentId) {
                                Text("Select a student").tag(String?.none)
                                ForEach(students) { student in
                                    Text("\(student.firstName) \(student.lastName)")
                                        .tag(Optional(student.id))
                                }
                            }
                        }

                        Section("External Reviewer") {
                            Picker("Reviewer", selection: $selectedReviewerId) {
                                Text("Select a reviewer").tag(String?.none)
                                ForEach(reviewers) { reviewer in
                                    Text("\(reviewer.firstName) \(reviewer.lastName)")
                                        .tag(Optional(reviewer.id))
                                }
                            }
                        }

                        if let errorMessage {
                            Section {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }

                        if let successMessage {
                            Section {
                                Label(successMessage, systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Grant External Access")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await submit() }
                    } label: {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text("Grant")
                        }
                    }
                    .disabled(selectedStudentId == nil || selectedReviewerId == nil || isSubmitting)
                    .tint(.matterOrange)
                }
            }
            .task {
                await loadPeople()
            }
        }
    }

    @MainActor
    private func loadPeople() async {
        isLoading = true
        do {
            async let studentsTask = ApiService.shared.listUsers(role: .student, cohortId: cohortId)
            async let reviewersTask = ApiService.shared.listUsers(role: .external_reviewer)
            let (fetchedStudents, fetchedReviewers) = try await (studentsTask, reviewersTask)
            students = fetchedStudents
            reviewers = fetchedReviewers
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    private func submit() async {
        guard let studentId = selectedStudentId, let reviewerId = selectedReviewerId else { return }
        isSubmitting = true
        errorMessage = nil
        do {
            try await ApiService.shared.grantExternalAccess(studentId: studentId, externalReviewerId: reviewerId)
            successMessage = "Access granted."
            selectedStudentId = nil
            selectedReviewerId = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isSubmitting = false
    }
}