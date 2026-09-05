//
//  SettingsView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("emailNotificationsEnabled") private var emailNotificationsEnabled = true
    @AppStorage("language") private var language = "English"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.matterNavy.ignoresSafeArea()
                
                List {
                    // Account Section
                    Section {
                        NavigationLink {
                            ProfileSettingsView()
                        } label: {
                            SettingsRow(
                                title: "Profile",
                                subtitle: "Manage your account information",
                                icon: "person.circle.fill"
                            )
                        }
                        
                        NavigationLink {
                            ChangePasswordView()
                        } label: {
                            SettingsRow(
                                title: "Change Password",
                                subtitle: "Update your account password",
                                icon: "lock.fill"
                            )
                        }
                    } header: {
                        Text("Account")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Preferences Section
                    Section {
                        Toggle(isOn: $notificationsEnabled) {
                            SettingsRow(
                                title: "Notifications",
                                subtitle: "Receive app notifications",
                                icon: "bell.fill"
                            )
                        }
                        
                        Toggle(isOn: $emailNotificationsEnabled) {
                            SettingsRow(
                                title: "Email Notifications",
                                subtitle: "Receive important updates by email",
                                icon: "envelope.fill"
                            )
                        }
                        
                        Toggle(isOn: $darkModeEnabled) {
                            SettingsRow(
                                title: "Dark Mode",
                                subtitle: "Use a darker appearance",
                                icon: "moon.fill"
                            )
                        }
                        
                        NavigationLink {
                            LanguageSettingsView(selectedLanguage: $language)
                        } label: {
                            HStack {
                                SettingsRow(
                                    title: "Language",
                                    subtitle: "Choose your app language",
                                    icon: "globe"
                                )
                                Spacer()
                                Text(language)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } header: {
                        Text("Preferences")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // App Section
                    Section {
                        NavigationLink {
                            AboutView()
                        } label: {
                            SettingsRow(
                                title: "About",
                                subtitle: "App information and version",
                                icon: "info.circle.fill"
                            )
                        }
                    } header: {
                        Text("App")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Account Actions
                    Section {
                        Button {
                            showLogoutAlert = true
                        } label: {
                            SettingsRow(
                                title: "Log Out",
                                subtitle: "Sign out of your account",
                                icon: "rectangle.portrait.and.arrow.right"
                            )
                            .foregroundColor(.red)
                        }
                        
                        Button {
                            showDeleteAlert = true
                        } label: {
                            SettingsRow(
                                title: "Delete Account",
                                subtitle: "Permanently delete your account",
                                icon: "trash.fill"
                            )
                            .foregroundColor(.red)
                        }
                    } header: {
                        Text("Account Actions")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Version
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Text("Matter Tracker")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Version 1.0.0")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
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
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    ApiService.shared.logout()
                    // Navigate to login
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
            .alert("Delete Account", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    // Delete account logic
                }
            } message: {
                Text("This action cannot be undone. Your account and associated data will be permanently deleted.")
            }
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.matterOrange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Change Password

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()
            
            Form {
                Section("Current Password") {
                    SecureField("Current Password", text: $currentPassword)
                        .foregroundColor(.white)
                }
                
                Section("New Password") {
                    SecureField("New Password", text: $newPassword)
                        .foregroundColor(.white)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .foregroundColor(.white)
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
                        changePassword()
                    } label: {
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                Text("Updating...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Update Password")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(
                        currentPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmPassword.isEmpty ||
                        newPassword != confirmPassword ||
                        newPassword.count < 8
                    )
                    .buttonStyle(.borderedProminent)
                    .tint(.matterOrange)
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Change Password")
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
            .alert("Password Updated", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your password has been changed successfully.")
            }
        }
    }
    
    @MainActor
    private func changePassword() {
        // Password change logic - you'll need to add this to your API
        isLoading = true
        errorMessage = nil
        
        Task {
            // Simulate API call
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                isLoading = false
                showSuccess = true
            }
        }
    }
}

// MARK: - Language Settings

struct LanguageSettingsView: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss
    
    let languages = ["English", "Shona", "Ndebele"]
    
    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()
            
            List {
                Section("Language") {
                    ForEach(languages, id: \.self) { language in
                        HStack {
                            Text(language)
                                .foregroundColor(.white)
                            Spacer()
                            if selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.matterOrange)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedLanguage = language
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Language")
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
        }
    }
}

// MARK: - About View

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()
            
            List {
                Section("Application") {
                    InfoRow(label: "Name", value: "Matter Tracker")
                    InfoRow(label: "Version", value: "1.0.0")
                    InfoRow(label: "Build", value: "1")
                }
                
                Section("About") {
                    Text("This application helps students, facilitators and managers track skills, evidence, assessments and progress.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About")
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
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
