//
//  ProfileSettingsView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()
            
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                        .foregroundColor(.white)
                    TextField("Last Name", text: $lastName)
                        .foregroundColor(.white)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .disabled(true)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button {
                        Task {
                            await saveProfile()
                        }
                    } label: {
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                Text("Saving...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Save Changes")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(isLoading)
                    .buttonStyle(.borderedProminent)
                    .tint(.matterOrange)
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.matterOrange)
                    }
                }
            }
            .task {
                await loadProfile()
            }
            .alert("Profile Updated", isPresented: $showSuccess) {
                Button("OK") { }
            } message: {
                Text("Your profile has been updated successfully.")
            }
        }
    }
    
    @MainActor
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await ApiService.shared.me()
            firstName = user.firstName
            lastName = user.lastName
            email = user.email
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    private func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let body = ApiService.UpdateUserBody(
                firstName: firstName,
                lastName: lastName,
                bio: nil,
                profilePictureUrl: nil,
                cohortId: nil,
                facilitatorId: nil
            )
            _ = try await ApiService.shared.updateUser(id: "me", body)
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
