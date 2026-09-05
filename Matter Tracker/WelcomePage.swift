//
//  WelcomePage.swift
//  Matter Tracker
//
//  Created by TAKUE on 4/9/2026.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(
            string: hex
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "#", with: "")
        )
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct WelcomePage: View {
    
    // Animation states
    @State private var showWelcome = false
    @State private var showTagline = false
    @State private var showDescription = false
    @State private var showButton = false
    @State private var arrowMoving = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Background Image
                
                Image("WelcomePageBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // MARK: - Blue Overlay
                
                Color(hex: "#153A55")
                    .opacity(0.75)
                    .ignoresSafeArea()
                
                
                // MARK: - Content
                
                VStack {
                    
                    Spacer()
                    
                    // MARK: - Welcome Section
                    
                    VStack(spacing: 14) {
                        
                        Text("Welcome")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(showWelcome ? 1 : 0)
                            .offset(y: showWelcome ? 0 : -25)
                        
                        
                        Text("Your skills have a story.")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .opacity(showTagline ? 1 : 0)
                            .offset(y: showTagline ? 0 : -20)
                        
                        
                        Text("Build your journey. Capture your progress.\nShowcase what you can do.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .opacity(showDescription ? 1 : 0)
                            .offset(y: showDescription ? 0 : -15)
                    }
                    
                    Spacer()
                    
                    
                    // MARK: - Get Started
                    
                    NavigationLink {
                        SignInPage()
                    } label: {
                        
                        HStack(spacing: 12) {
                            
                            Text("Get Started")
                                .font(.system(size: 18, weight: .bold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                                .offset(x: arrowMoving ? 5 : 0)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#FF6825"))
                        )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .opacity(showButton ? 1 : 0)
                    .offset(y: showButton ? 0 : 35)
                }
            }
            .onAppear {
                
                // Welcome appears first
                withAnimation(.easeOut(duration: 0.7)) {
                    showWelcome = true
                }
                
                // Tagline appears second
                withAnimation(
                    .easeOut(duration: 0.7)
                    .delay(0.25)
                ) {
                    showTagline = true
                }
                
                // Description appears third
                withAnimation(
                    .easeOut(duration: 0.7)
                    .delay(0.45)
                ) {
                    showDescription = true
                }
                
                // Button appears last
                withAnimation(
                    .easeOut(duration: 0.8)
                    .delay(0.7)
                ) {
                    showButton = true
                }
                
                // Moving arrow
                withAnimation(
                    .easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true)
                ) {
                    arrowMoving = true
                }
            }
        }
    }
}

#Preview {
    WelcomePage()
}

