//
//  SignUpPage.swift
//  Matter Tracker
//

import SwiftUI

struct SignUpPage: View {

    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showPassword = false
    @State private var showConfirmPassword = false

    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToStudentHome = false
    @State private var registeredUserId: String?

    // `POST /auth/register` always creates a `student` account (APIDocs §2 —
    // facilitators/managers/external reviewers are provisioned by a manager),
    // so a successful sign-up here only ever needs to route to the student home.

    private var trimmedFullName: String {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// (first, last) split on the first space. Both must be non-empty for the
    /// API's required `firstName`/`lastName` fields.
    private var nameParts: (first: String, last: String)? {
        let parts = trimmedFullName.split(separator: " ", maxSplits: 1).map(String.init)
        guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else { return nil }
        return (parts[0], parts[1])
    }

    private var canSubmit: Bool {
        !isLoading
            && nameParts != nil
            && !email.isEmpty
            && password.count >= 8
            && password == confirmPassword
    }

    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - Back Button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 38, height: 38)
                                .background(
                                    Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    .padding(.top, 8)

                    // MARK: - Logo (compact — this is a secondary screen, not the splash)
                    VStack(spacing: 4) {
                        Image("MatterLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 46)

                        Text("M A T T E R")
                            .font(.system(size: 13, weight: .medium))
                            .tracking(3)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 4)

                    // MARK: - Title
                    VStack(spacing: 4) {
                        Text("Create your account")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Text("Build your skills. Track your progress.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 22)

                    // MARK: - Fields
                    VStack(spacing: 14) {
                        field(
                            title: "Full Name",
                            icon: "person.fill",
                            text: $fullName,
                            placeholder: "e.g Mhuka Huru",
                            autocap: .words
                        )

                        field(
                            title: "Email",
                            icon: "envelope.fill",
                            text: $email,
                            placeholder: "e.g chapo@example.com",
                            keyboard: .emailAddress,
                            autocap: .never
                        )

                        secureField(
                            title: "Password",
                            text: $password,
                            placeholder: "Create password",
                            isVisible: $showPassword
                        )

                        secureField(
                            title: "Confirm Password",
                            text: $confirmPassword,
                            placeholder: "Confirm password",
                            isVisible: $showConfirmPassword
                        )

                        // Inline hints — only shown once there's something to react to,
                        // so the form doesn't open with a wall of red text.
                        if !trimmedFullName.isEmpty && nameParts == nil {
                            hint("Enter both a first and last name.")
                        }
                        if !password.isEmpty && password.count < 8 {
                            hint("Password must be at least 8 characters.")
                        }
                        if !confirmPassword.isEmpty && password != confirmPassword {
                            hint("Passwords don't match.")
                        }
                        if let errorMessage {
                            hint(errorMessage)
                        }
                    }

                    // MARK: - Create Account
                    Button {
                        signUp()
                    } label: {
                        ZStack {
                            Text("Create Account")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(isLoading ? 0 : 1)

                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.matterOrange, .matterOrangeDk],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1 : 0.5)
                    .padding(.top, 22)

                    // MARK: - Back to Sign In
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.white.opacity(0.55))

                        Button {
                            dismiss()
                        } label: {
                            Text("Sign In")
                                .foregroundColor(.matterOrange)
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.system(size: 13))
                    .padding(.top, 14)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 28)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToStudentHome) {
            if let userId = registeredUserId {
                StudentProfileView(studentId: userId)
            } else {
                // Fallback - student home view without profile
                StudentHomeView()
            }
        }
    }

    // MARK: - Sign Up

    @MainActor
    private func signUp() {
        guard canSubmit, let nameParts else { return }

        errorMessage = nil
        isLoading = true

        Task {
            do {
                let response = try await ApiService.shared.register(
                    email: email,
                    password: password,
                    firstName: nameParts.first,
                    lastName: nameParts.last
                )
                
                // Store the user ID for navigation
                registeredUserId = response.user.id
                isLoading = false
                navigateToStudentHome = true
            } catch {
                isLoading = false
                errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    // MARK: - Reusable field builders

    private func hint(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.red.opacity(0.9))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func field(
        title: String,
        icon: String,
        text: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default,
        autocap: TextInputAutocapitalization = .sentences
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 18)

                TextField(
                    "",
                    text: text,
                    prompt: Text(placeholder).foregroundColor(.white.opacity(0.35))
                )
                .foregroundColor(.white)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocap)
                .autocorrectionDisabled()
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }

    private func secureField(
        title: String,
        text: Binding<String>,
        placeholder: String,
        isVisible: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 18)

                Group {
                    if isVisible.wrappedValue {
                        TextField(
                            "",
                            text: text,
                            prompt: Text(placeholder).foregroundColor(.white.opacity(0.35))
                        )
                    } else {
                        SecureField(
                            "",
                            text: text,
                            prompt: Text(placeholder).foregroundColor(.white.opacity(0.35))
                        )
                    }
                }
                .foregroundColor(.white)

                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// MARK: - Student Home View (Placeholder)

struct StudentHomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.matterOrange)
            
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            
            Text("Your account has been created successfully.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            NavigationLink {
                StudentProfileView(studentId: "your-user-id")
            } label: {
                Text("View Your Profile")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.matterOrange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)
            }
        }
        .padding()
        .navigationTitle("Student Home")
    }
}

#Preview {
    NavigationStack {
        SignUpPage()
    }
}
