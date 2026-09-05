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


enum EvidenceType: String, Codable {
    case codeSample = "Code Sample"
    case challenge = "LTC Challenge"
    case github = "GitHub Repository"
    case video = "Video"
    case project = "Project"
    case feedback = "Facilitator Feedback"
    case assessment = "Assessment"
}

enum EvidenceStatus: String, Codable {
    case pending = "Pending"
    case verified = "Verified"
    case rejected = "Rejected"
}

struct Evidence: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: EvidenceType
    let status: EvidenceStatus
    let reviewer: String?
    let reviewerRole: String?
    let dateSubmitted: Date
    let attachmentURL: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: EvidenceType,
        status: EvidenceStatus,
        reviewer: String? = nil,
        reviewerRole: String? = nil,
        dateSubmitted: Date = Date(),
        attachmentURL: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.status = status
        self.reviewer = reviewer
        self.reviewerRole = reviewerRole
        self.dateSubmitted = dateSubmitted
        self.attachmentURL = attachmentURL
    }
}
//--------------------------------------------------------------------

enum SkillStatus: String, Codable {
    case demonstrated = "Demonstrated"
    case inProgress = "In Progress"
    case notStarted = "Not Started"
}

enum SkillCategory: String, Codable {
    case technical = "Technical"
    case essential = "Essential"
}

struct Skill: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: SkillCategory
    let status: SkillStatus
    let description: String
    let evidence: [Evidence]
    
    init(
        id: UUID = UUID(),
        name: String,
        category: SkillCategory,
        status: SkillStatus,
        description: String,
        evidence: [Evidence] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.status = status
        self.description = description
        self.evidence = evidence
    }
}

//-----------------------------------------------------------------------

struct StudentProfile: Identifiable, Codable {
    let id: UUID
    let profileID: String
    let name: String
    let cohort: String
    let bio: String
    
    let skills: [Skill]
    let projects: [Project]
    let achievements: [Achievement]
    
    let isPublic: Bool
    
    var demonstratedCount: Int {
        skills.filter {
            $0.status == .demonstrated
        }.count
    }
    
    var inProgressCount: Int {
        skills.filter {
            $0.status == .inProgress
        }.count
    }
    
    var completionPercent: Int {
        guard !skills.isEmpty else {
            return 0
        }
        
        return Int(
            (Double(demonstratedCount) / Double(skills.count)) * 100
        )
    }
    
    var verifiedEvidenceCount: Int {
        skills
            .flatMap { $0.evidence }
            .filter {
                $0.status == .verified
            }
            .count
    }
    
    var allEvidence: [Evidence] {
        skills.flatMap { $0.evidence }
    }
    
    init(
        id: UUID = UUID(),
        profileID: String,
        name: String,
        cohort: String,
        bio: String,
        skills: [Skill],
        projects: [Project],
        achievements: [Achievement],
        isPublic: Bool = true
    ) {
        self.id = id
        self.profileID = profileID
        self.name = name
        self.cohort = cohort
        self.bio = bio
        self.skills = skills
        self.projects = projects
        self.achievements = achievements
        self.isPublic = isPublic
    }
}

//-----------------------------------------------------------------------

struct Project: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let technologies: [String]
    let skillsDemonstrated: [String]
    let evidence: [Evidence]
    let repositoryURL: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        technologies: [String],
        skillsDemonstrated: [String],
        evidence: [Evidence] = [],
        repositoryURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.technologies = technologies
        self.skillsDemonstrated = skillsDemonstrated
        self.evidence = evidence
        self.repositoryURL = repositoryURL
    }
}

//-----------------------------------------------------------------------


enum AchievementType: String, Codable {
    case award = "Award"
    case certification = "Certification"
    case recognition = "Recognition"
    case program = "Completed Program"
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: AchievementType
    let date: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: AchievementType,
        date: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.date = date
    }
}

//------------------------------------------------------------------

enum MockData {
    
    // MARK: - Evidence
    
    static let marketMateEvidence = Evidence(
        title: "MarketMate Project",
        description: """
        A personal inventory management application demonstrating
        practical Swift development, application architecture,
        data management and problem solving.
        """,
        type: .project,
        status: .verified,
        reviewer: "Lennon",
        reviewerRole: "MCRI Facilitator"
    )

    
    static let swiftAssessmentEvidence = Evidence(
        title: "Swift Fundamentals Assessment",
        description: """
        Assessment demonstrating understanding of core Swift
        programming concepts including variables, optionals,
        collections, control flow, functions, structs and classes.
        """,
        type: .assessment,
        status: .verified,
        reviewer: "Lennon",
        reviewerRole: "MCRI Facilitator"
    )
    
