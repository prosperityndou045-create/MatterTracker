//
//  StudentProfileDataManager.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI
import Observation

// MARK: - Data Models

enum SkillStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case demonstrated = "Demonstrated"
    case needsReview = "Needs Review"
    
    var color: Color {
        switch self {
        case .notStarted: return .gray
        case .inProgress: return .orange
        case .demonstrated: return .green
        case .needsReview: return .blue
        }
    }
}

enum AttachmentType: String, CaseIterable, Identifiable, Codable {
    case photo = "Photo / Image"
    case video = "Video File"
    case document = "Document File"
    case gitHub = "GitHub / Web Link"
    case codeSample = "Code Sample"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .photo: return "photo.fill"
        case .video: return "video.fill"
        case .document: return "doc.fill"
        case .gitHub: return "network"
        case .codeSample: return "chevron.left.forward.slash"
        }
    }
}

// Model for an individual attached file, image, video, or link
struct Attachment: Identifiable, Equatable, Hashable {
    let id: UUID
    var type: AttachmentType
    var fileData: Data?
    var fileName: String?
    var urlOrText: String
    
    init(
        id: UUID = UUID(),
        type: AttachmentType,
        fileData: Data? = nil,
        fileName: String? = nil,
        urlOrText: String = ""
    ) {
        self.id = id
        self.type = type
        self.fileData = fileData
        self.fileName = fileName
        self.urlOrText = urlOrText
    }
}

// Model for an evidence submission containing multiple attachments
struct Evidence: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var reviewer: String
    var status: SkillStatus
    var attachments: [Attachment]
    
    init(
        id: UUID = UUID(),
        title: String,
        reviewer: String,
        status: SkillStatus,
        attachments: [Attachment] = []
    ) {
        self.id = id
        self.title = title
        self.reviewer = reviewer
        self.status = status
        self.attachments = attachments
    }
}

struct SkillRecord: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var type: SkillType = .technical
    var description: String
    var evidences: [Evidence]
    
    var currentStatus: SkillStatus {
        if evidences.contains(where: { $0.status == .demonstrated }) {
            return .demonstrated
        } else if evidences.contains(where: { $0.status == .needsReview }) {
            return .needsReview
        } else if !evidences.isEmpty {
            return .inProgress
        }
        return .notStarted
    }
    
    init(id: UUID = UUID(), name: String, type: SkillType = .technical, description: String, evidences: [Evidence] = []) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.evidences = evidences
    }
}

struct Student: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var email: String
    var cohort: String
    var bio: String
    var profileImageData: Data?
    var isCurrentUser: Bool
    var skills: [SkillRecord]
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        cohort: String,
        bio: String = "",
        profileImageData: Data? = nil,
        isCurrentUser: Bool = false,
        skills: [SkillRecord] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.cohort = cohort
        self.bio = bio
        self.profileImageData = profileImageData
        self.isCurrentUser = isCurrentUser
        self.skills = skills
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var demonstratedSkillsCount: Int {
        skills.filter { $0.currentStatus == .demonstrated }.count
    }
    
    var totalSkillsCount: Int {
        skills.count
    }
}


// MARK: - Weekly Status Report

/// Which Swift curriculum book the student is currently working through.
enum SwiftBook: String, CaseIterable, Identifiable, Codable {
    case explorations = "Develop in Swift Explorations"
    case fundamentals = "Develop in Swift Fundamentals"
    
    var id: String { rawValue }
    
    /// Short label for compact UI (badges, cards)
    var shortName: String {
        switch self {
        case .explorations: return "Explorations"
        case .fundamentals: return "Fundamentals"
        }
    }
}

/// A single weekly check-in: a BoldVoice score plus which book/section the
/// student is currently on, dated so a history builds up over time.
struct WeeklyStatusEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var date: Date
    var boldVoiceScore: Int
    var book: SwiftBook
    var section: String
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        boldVoiceScore: Int,
        book: SwiftBook,
        section: String
    ) {
        self.id = id
        self.date = date
        self.boldVoiceScore = boldVoiceScore
        self.book = book
        self.section = section
    }
}

// MARK: - App Data Manager

@Observable
class AppDataManager {
    var name: String
    var email: String
    var cohort: String
    var bio: String
    var profileImageData: Data?
    
    var students: [Student]
    
    // Weekly status report history, newest first once sorted by callers.
    // Persisted separately from the simple profile fields since it's a
    // growing list, not a handful of strings.
    var weeklyReports: [WeeklyStatusEntry]
    
    private static let weeklyReportsKey = "weekly_status_reports"
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "profile_name") ?? "Alex Rivera"
        self.email = UserDefaults.standard.string(forKey: "profile_email") ?? "alex.rivera@example.edu"
        self.cohort = UserDefaults.standard.string(forKey: "profile_cohort") ?? "Cohort 12"
        self.bio = UserDefaults.standard.string(forKey: "profile_bio") ?? "Passionate about building SwiftUI applications."
        self.profileImageData = UserDefaults.standard.data(forKey: "profile_image")
        
        self.students = [
            Student(
                name: UserDefaults.standard.string(forKey: "profile_name") ?? "Alex Rivera",
                email: UserDefaults.standard.string(forKey: "profile_email") ?? "alex.rivera@example.edu",
                cohort: UserDefaults.standard.string(forKey: "profile_cohort") ?? "Cohort 12",
                bio: UserDefaults.standard.string(forKey: "profile_bio") ?? "Passionate about building SwiftUI applications.",
                profileImageData: UserDefaults.standard.data(forKey: "profile_image"),
                isCurrentUser: true
            )
        ]
        
        if let data = UserDefaults.standard.data(forKey: Self.weeklyReportsKey),
           let decoded = try? JSONDecoder().decode([WeeklyStatusEntry].self, from: data) {
            self.weeklyReports = decoded
        } else {
            self.weeklyReports = []
        }
    }
    
    func saveProfile() {
        UserDefaults.standard.set(name, forKey: "profile_name")
        UserDefaults.standard.set(email, forKey: "profile_email")
        UserDefaults.standard.set(cohort, forKey: "profile_cohort")
        UserDefaults.standard.set(bio, forKey: "profile_bio")
        UserDefaults.standard.set(profileImageData, forKey: "profile_image")
        
        // Update the current user in students array
        if let index = students.firstIndex(where: { $0.isCurrentUser }) {
            students[index].name = name
            students[index].email = email
            students[index].cohort = cohort
            students[index].bio = bio
            students[index].profileImageData = profileImageData
        }
    }
    
    // MARK: Weekly Status Report persistence
    
    /// Adds a new weekly check-in and saves immediately, so it survives
    /// day-to-day app restarts.
    func addWeeklyReport(_ entry: WeeklyStatusEntry) {
        weeklyReports.append(entry)
        saveWeeklyReports()
    }
    
    func deleteWeeklyReport(at offsets: IndexSet) {
        weeklyReports.remove(atOffsets: offsets)
        saveWeeklyReports()
    }
    
    private func saveWeeklyReports() {
        if let encoded = try? JSONEncoder().encode(weeklyReports) {
            UserDefaults.standard.set(encoded, forKey: Self.weeklyReportsKey)
        }
    }
}
