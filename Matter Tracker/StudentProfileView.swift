//
//  StudentProfileView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
import SwiftUI
import PhotosUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: ""))
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)

    let r = Double((rgb & 0xFF0000) >> 16) / 255.0
    let g = Double((rgb & 0x00FF00) >> 8) / 255.0
    let b = Double(rgb & 0x0000FF) / 255.0

    self.init(red: r, green: g, blue: b)
}
}
// MARK: - Profile View

struct ProfileView: View {
    
    @Environment(AppDataManager.self) private var dataManager
    
    // MARK: Profile Information
    // name, email, cohort, bio, and the photo now come from AppDataManager
    // (shared with StudentDashboardView) instead of local @State, so edits
    // made here show up on the Dashboard immediately.
    
    // TODO: AppDataManager doesn't have studentID/yearLevel yet, so these
    // stay local-only for now. Add `var studentID: String` and
    // `var yearLevel: String` to AppDataManager (with saveProfile() support)
    // if you want these to persist and sync too.
    @State private var studentID = "MCRI-2026-8941"
    @State private var yearLevel = "Phase 4"
    
    // MARK: Editing
    
    @State private var isEditing = false
    
    @State private var editName = ""
    @State private var editEmail = ""
    @State private var editCohort = ""
    @State private var editBio = ""
    @State private var editStudentID = ""
    @State private var editYearLevel = ""
    
    // MARK: Photo
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    // MARK: Theme
    
    private let navy = Color(
        red: 0.09,
        green: 0.13,
        blue: 0.22
    )
    
    private let orange = Color(
        red: 0.91,
        green: 0.44,
        blue: 0.19
    )
    
    // MARK: Body
    
 
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geo in
                
                ZStack {
                    
                    // MARK: - Background
                    Image("WelcomePageBackground")
                            .resizable()
                            .ignoresSafeArea()

                    Color(hex: "#153A55")
                            .opacity(0.55) // adjust so it reads clearly over the image
                            .ignoresSafeArea()
                    
                    // MARK: - Profile Content
                    
                    ScrollView {
                        
                        VStack(spacing: 0) {
                            
                            studentCard(minHeight: geo.size.height - 30)
                                .padding(.top, 30)
                            
                            Spacer(minLength: 20)
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                    }
                }
            }
            
