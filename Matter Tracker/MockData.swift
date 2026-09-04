//
//  MockData.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import Foundation

enum MockData {

    // MARK: - Sample profile (shown in the "Sample profile" guest tab)

    static let sampleProfile = StudentProfile(
        name: "Tendai Moyo",
        cohort: "Cohort 5",
        summary: "Six-month full-stack track. This is a read-only view shared by the candidate, evidence marked private is not shown.",
        skills: [
            Skill(
                name: "Loops",
                category: "Technical skills",
                status: .demonstrated,
                evidence: [Evidence(type: "Swift challenges", attachment: "loops-challenge-04.py", reviewer: "Facilitator - Peggy", isPublic: true)]
            ),
            Skill(
                name: "Functions",
                category: "Technical skills",
                status: .demonstrated,
                evidence: [Evidence(type: "GitHub repository", attachment: "github.com/tmoyo/task-tracker", reviewer: "Facilitator - Peggy", isPublic: true)]
            ),
            Skill(
                name: "Version control",
                category: "Technical skills",
                status: .demonstrated,
                evidence: [Evidence(type: "Project", attachment: "github.com/tmoyo/group-capstone", reviewer: "Facilitator — Lennon", isPublic: true)]
            ),
            Skill(
                name: "Data structures",
                category: "Technical skills",
                status: .demonstrated,
                evidence: [Evidence(type: "Assessment", attachment: "assessment-ds-02.pdf", reviewer: "Facilitator Peggy", isPublic: true)]
            ),
            Skill(
                name: "Debugging",
                category: "Technical skills",
                status: .demonstrated,
                evidence: [Evidence(type: "Code sample", attachment: "debug-log-writeup.md", reviewer: "Facilitator Pegggy", isPublic: true)]
            ),
            Skill(
                name: "Communication",
                category: "Essential skills",
                status: .demonstrated,
                evidence: [Evidence(type: "Video — sprint demo", attachment: "sprint-3-demo.mp4", reviewer: "External reviewer — Terence", isPublic: true)]
            ),
            Skill(
                name: "Teamwork",
                category: "Essential skills",
                status: .inProgress,
                evidence: [Evidence(type: "Facilitator feedback", attachment: "Pending final review", reviewer: "Facilitator — Lennon", isPublic: false)]
            ),
            Skill(
                name: "Problem solving",
                category: "Essential skills",
                status: .demonstrated,
                evidence: [Evidence(type: "LTC challenge", attachment: "problem-set-07.py", reviewer: "Facilitator — Lennon", isPublic: true)]
            ),
            Skill(
                name: "Time management",
                category: "Essential skills",
                status: .notStarted,
                evidence: []
            ),
            Skill(
                name: "Adaptability",
                category: "Essential skills",
                status: .inProgress,
                evidence: [Evidence(type: "Facilitator feedback", attachment: "Pending final review", reviewer: "Facilitator — Peggy", isPublic: false)]
            ),
        ]
    )

    // MARK: - Skills framework (shown in the "Skills framework" guest tab)

    struct FrameworkEntry: Identifiable {
        let id = UUID()
        let name: String
        let description: String
    }

    struct FrameworkGroup: Identifiable {
        let id = UUID()
        let category: String
        let entries: [FrameworkEntry]
    }

    static let skillsFramework: [FrameworkGroup] = [
        FrameworkGroup(category: "Technical skills", entries: [
            FrameworkEntry(name: "Loops", description: "Writing and reasoning about repeated logic (for, while, iteration patterns)."),
            FrameworkEntry(name: "Functions", description: "Decomposing a problem into reusable, well-named units of logic."),
            FrameworkEntry(name: "Version control", description: "Using git and GitHub to track, branch, and share work."),
            FrameworkEntry(name: "Data structures", description: "Choosing and using arrays, objects, and collections appropriately."),
            FrameworkEntry(name: "Debugging", description: "Diagnosing and fixing defects using a repeatable method, not guesswork."),
        ]),
        FrameworkGroup(category: "Essential skills", entries: [
            FrameworkEntry(name: "Communication", description: "Explaining technical ideas clearly to technical and non-technical audiences."),
            FrameworkEntry(name: "Teamwork", description: "Collaborating on shared work, giving and receiving feedback."),
            FrameworkEntry(name: "Problem solving", description: "Breaking down ambiguous problems and working through them methodically."),
            FrameworkEntry(name: "Time management", description: "Planning and delivering work against a deadline."),
            FrameworkEntry(name: "Adaptability", description: "Responding well to changing requirements or unfamiliar tools."),
        ]),
    ]
}
