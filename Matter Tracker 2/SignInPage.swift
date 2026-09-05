//
//  SignInPage.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

// MARK: - Sign-In Role Picker
//
// UI-only choice: it decides which fields show (Guest skips email/password)
// and what the picker displays. It is never sent to the server. Once sign-in
// succeeds, routing is driven by the role the server actually returns
// (`AuthResponse.user.role`, the `UserRole` enum from ApiService.swift) —
// not by whatever was tapped here. Named `SignInRoleOption`, not `UserRole`,
// so it doesn't collide with that server-facing enum.
enum SignInRoleOption: String, CaseIterable, Identifiable {
    case student = "Student"
    case facilitator = "Facilitator"
    case manager = "Manager"
    case guest = "Guest"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .student: return "graduationcap.fill"
        case .facilitator: return "person.2.fill"
        case .manager: return "chart.bar.doc.horizontal.fill"
        case .guest: return "eye.fill"
        }
    }
}

// MARK: - Sign In Page

struct SignInPage: View {
    @State private var selectedRole: SignInRoleOption = .student
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigate = false

    @State private var isLoading = false
    @State private var errorMessage: String?

    /// Set from the server's response after a successful login — `destinationView`
    /// routes on this, not on `selectedRole`.
    @State private var authenticatedRole: UserRole?

    private var isGuest: Bool { selectedRole == .guest }

    private var canSubmit: Bool {
        !isLoading && (isGuest || (!email.isEmpty && !password.isEmpty))
    }

    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 50)

                    // MARK: Logo
                    Image("MatterLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 100)

                    Text("M A T T E R")
                        .font(.system(size: 19, weight: .semibold))
                        .tracking(6)
                        .foregroundColor(.white.opacity(0.55))
                        .padding(.top, 6)

                    Spacer(minLength: 50)

                    VStack(alignment: .leading, spacing: 22) {

                        // Role dropdown on the roles
                        VStack(alignment: .leading, spacing: 8) {
                            Text("I am a")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)

                            Menu {
                                ForEach(SignInRoleOption.allCases) { role in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedRole = role
                                        }
                                    } label: {
                                        Label(role.rawValue, systemImage: role.icon)
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: selectedRole.icon)
                                        .foregroundColor(.white.opacity(0.7))
                                        .frame(width: 18)
                                    Text(selectedRole.rawValue)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 14)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.fieldBorder, lineWidth: 1)
                                )
                            }
                        }

                        if !isGuest {
                            // UserName
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)

                                HStack(spacing: 10) {
                                    Image(systemName: "envelope.open")
                                        .foregroundColor(.white.opacity(0.6))
                                    TextField(
                                        "",
                                        text: $email,
                                        prompt: Text("e.g chapo@example.com")

                                    )
                                    .foregroundColor(.white)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                }
                                .padding(.horizontal, 14)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.fieldBorder, lineWidth: 1)
                                )
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))

                            // Password
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)

                                HStack(spacing: 10) {
                                    Button {
                                        isPasswordVisible.toggle()
                                    } label: {
                                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                            .foregroundColor(.white.opacity(0.6))
                                    }

                                        if isPasswordVisible {
                                            TextField(
                                                "",
                                                text: $password,
                                                prompt: Text("Enter password")
                                            )
                                        } else {
                                            SecureField(
                                                "",
                                                text: $password,
                                                prompt: Text("Enter password")
                                            )
                                        }
                                }
                                .padding(.horizontal, 14)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.fieldBorder, lineWidth: 1)
                                )
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.red.opacity(0.9))
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 28)
                    .animation(.easeInOut(duration: 0.25), value: isGuest)

                    Spacer(minLength: 60)

                    // Sign In / Continue as Guest button
                    Button {
                        signIn()
                    } label: {
                        ZStack {
                            Text(isGuest ? "Continue as Guest" : "Sign In")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(isLoading ? 0 : 1)

                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 27, style: .continuous)
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
                    .padding(.horizontal, 28)

                    if !isGuest {
                        NavigationLink {
                            SignUpPage()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.white.opacity(0.6))

                                Text("Sign Up")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .font(.system(size: 13, weight: .medium))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 18)
                    }

                    Spacer(minLength: 50)
                }
            }
        }
        .navigationDestination(isPresented: $navigate) {
            destinationView
        }
    }

    // MARK: - Sign In

    @MainActor
    private func signIn() {
        guard canSubmit else { return }

        // Guest never touches the API — straight to the guest browse flow.
        if isGuest {
            navigate = true
            return
        }

        errorMessage = nil
        isLoading = true

        Task {
            // Body is @MainActor-isolated because `signIn()` is — no manual
            // `MainActor.run` hop needed either side of the `await`.
            do {
                let auth = try await ApiService.shared.login(email: email, password: password)
                isLoading = false
                authenticatedRole = auth.user.role
                navigate = true
            } catch {
                isLoading = false
                errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    // MARK: - Routing

    @ViewBuilder
    private var destinationView: some View {
        if isGuest {
            GuestBrowseView()
        } else if let authenticatedRole {
            switch authenticatedRole {
            case .student:
                StudentDashboardView()
            case .facilitator:
                FacilitatorDashboardView()
            case .manager:
                ManagerDashboardView()
            case .external_reviewer:
                ExternalReviewerDashboardView()
            }
        } else {
            // navigate only flips true once signIn() has a result — unreachable in practice.
            ProgressView()
        }
    }
}

#Preview {
    NavigationStack {
        SignInPage()
    }
}
