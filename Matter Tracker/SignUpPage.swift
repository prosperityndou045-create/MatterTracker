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
    
    @State private var selectedRole = "Student"
    
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    // MARK: - Role Icon
    
    private var roleIcon: String {
        switch selectedRole {
        case "Student":
            return "graduationcap.fill"
        case "Facilitator":
            return "person.2.fill"
        case "Manager":
            return "person.badge.key.fill"
        default:
            return "person.fill"
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // Sign Up background — #153A55
            Color(
                red: 0x15 / 255.0,
                green: 0x3A / 255.0,
                blue: 0x55 / 255.0
            )
            .ignoresSafeArea()
            
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
                                    Circle()
                                        .stroke(
                                            Color.white.opacity(0.25),
                                            lineWidth: 1
                                        )
                                )
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    
                    // MARK: - Logo
                    
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
                        
                        // MARK: Account Type
                        
                        VStack(alignment: .leading, spacing: 7) {
                            
                            
                            HStack(spacing: 10) {
                                
                                Image(systemName: roleIcon)
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(width: 18)
                                
                                Picker(
                                    "Account Type",
                                    selection: $selectedRole
                                ) {
                                    Text("Student")
                                        .tag("Student")
                                    
                                    Text("Facilitator")
                                        .tag("Facilitator")
                                    
                                    Text("Manager")
                                        .tag("Manager")
                                }
                                .pickerStyle(.menu)
                                .tint(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                                .fill(Color.white.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                                .stroke(
                                    Color.white.opacity(0.2),
                                    lineWidth: 1
                                )
                            )
                        }
                        
                        
                        // MARK: Full Name
                        
                        field(
                            title: "Full Name",
                            icon: "person.fill",
                            text: $fullName,
                            placeholder: selectedRole == "Manager"
                                ? "Admin"
                                : "e.g Mhuka Huru",
                            autocap: .words
                        )
                        .disabled(selectedRole == "Manager")
                        
                        
                        // MARK: Email
                        
                        field(
                            title: "Email",
                            icon: "envelope.fill",
                            text: $email,
                            placeholder: "e.g chapo@example.com",
                            keyboard: .emailAddress,
                            autocap: .never
                        )
                        
                        
                        // MARK: Password
                        
                        secureField(
                            title: "Password",
                            text: $password,
                            placeholder: "Create password",
                            isVisible: $showPassword
                        )
                        
                        
                        // MARK: Confirm Password
                        
                        secureField(
                            title: "Confirm Password",
                            text: $confirmPassword,
                            placeholder: "Confirm password",
                            isVisible: $showConfirmPassword
                        )
                    }
                    
                    
                    // MARK: - Create Account
                    
                    Button {
                        // Account creation goes here
                    } label: {
                        
                        Text("Create Account")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 26,
                                    style: .continuous
                                )
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .matterOrange,
                                            .matterOrangeDk
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            )
                    }
                    .padding(.top, 22)
                    
                    
                    // MARK: - OR
                    
                    HStack {
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.45))
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 18)
                    
                    
                    // MARK: - Continue with Google
                    
                    Button {
                        // Google Sign In will go here
                    } label: {
                        
                        HStack(spacing: 12) {
                            
                            Text("G")
                                .font(.system(size: 19, weight: .bold))
                            
                            Text("Continue with Google")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                            .stroke(
                                Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                        )
                    }
                    
                    
                    // MARK: - Continue with Apple
                    
                    Button {
                        // Apple Sign In will go here
                    } label: {
                        
                        HStack(spacing: 12) {
                            
                            Image(systemName: "apple.logo")
                                .font(.system(size: 18))
                            
                            Text("Continue with Apple")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                            .stroke(
                                Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                        )
                    }
                    .padding(.top, 10)
                    
                    
                    // MARK: - Continue with Microsoft
                    
                    Button {
                        // Microsoft Sign In will go here
                    } label: {
                        
                        HStack(spacing: 12) {
                            
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 17))
                            
                            Text("Continue with Microsoft")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                            .stroke(
                                Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                        )
                    }
                    .padding(.top, 10)
                    
                    
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
                                .underline()
                        }
                    }
                    .font(.system(size: 13))
                    .padding(.top, 18)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 28)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Manager Name
        
        .onChange(of: selectedRole) { _, newRole in
            
            if newRole == "Manager" {
                fullName = "Admin"
            }
            else if fullName == "Admin" {
                fullName = ""
            }
        }
    }
    
    
    // MARK: - Reusable Field Builder
    
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
                    prompt: Text(placeholder)
                        .foregroundColor(.white.opacity(0.35))
                )
                .foregroundColor(.white)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocap)
                .autocorrectionDisabled()
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: 1
                )
            )
        }
    }
    
    
    // MARK: - Secure Field Builder
    
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
                            prompt: Text(placeholder)
                                .foregroundColor(.white.opacity(0.35))
                        )
                        
                    } else {
                        
                        SecureField(
                            "",
                            text: text,
                            prompt: Text(placeholder)
                                .foregroundColor(.white.opacity(0.35))
                        )
                    }
                }
                .foregroundColor(.white)
                
                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    
                    Image(
                        systemName: isVisible.wrappedValue
                        ? "eye.fill"
                        : "eye.slash.fill"
                    )
                    .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: 1
                )
            )
        }
    }
}

#Preview {
    NavigationStack {
        SignUpPage()
    }
}
