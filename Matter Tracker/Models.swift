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
        title: "MarketMate Inventory App",
        description: """
        A SwiftUI inventory management application developed
        during the MCRI program.
        """,
        type: .project,
        status: .verified,
        reviewer: "J. Moyo",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/example/marketmate"
    )
    
    static let loopsEvidence = Evidence(
        title: "LTC Loops Challenge",
        description: """
        Programming challenge demonstrating the use of
        loops and iteration.
        """,
        type: .challenge,
        status: .verified,
        reviewer: "J. Moyo",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/example/loops"
    )
    
    static let communicationEvidence = Evidence(
        title: "Project Presentation",
        description: """
        Presentation demonstrating technical communication
        and explanation of project decisions.
        """,
        type: .video,
        status: .verified,
        reviewer: "J. Moyo",
        reviewerRole: "MCRI Facilitator"
    )
    
    static let githubEvidence = Evidence(
        title: "GitHub Portfolio Repository",
        description: """
        Repository containing programming exercises,
        projects and development work.
        """,
        type: .github,
        status: .verified,
        reviewer: "J. Moyo",
        reviewerRole: "MCRI Facilitator",
        attachmentURL: "https://github.com/example/portfolio"
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
            marketMateEvidence
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
            loopsEvidence
        ]
    )
    
    static let githubSkill = Skill(
        name: "Git & GitHub",
        category: .technical,
        status: .inProgress,
        description: """
        Ability to use Git and GitHub for source control
        and collaboration.
        """,
        evidence: [
            githubEvidence
        ]
    )
    
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
        An inventory management application designed
        to help vendors manage products, stock and sales.
        """,
        technologies: [
            "Swift",
            "SwiftUI",
            "SwiftData"
        ],
        skillsDemonstrated: [
            "Swift",
            "SwiftUI",
            "Databases",
            "Problem Solving"
        ],
        evidence: [
            marketMateEvidence
        ],
        repositoryURL: "https://github.com/example/marketmate"
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
        evidence: [
            marketMateEvidence
        ]
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
            githubSkill,
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
            communicationSkill,
            teamworkSkill
        ],
        projects: [
            marketMate
        ],
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
            swiftSkill,
            communicationSkill,
            problemSolvingSkill
        ],
        projects: [
            airportPickup
        ],
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
