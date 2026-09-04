//
//  SignInPage.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

//
//  SignInPage.swift
//  Matter Tracker
//

import SwiftUI


extension Color {
    static let matterNavy      = Color(red: 0.10, green: 0.16, blue: 0.28)
    static let matterOrange    = Color(red: 0.92, green: 0.42, blue: 0.20)
    static let matterOrangeDk  = Color(red: 0.75, green: 0.28, blue: 0.12)
    static let fieldBorder     = Color.white.opacity(0.25)
    static let placeholderGray = Color.white.opacity(0.45)
}

// MARK: - Role Model

enum UserRole: String, CaseIterable, Identifiable {
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
    @State private var selectedRole: UserRole = .student
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigate = false
    
    private var isGuest: Bool { selectedRole == .guest }
    
    private var canSubmit: Bool {
        isGuest || (!username.isEmpty && !password.isEmpty)
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
                                ForEach(UserRole.allCases) { role in
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
                                Text("UserName")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 10) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white.opacity(0.6))
                                    TextField(
                                        "",
                                        text: $username,
                                        prompt: Text("e.g. lennon@gmail.com")
                                            .foregroundColor(.placeholderGray)
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
                                    
                                    Group {
                                        if isPasswordVisible {
                                            TextField(
                                                "",
                                                text: $password,
                                                prompt: Text("Enter password")
                                                    .foregroundColor(.placeholderGray)
                                            )
                                        } else {
                                            SecureField(
                                                "",
                                                text: $password,
                                                prompt: Text("Enter password")
                                                    .foregroundColor(.placeholderGray)
                                            )
                                        }
                                    }
                                    .foregroundColor(.white)
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
                    }
                    .padding(.horizontal, 28)
                    .animation(.easeInOut(duration: 0.25), value: isGuest)
                    
                    Spacer(minLength: 60)
                    
                    // Sign In / Continue as Guest button
                    Button {
                        // TODO: call ApiService sign-in here for non-guest roles,
                        // then set navigate = true only on success.
                        navigate = true
                    } label: {
                        Text(isGuest ? "Continue as Guest" : "Sign In")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
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
                        NavigationLink("Don't have an account? Sign Up") {
                            SignUpPage()
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
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
    
    // MARK: - Routing
    
    @ViewBuilder
    private var destinationView: some View {
        switch selectedRole {
        case .student:
            StudentProfileView(student: Student(name: "Chapo", email: "chapo@example.com", progress: 40, skillsCompleted: 2, totalSkills: 5))
        case .facilitator, .manager, .guest:
            DashboardView()   // swap in FacilitatorDashboardView / ManagerDashboardView once you create them
        }
    }
}

#Preview {
    NavigationStack {
        SignInPage()
    }
}
