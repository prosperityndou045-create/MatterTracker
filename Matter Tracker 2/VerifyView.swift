//
//  VerifyView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct VerifyView: View {
    @State private var profileID = ""
    @State private var isVerifying = false
    @State private var showResult = false
    @State private var verificationResult: VerificationResult?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.matterNavy.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.matterOrange)
                        
                        Text("Verify a Candidate")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Enter a candidate's profile ID to verify their public portfolio.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Input
                    VStack(spacing: 16) {
                        TextField("Enter Profile ID", text: $profileID)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .textInputAutocapitalization(.characters)
                            .textContentType(.none)
                            .autocorrectionDisabled()
                            .onSubmit {
                                verifyProfile()
                            }
                        
                        Button {
                            verifyProfile()
                        } label: {
                            if isVerifying {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                    Text("Verifying...")
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                Text("Verify Profile")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 14)
                        .background(canVerify ? Color.matterOrange : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!canVerify || isVerifying)
                    }
                    
                    if let error = errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal)
                    }
                    
                    // How it works
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How it works")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Enter a profile ID", systemImage: "number")
                            Label("Check if the profile exists", systemImage: "checkmark.shield")
                            Label("View the candidate's public profile", systemImage: "person.text.rectangle")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Verify")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showResult) {
                if let result = verificationResult {
                    VerificationResultView(result: result)
                }
            }
            .onChange(of: showResult) { _, newValue in
                if !newValue {
                    verificationResult = nil
                    errorMessage = nil
                }
            }
        }
    }
    
    private var canVerify: Bool {
        let trimmed = profileID.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 3
    }
    
    @MainActor
    private func verifyProfile() {
        let trimmedID = profileID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedID.isEmpty else {
            errorMessage = "Please enter a profile ID"
            return
        }
        
        isVerifying = true
        errorMessage = nil
        
        Task {
            do {
                let profile = try await ApiService.shared.publicCandidate(id: trimmedID)
                verificationResult = VerificationResult(
                    isValid: true,
                    profile: profile,
                    profileId: trimmedID,
                    errorMessage: nil
                )
                showResult = true
                isVerifying = false
            } catch {
                verificationResult = VerificationResult(
                    isValid: false,
                    profile: nil,
                    profileId: trimmedID,
                    errorMessage: error.localizedDescription
                )
                showResult = true
                isVerifying = false
            }
        }
    }
}

// MARK: - Verification Result

struct VerificationResult {
    let isValid: Bool
    let profile: PublicProfile?
    let profileId: String
    let errorMessage: String?
}

// MARK: - Verification Result View

struct VerificationResultView: View {
    let result: VerificationResult
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.matterNavy.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Status
                        VStack(spacing: 10) {
                            Image(systemName: result.isValid ? "checkmark.seal.fill" : "xmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(result.isValid ? .green : .red)
                            
                            Text(result.isValid ? "Verified" : "Not Verified")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(result.isValid ? .green : .red)
                            
                            Text(result.isValid ? "This profile ID is valid." : "Profile not found.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 12)
                        
                        if let profile = result.profile, result.isValid {
                            // Profile Info
                            VStack(spacing: 16) {
                                HStack(spacing: 14) {
                                    if let imageUrl = profile.student.profilePictureUrl,
                                       let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Image(systemName: "person.circle.fill")
                                                .font(.system(size: 44))
                                                .foregroundColor(.matterOrange)
                                        }
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.matterOrange, lineWidth: 2))
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.matterOrange)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(profile.student.firstName) \(profile.student.lastName)")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        if let cohort = profile.student.cohort {
                                            Text(cohort.name)
                                                .font(.caption)
                                                .foregroundColor(.matterOrange)
                                        }
                                    }
                                    Spacer()
                                }
                                
                                if let bio = profile.student.bio, !bio.isEmpty {
                                    Text(bio)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                // Stats
                                HStack(spacing: 12) {
                                    VerifyStatBadge(icon: "checkmark.circle.fill", value: "\(profile.skills.count)", label: "Technical")
                                    VerifyStatBadge(icon: "heart.circle.fill", value: "\(profile.essentialSkills.count)", label: "Essential")
                                    VerifyStatBadge(icon: "doc.circle.fill", value: "\(profile.evidence.count)", label: "Evidence")
                                }
                                
                                // Skills
                                if !profile.skills.isEmpty {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Technical Skills")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        FlowLayout(spacing: 6) {
                                            ForEach(profile.skills) { skill in
                                                Text(skill.name)
                                                    .font(.caption)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 4)
                                                    .background(Color.matterOrange.opacity(0.15))
                                                    .foregroundColor(.matterOrange)
                                                    .cornerRadius(4)
                                            }
                                        }
                                    }
                                }
                                
                                if !profile.essentialSkills.isEmpty {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Essential Skills")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        FlowLayout(spacing: 6) {
                                            ForEach(profile.essentialSkills) { skill in
                                                Text(skill.name)
                                                    .font(.caption)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 4)
                                                    .background(Color.green.opacity(0.15))
                                                    .foregroundColor(.green)
                                                    .cornerRadius(4)
                                            }
                                        }
                                    }
                                }
                                
                                // Profile ID
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Profile ID")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(result.profileId)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                        .textSelection(.enabled)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 4)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Verification Result")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
    }
}

// MARK: - Verify Stat Badge

struct VerifyStatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.matterOrange)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Flow Layout

struct VerifyFlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? 0,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, point) in result.offsets.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y),
                proposal: ProposedViewSize(result.sizes[index])
            )
        }
    }
    
    struct FlowResult {
        var offsets: [CGPoint] = []
        var sizes: [CGSize] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var rowHeight: CGFloat = 0
            var maxX: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                sizes.append(size)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += rowHeight + spacing
                    rowHeight = 0
                }
                
                offsets.append(CGPoint(x: currentX, y: currentY))
                
                currentX += size.width + spacing
                maxX = max(maxX, currentX)
                rowHeight = max(rowHeight, size.height)
            }
            
            self.size = CGSize(width: maxX, height: currentY + rowHeight)
        }
    }
}

// MARK: - Preview

#Preview {
    VerifyView()
}