            // MARK: - Navigation
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.system(size: 25, weight: .bold)) // Adjust size here
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(
                navy,
                for: .navigationBar
            )
            .toolbarBackground(
                .visible,
                for: .navigationBar
            )
            .toolbarColorScheme(
                .dark,
                for: .navigationBar
            )
            .listStyle(.insetGrouped)
            .toolbar {
                
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    
                    Button {
                        editButtonPressed()
                    } label: {
                        
                        Text(
                            isEditing
                            ? "Save"
                            : "Edit"
                        )
                        .fontWeight(.semibold)
                        .foregroundStyle(navy)
                    }
                }
            }
        }
    }
    // MARK: - Student Card
    
    private func studentCard(minHeight: CGFloat) -> some View {
        
        VStack(spacing: 0) {
            
            cardHeader
            
            VStack(spacing: 0) {
                
                profilePhoto
                
                    .padding(.top, -60)
                
                profileDetails
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 25)
                
                Spacer(minLength: 0)
            }
            .background(Color.white)
        }
        .frame(minHeight: minHeight)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(orange, lineWidth: 5)
        )
        .shadow(
            color: .black.opacity(0.3),
            radius: 14,
            y: 8
        )
        .padding(.horizontal, 10)
    }
    
    // MARK: - Card Header
    
    private var cardHeader: some View {
        
        HStack(alignment: .top) {
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text("MCRI")
                    .font(
                        .system(
                            size: 17,
                            weight: .heavy
                        )
                    )
                    .foregroundStyle(.white)
                
                Text("STUDENT PORTAL ")
                    .font(
                        .system(
                            size: 10,
                            weight: .semibold
                        )
                    )
                    .tracking(0.5)
                    .foregroundStyle(
                        .white.opacity(0.85)
                    )
            }
            
            Spacer()
            
            Text("ACTIVE")
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    .white.opacity(0.2)
                )
                .clipShape(Capsule())
        }
        .padding(20)
        .background(navy)
    }
    
    // MARK: - Profile Photo
    
    private var profilePhoto: some View {
        
        VStack(spacing: 8) {
            
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                
                ZStack {
                    
                    // Curved "halo" behind the avatar — bridges the navy
                    // header and the white card body with a soft scoop
                    // rather than the photo just sitting on a flat edge.
                    Circle()
                        .fill(Color.white)
                        .frame(
                            width: 128,
                            height: 128
                        )
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: 6,
                            y: 3
                        )
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        Group {
                            
                            if let imageData = dataManager.profileImageData,
                               let uiImage = UIImage(data: imageData) {
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                
                            } else {
                                
                                Image(
                                    systemName: "person.fill"
                                )
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                                .padding(26)
                                .background(
                                    Color.gray.opacity(0.15)
                                )
                            }
                        }
                        .frame(
                            width: 108,
                            height: 108
                        )
                        .clipShape(Circle())
                        .overlay {
                            
                            Circle()
                                .stroke(
                                    .white,
                                    lineWidth: 4
                                )
                        }
                        .shadow(radius: 4)
                        
                        if isEditing {
                            
                            Circle()
                                .fill(orange)
                                .frame(
                                    width: 34,
                                    height: 34
                                )
                                .overlay {
                                    
                                    Image(
                                        systemName: "camera.fill"
                                    )
                                    .font(
                                        .system(
                                            size: 14,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(.white)
                                }
                                .overlay {
                                    
                                    Circle()
                                        .stroke(
                                            .white,
                                            lineWidth: 2
                                        )
                                }
                        }
                    }
                }
            }
            .onChange(
                of: selectedPhoto
            ) {
                _,
                newPhoto in
                
                loadPhoto(newPhoto)
            }
            
            if isEditing {
                
                TextField(
                    "Full Name",
                    text: $editName
                )
                .font(
                    .system(
                        size: 19,
                        weight: .bold
                    )
                )
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.words)
                .padding(.top, 5)
                
                TextField(
                    "Student ID",
                    text: $editStudentID
                )
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                
            } else {
                
                Text(dataManager.name)
                    .font(
                        .system(
                            size: 19,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                    .padding(.top, 5)
                
                Text(
                    "STUDENT ID: \(studentID)"
                )
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Profile Details
    
    private var profileDetails: some View {
        
        VStack(spacing: 14) {
            
            ProfileDetailRow(
                icon: "graduationcap",
                title: "STUDENT COHORT",
                value: isEditing
                    ? $editCohort
                    : .constant(dataManager.cohort),
                isEditing: isEditing
            )
            
            Divider()
            
            ProfileDetailRow(
                icon: "star",
                title: "STUDENT PHASE",
                value: isEditing
                    ? $editYearLevel
                    : .constant(yearLevel),
                isEditing: isEditing
            )
            
            Divider()
            
            ProfileDetailRow(
                icon: "envelope",
                title: "EMAIL ADDRESS",
                value: isEditing
                    ? $editEmail
                    : .constant(dataManager.email),
                isEditing: isEditing,
                keyboardType: .emailAddress
            )
            
            Divider()
            
            ProfileDetailRow(
                icon: "person",
                title: "BIO",
                value: isEditing
                    ? $editBio
                    : .constant(dataManager.bio),
                isEditing: isEditing,
                isMultiline: true
            )
        }
    }
    
    // MARK: - Edit Button
    
    private func editButtonPressed() {
        
        if isEditing {
            
            // Save changes back to the shared AppDataManager,
            // so the Dashboard (and any other view) picks them up too.
            
            dataManager.name = editName
            dataManager.email = editEmail
            dataManager.cohort = editCohort
            dataManager.bio = editBio
            dataManager.saveProfile()
            
            // TODO: not yet part of AppDataManager — see note at top of file
            studentID = editStudentID
            yearLevel = editYearLevel
            
        } else {
            
            // Copy existing values into
            // editing fields
            
            editName = dataManager.name
            editEmail = dataManager.email
            editCohort = dataManager.cohort
            editBio = dataManager.bio
            editStudentID = studentID
            editYearLevel = yearLevel
        }
        
        withAnimation {
            isEditing.toggle()
        }
    }
    
    // MARK: - Load Photo
    
    private func loadPhoto(
        _ photo: PhotosPickerItem?
    ) {
        
        guard let photo else {
            return
        }
        
        Task {
            
            do {
                
                if let data =
                    try await photo.loadTransferable(
                        type: Data.self
                    ) {
                    
                    await MainActor.run {
                        
                        dataManager.profileImageData = data
                        dataManager.saveProfile()
                    }
                }
                
            } catch {
                
                print(
                    "Unable to load photo: \(error)"
                )
            }
        }
    }
}

// MARK: - Profile Detail Row

struct ProfileDetailRow: View {
    
    let icon: String
    let title: String
    
    @Binding var value: String
    
    let isEditing: Bool
    
    var keyboardType: UIKeyboardType = .default
    
    var isMultiline = false
    
    private let orange = Color(
        red: 0.91,
        green: 0.44,
        blue: 0.19
    )
    
    var body: some View {
        
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            
            Image(systemName: icon)
                .font(
                    .system(
                        size: 15
                    )
                )
                .foregroundStyle(orange)
                .frame(
                    width: 20
                )
                .padding(
                    .top,
                    isEditing ? 5 : 2
                )
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                Text(title)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.gray)
                
                if isEditing {
                    
                    if isMultiline {
                        
                        TextEditor(
                            text: $value
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .frame(height: 75)
                        .padding(6)
                        .background(
                            Color(
                                .secondarySystemBackground
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 8
                            )
                        )
                        
                    } else {
                        
                        TextField(
                            title,
                            text: $value
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .keyboardType(
                            keyboardType
                        )
                        .textInputAutocapitalization(
                            .never
                        )
                        .autocorrectionDisabled()
                        .padding(9)
                        .background(
                            Color(
                                .secondarySystemBackground
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 8
                            )
                        )
                    }
                    
                } else {
                    
                    Text(
                        value.isEmpty
                        ? "Not provided"
                        : value
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environment(AppDataManager())
}
