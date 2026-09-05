//
//  Settings.swift.
//  Matter Tracker.

//  Created by Prosperity on 4/9/2026.

import SwiftUI

struct SettingsView: View {

@Environment(\.dismiss) private var dismiss

@AppStorage("notificationsEnabled")
private var notificationsEnabled = true

@AppStorage("darkModeEnabled")
private var darkModeEnabled = false

@AppStorage("emailNotificationsEnabled")
private var emailNotificationsEnabled = true

@AppStorage("language")
private var language = "English"

@State private var showLogoutAlert = false
@State private var showDeleteAlert = false

var body: some View {
    NavigationStack {
        List {
            
            Section("Account") {
                
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
            }
            
            Section("Preferences") {
                
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
                
                Toggle(isOn: $darkModeEnabled) { SettingsRow( title: "Dark Mode", subtitle: "Use a darker appearance", icon: "moon.fill" )
                }
                
                NavigationLink {
                    LanguageSettingsView(
                        selectedLanguage: $language
                    )
                } label: {
                    HStack {
                        SettingsRow(
                            title: "Language",
                            subtitle: "Choose your app language",
                            icon: "globe"
                        )
                        
                        Spacer()
                        
                        Text(language)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("App") {
                
                NavigationLink {
                    GeneralSettingsView()
                } label: {
                    SettingsRow(
                        title: "General",
                        subtitle: "Manage general app preferences",
                        icon: "gearshape.fill"
                    )
                }
                
                NavigationLink {
                    DataStorageView()
                } label: {
                    SettingsRow(
                        title: "Data & Storage",
                        subtitle: "Manage your app data",
                        icon: "internaldrive.fill"
                    )
                }
                
                NavigationLink {
                    AboutView()
                } label: {
                    SettingsRow(
                        title: "About",
                        subtitle: "App information and version",
                        icon: "info.circle.fill"
                    )
                }
            }
            
            Section("Privacy & Security") {
                
                NavigationLink {
                    PrivacyView()
                } label: {
                    SettingsRow(
                        title: "Privacy",
                        subtitle: "Manage your privacy settings",
                        icon: "hand.raised.fill"
                    )
                }
                
                NavigationLink {
                    SecurityView()
                } label: {
                    SettingsRow(
                        title: "Security",
                        subtitle: "Manage account security",
                        icon: "shield.fill"
                    )
                }
            }
            
            Section("Support") {
                
                NavigationLink {
                    HelpSupportView()
                } label: {
                    SettingsRow(
                        title: "Help & Support",
                        subtitle: "Get help with the application",
                        icon: "questionmark.circle.fill"
                    )
                }
                
                NavigationLink {
                    FeedbackView()
                } label: {
                    SettingsRow(
                        title: "Send Feedback",
                        subtitle: "Tell us how we can improve",
                        icon: "text.bubble.fill"
                    )
                }
            }
            
            Section("Account Actions") {
                
                Button {
                    showLogoutAlert = true
                } label: {
                    SettingsRow(
                        title: "Log Out",
                        subtitle: "Sign out of your account",
                        icon: "rectangle.portrait.and.arrow.right"
                    )
                    .foregroundStyle(.red)
                }
                
                Button {
                    showDeleteAlert = true
                } label: {
                    SettingsRow(
                        title: "Delete Account",
                        subtitle: "Permanently delete your account",
                        icon: "trash.fill"
                    )
                    .foregroundStyle(.red)
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("MCRI App")
                            .font(.headline)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {
                
            }
            
            Button("Log Out", role: .destructive) {
                
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                
            }
            
            Button("Delete", role: .destructive) {
                
            }
        } message: {
            Text(
                "This action cannot be undone. Your account and associated data will be permanently deleted."
            )
        }
    }
}


}

struct SettingsRow: View {

let title: String
let subtitle: String
let icon: String

var body: some View {
    HStack(spacing: 15) {
        
        Image(systemName: icon)
            .font(.title3)
            .frame(width: 35, height: 35)
            .foregroundStyle(.blue)
        
        VStack(
            alignment: .leading,
            spacing: 3
        ) {
            Text(title)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    .padding(.vertical, 4)
}


}

struct ProfileSettingsView: View {

@State private var name = "Facilitator"
@State private var email = "facilitator@mcri.com"

var body: some View {
    Form {
        Section("Personal Information") {
            
            TextField(
                "Name",
                text: $name
            )
            
            TextField(
                "Email",
                text: $email
            )
            .keyboardType(.emailAddress)
        }
        
        Section {
            Button("Save Changes") {
                
            }
        }
    }
    .navigationTitle("Profile")
}


}

struct ChangePasswordView: View {

@State private var currentPassword = ""
@State private var newPassword = ""
@State private var confirmPassword = ""

var body: some View {
    Form {
        
        Section("Current Password") {
            SecureField(
                "Current Password",
                text: $currentPassword
            )
        }
        
        Section("New Password") {
            
            SecureField(
                "New Password",
                text: $newPassword
            )
            
            SecureField(
                "Confirm Password",
                text: $confirmPassword
            )
        }
        
        Section {
            Button("Update Password") {
                
            }
            .disabled(
                currentPassword.isEmpty ||
                newPassword.isEmpty ||
                confirmPassword.isEmpty ||
                newPassword != confirmPassword
            )
        }
    }
    .navigationTitle("Change Password")
}


}

struct LanguageSettingsView: View {

@Binding var selectedLanguage: String

let languages = [
    "English",
    "Shona",
    "Ndebele"
]

var body: some View {
    Form {
        Section("Language") {
            
            Picker(
                "Language",
                selection: $selectedLanguage
            ) {
                ForEach(
                    languages,
                    id: \.self
                ) { language in
                    Text(language)
                        .tag(language)
                }
            }
        }
    }
    .navigationTitle("Language")
}


}

struct GeneralSettingsView: View {

@AppStorage("autoSaveEnabled")
private var autoSave = true

@AppStorage("showCompletedTasks")
private var showCompletedTasks = true

var body: some View {
    Form {
        Section("General") {
            
            Toggle(
                "Auto Save",
                isOn: $autoSave
            )
            
            Toggle(
                "Show Completed Tasks",
                isOn: $showCompletedTasks
            )
        }
    }
    .navigationTitle("General")
}


}

struct DataStorageView: View {

var body: some View {
    List {
        
        Section("Storage") {
            
            HStack {
                Text("Documents")
                
                Spacer()
                
                Text("24 MB")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Evidence")
                
                Spacer()
                
                Text("86 MB")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Total Storage")
                
                Spacer()
                
                Text("110 MB")
                    .foregroundStyle(.secondary)
            }
        }
        
        Section {
            Button("Clear Cached Data") {
                
            }
        }
    }
    .navigationTitle("Data & Storage")
}


}

struct AboutView: View {

var body: some View {
    List {
        
        Section("Application") {
            
            HStack {
                Text("Application")
                
                Spacer()
                
                Text("MCRI")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Version")
                
                Spacer()
                
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
        }
        
        Section("About") {
            Text(
                "This application helps students, facilitators and managers manage skills, evidence, assessments and progress."
            )
            .foregroundStyle(.secondary)
        }
    }
    .navigationTitle("About")
}


}

struct PrivacyView: View {

@AppStorage("analyticsEnabled")
private var analyticsEnabled = true

var body: some View {
    Form {
        
        Section("Privacy") {
            Toggle(
                "Share Analytics",
                isOn: $analyticsEnabled
            )
        }
        
        Section("Information") {
            Text(
                "Your information is used to provide the features and services available in the application."
            )
            .foregroundStyle(.secondary)
        }
    }
    .navigationTitle("Privacy")
}


}

struct SecurityView: View {

@AppStorage("biometricEnabled")
private var biometricEnabled = false

var body: some View {
    Form {
        
        Section("Security") {
            Toggle(
                "Biometric Authentication",
                isOn: $biometricEnabled
            )
        }
        
        Section {
            Text(
                "Use Face ID or Touch ID to help protect your account."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    .navigationTitle("Security")
}


}

struct HelpSupportView: View {

var body: some View {
    List {
        
        Section("Help") {
            
            NavigationLink("Frequently Asked Questions") {
                FAQView()
            }
            
            NavigationLink("Contact Support") {
                ContactSupportView()
            }
        }
    }
    .navigationTitle("Help & Support")
}


}

struct FAQView: View {

var body: some View {
    List {
        
        Section("Frequently Asked Questions") {
            
            DisclosureGroup(
                "How do I assess evidence?"
            ) {
                Text(
                    "Open Pending Evidence, select the submitted evidence and complete the assessment."
                )
                .foregroundStyle(.secondary)
            }
            
            DisclosureGroup(
                "How do I view students?"
            ) {
                Text(
                    "Open Assigned Students from the Facilitator Dashboard."
                )
                .foregroundStyle(.secondary)
            }
            
            DisclosureGroup(
                "How do I rate essential skills?"
            ) {
                Text(
                    "Open a student's Walkthrough, select Essential Skills and tap the stars to give a rating."
                )
                .foregroundStyle(.secondary)
            }
        }
    }
    .navigationTitle("FAQ")
}


}

struct ContactSupportView: View {

@State private var message = ""

var body: some View {
    Form {
        
        Section("Message") {
            TextEditor(
                text: $message
            )
            .frame(height: 180)
        }
        
        Section {
            Button("Send Message") {
                
            }
            .disabled(
                message
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty
            )
        }
    }
    .navigationTitle("Contact Support")
}


}

struct FeedbackView: View {

@State private var feedback = ""

var body: some View {
    Form {
        
        Section("Your Feedback") {
            TextEditor(
                text: $feedback
            )
            .frame(height: 180)
        }
        
        Section {
            Button("Submit Feedback") {
                
            }
            .disabled(
                feedback
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty
            )
        }
    }
    .navigationTitle("Feedback")
}


}

#Preview {
SettingsView()
}
