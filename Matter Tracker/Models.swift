//
//  Models.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import Foundation

enum ReviewStatus: String, Codable {
    case demonstrated = "Demonstrated"
    case inProgress = "In progress"
    case notStarted = "Not started"
}

struct Evidence: Identifiable, Codable {
    let id: UUID
    var type: String
    var attachment: String
    var reviewer: String
    var isPublic: Bool

    init(id: UUID = UUID(), type: String, attachment: String, reviewer: String, isPublic: Bool) {
        self.id = id
        self.type = type
        self.attachment = attachment
        self.reviewer = reviewer
        self.isPublic = isPublic
    }
}

struct Skill: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var status: ReviewStatus
    var evidence: [Evidence]

    init(id: UUID = UUID(), name: String, category: String, status: ReviewStatus, evidence: [Evidence] = []) {
        self.id = id
        self.name = name
        self.category = category
        self.status = status
        self.evidence = evidence
    }
}

struct StudentProfile: Identifiable, Codable {
    let id: UUID
    var name: String
    var cohort: String
    var summary: String
    var skills: [Skill]

    init(id: UUID = UUID(), name: String, cohort: String, summary: String, skills: [Skill] = []) {
        self.id = id
        self.name = name
        self.cohort = cohort
        self.summary = summary
        self.skills = skills
    }

    var demonstratedCount: Int {
        skills.filter { $0.status == .demonstrated }.count
    }

    var completionPercent: Int {
        guard !skills.isEmpty else { return 0 }
        return Int((Double(demonstratedCount) / Double(skills.count) * 100).rounded())
    }
}