    static let loopsEvidence = Evidence(
        title: "Swift Loops Challenge",
        description: """
        Programming challenge demonstrating the use of
        loops and iteration.
        """,
        type: .challenge,
        status: .verified,
        reviewer: "Lennon",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/Butjilo01/MARKETMATE-PERSONAL-PROJECT"
    )
    
    static let communicationEvidence = Evidence(
        title: "Project Presentation",
        description: """
        Presentation demonstrating technical communication
        and explanation of project decisions.
        """,
        type: .video,
        status: .verified,
        reviewer: "Peggy",
        reviewerRole: "MCRI Facilitator"
    )
    
    // MARK: - Real GitHub Evidence
    
    static let butjiloGitHubEvidence = Evidence(
        title: "MARKETMATE-PERSONAL-PROJECT",
        description: """
        Public GitHub repository containing Butjilo's MarketMate
        personal project and development work.
        """,
        type: .github,
        status: .verified,
        reviewer: "Faith",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/Butjilo01/MARKETMATE-PERSONAL-PROJECT"
    )
    
    static let studentTwoGitHubEvidence = Evidence(
        title: "MCRI.APP",
        description: """
        Public GitHub repository containing the student's
        MCRI application project and development work.
        """,
        type: .github,
        status: .verified,
        reviewer: "Faith",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/Bongan16/MCRI.APP"
    )
    
    static let studentThreeGitHubEvidence = Evidence(
        title: "Village Water Monitor",
        description: """
        Public GitHub repository containing the Village Water
        Monitor project and associated development work.
        """,
        type: .github,
        status: .verified,
        reviewer: "Faith",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/mabungutanatswa2018-create/village-water-monitor"
    )
    
    
    // MARK: - Skills
    
    static let swiftSkill = Skill(
        name: "Swift",
        category: .technical,
        status: .demonstrated,
        description: """
        Ability to develop applications using the Swift
        programming language.
        """,
        evidence: [
            marketMateEvidence,
            swiftAssessmentEvidence
        ]
    )
    
    static let loopsSkill = Skill(
        name: "Loops",
        category: .technical,
        status: .demonstrated,
        description: """
        Ability to use loops and iteration to solve
        programming problems.
        """,
        evidence: [
            loopsEvidence,
            loopsAssessmentEvidence
        ]
    )
    
    static let loopsAssessmentEvidence = Evidence(
        title: "Loops & Iteration Assessment",
        description: """
        Assessment demonstrating the ability to use for-in and
        while loops, control iteration and solve programming
        problems using repetition.
        """,
        type: .assessment,
        status: .verified,
        reviewer: "Lennon",
        reviewerRole: "MCRI Facilitator"
    )
    
    // MARK: - GitHub Skills
    
    static let butjiloGitHubSkill = Skill(
        name: "Git & GitHub",
        category: .technical,
        status: .demonstrated,
        description: """
        Ability to use Git and GitHub for source control,
        repository management and project development.
        """,
        evidence: [
            butjiloGitHubEvidence
        ]
    )
    
    static let studentTwoGitHubSkill = Skill(
        name: "Git & GitHub",
        category: .technical,
        status: .demonstrated,
        description: """
        Ability to use Git and GitHub for source control,
        repository management and project development.
        """,
        evidence: [
            studentTwoGitHubEvidence
        ]
    )
    
    static let studentThreeGitHubSkill = Skill(
        name: "Git & GitHub",
        category: .technical,
        status: .demonstrated,
        description: """
        Ability to use Git and GitHub for source control,
        repository management and project development.
        """,
        evidence: [
            studentThreeGitHubEvidence
        ]
    )
    
    
    // MARK: - Essential Skills
    
    static let communicationSkill = Skill(
        name: "Communication",
        category: .essential,
        status: .demonstrated,
        description: """
        Ability to communicate ideas clearly and
        effectively.
        """,
        evidence: [
            communicationEvidence
        ]
    )
    
    static let teamworkSkill = Skill(
        name: "Teamwork",
        category: .essential,
        status: .inProgress,
        description: """
        Ability to collaborate effectively with
        other team members.
        """
    )
    
    static let problemSolvingSkill = Skill(
        name: "Problem Solving",
        category: .essential,
        status: .demonstrated,
        description: """
        Ability to analyse problems and develop
        effective solutions.
        """,
        evidence: [
            marketMateEvidence
        ]
    )
    
    
    // MARK: - Projects
    static let marketMate = Project(
        name: "MarketMate",
        description: """
        An inventory management application designed to help
        vendors manage products, stock and sales.
        """,
        technologies: [
            "Swift",
            "SwiftUI",
            "SwiftData"
        ],
        skillsDemonstrated: [
            "Swift",
            "Problem Solving",
            "Application Development"
        ],
        evidence: [
            marketMateEvidence
        ],
        repositoryURL: "https://github.com/Butjilo01/MARKETMATE-PERSONAL-PROJECT"
    )
    
    static let airportPickup = Project(
        name: "AirportPickup",
        description: """
        A location-based application designed around
        airport pickup services.
        """,
        technologies: [
            "Swift",
            "SwiftUI",
            "MapKit",
            "SwiftData"
        ],
        skillsDemonstrated: [
            "Swift",
            "MapKit",
            "Problem Solving"
        ],
        evidence: []
    )
    
    
    // MARK: - Achievements
    
    static let jamfCertification = Achievement(
        title: "Jamf Certified Associate",
        description: "Professional certification achievement.",
        type: .certification
    )
    
    static let mcriRecognition = Achievement(
        title: "MCRI Project Recognition",
        description: """
        Recognition for participation in project-based
        learning at MCRI.
        """,
        type: .recognition
    )
    
    
    // MARK: - Candidates
    
    static let candidateOne = StudentProfile(
        profileID: "MCRI-2026-0472",
        name: "Butjilo",
        cohort: "MCRI 2026",
        bio: """
        Technical learner focused on application development,
        problem solving and building practical digital solutions.
        """,
        skills: [
            swiftSkill,
            loopsSkill,
            butjiloGitHubSkill,
            communicationSkill,
            teamworkSkill,
            problemSolvingSkill
        ],
        projects: [
            marketMate,
            airportPickup
        ],
        achievements: [
            jamfCertification,
            mcriRecognition
        ]
    )
    
    static let candidateTwo = StudentProfile(
        profileID: "MCRI-2026-0318",
        name: "Tawanda",
        cohort: "MCRI 2026",
        bio: """
        Learner developing programming, collaboration
        and project management skills.
        """,
        skills: [
            loopsSkill,
            studentTwoGitHubSkill,
            communicationSkill,
            teamworkSkill
        ],
        projects: [],
        achievements: [
            mcriRecognition
        ]
    )
    
    static let candidateThree = StudentProfile(
        profileID: "MCRI-2025-0184",
        name: "Nyasha",
        cohort: "MCRI 2025",
        bio: """
        Developer focused on technical problem solving
        and building practical applications.
        """,
        skills: [
            studentThreeGitHubSkill,
            communicationSkill,
            problemSolvingSkill
        ],
        projects: [],
        achievements: [
            jamfCertification
        ]
    )
    
    static let candidates: [StudentProfile] = [
        candidateOne,
        candidateTwo,
        candidateThree
    ]
    
    
    // MARK: - Skills Framework
    
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
        
        FrameworkGroup(
            category: "Technical Skills",
            entries: [
                
                FrameworkEntry(
                    name: "Swift",
                    description: "Develop applications using Swift."
                ),
                
                FrameworkEntry(
                    name: "Programming Fundamentals",
                    description: """
                    Understand variables, conditions,
                    loops and functions.
                    """
                ),
                
                FrameworkEntry(
                    name: "Git & GitHub",
                    description: """
                    Manage code and collaborate using
                    version control.
                    """
                ),
                
                FrameworkEntry(
                    name: "APIs",
                    description: """
                    Understand how applications communicate
                    with services.
                    """
                ),
                
                FrameworkEntry(
                    name: "Databases",
                    description: """
                    Store, retrieve and manage application data.
                    """
                )
            ]
        ),
        
        FrameworkGroup(
            category: "Essential Skills",
            entries: [
                
                FrameworkEntry(
                    name: "Communication",
                    description: """
                    Communicate ideas clearly and effectively.
                    """
                ),
                
                FrameworkEntry(
                    name: "Teamwork",
                    description: """
                    Collaborate effectively with others.
                    """
                ),
                
                FrameworkEntry(
                    name: "Problem Solving",
                    description: """
                    Analyse problems and develop effective solutions.
                    """
                ),
                
                FrameworkEntry(
                    name: "Leadership",
                    description: """
                    Take responsibility and guide others
                    toward a goal.
                    """
                ),
                
                FrameworkEntry(
                    name: "Time Management",
                    description: """
                    Plan and manage work effectively.
                    """
                )
            ]
        )
    ]
}
