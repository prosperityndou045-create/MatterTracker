import SwiftUI

struct SkillFrameworkDetailView: View {
    
    let entry: MockData.FrameworkEntry
    
    var body: some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                // MARK: - Skill Header
                
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    Image(systemName: skillIcon)
                        .font(.largeTitle)
                    
                    Text(entry.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(entry.description)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // MARK: - What Demonstrates This Skill
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Text("What Demonstrates This Skill")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(skillExplanation)
                        .foregroundStyle(.secondary)
                }
                
                // MARK: - Evidence
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    Text("Examples of Evidence")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(evidenceExamples, id: \.title) { evidence in
                        EvidenceExample(
                            icon: evidence.icon,
                            title: evidence.title,
                            description: evidence.description
                        )
                    }
                }
                
                // MARK: - Verification
                
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Label(
                        "Evidence is verified",
                        systemImage: "checkmark.seal.fill"
                    )
                    .fontWeight(.semibold)
                    
                    Text("""
                    Evidence submitted by a student can be reviewed and verified by an MCRI facilitator before it contributes to the student's demonstrated skills.
                    """)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Color.secondary.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
            }
            .padding()
        }
        .navigationTitle("Skill")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Skill Icon
    
    private var skillIcon: String {
        switch entry.name {
        case "Swift":
            return "swift"
            
        case "Programming Fundamentals":
            return "chevron.left.forwardslash.chevron.right"
            
        case "Git & GitHub":
            return "arrow.triangle.branch"
            
        case "APIs":
            return "network"
            
        case "Databases":
            return "cylinder"
            
        case "Communication":
            return "bubble.left.and.bubble.right"
            
        case "Teamwork":
            return "person.3"
            
        case "Problem Solving":
            return "lightbulb"
            
        case "Leadership":
            return "person.badge.key"
            
        case "Time Management":
            return "clock"
            
        default:
            return "star"
        }
    }
    
    // MARK: - Skill Explanation
    
    private var skillExplanation: String {
        switch entry.name {
        case "Swift":
            return """
            Demonstrates the ability to write, understand and maintain applications using Swift, including variables, functions, control flow, collections, structures and classes.
            """
            
        case "Programming Fundamentals":
            return """
            Demonstrates an understanding of core programming concepts such as variables, conditions, loops, functions, arrays and dictionaries.
            """
            
        case "Git & GitHub":
            return """
            Demonstrates the ability to use Git and GitHub to manage source code, maintain repositories and collaborate on software projects.
            """
            
        case "APIs":
            return """
            Demonstrates an understanding of how applications communicate with external services and exchange data through APIs.
            """
            
        case "Databases":
            return """
            Demonstrates the ability to store, retrieve and manage application data using database technologies.
            """
            
        case "Communication":
            return """
            Demonstrates the ability to clearly explain ideas, technical decisions and project outcomes to different audiences.
            """
            
        case "Teamwork":
            return """
            Demonstrates the ability to collaborate with others, contribute to shared goals and work effectively within a team.
            """
            
        case "Problem Solving":
            return """
            Demonstrates the ability to analyse problems, identify possible solutions and implement effective approaches.
            """
            
        case "Leadership":
            return """
            Demonstrates the ability to take responsibility, guide others and contribute toward achieving a shared goal.
            """
            
        case "Time Management":
            return """
            Demonstrates the ability to plan tasks, prioritise work and complete responsibilities within expected timelines.
            """
            
        default:
            return entry.description
        }
    }
    
    // MARK: - Evidence Examples
    
    private var evidenceExamples: [(icon: String, title: String, description: String)] {
        
        switch entry.name {
            
        case "Swift":
            return [
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Swift code demonstrating programming concepts."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A completed application built using Swift."
                ),
                (
                    "arrow.triangle.branch",
                    "GitHub Repository",
                    "A repository containing the student's Swift development work."
                ),
                (
                    "doc.text",
                    "Assessment",
                    "An assessment demonstrating knowledge of Swift."
                )
            ]
            
        case "Git & GitHub":
            return [
                (
                    "arrow.triangle.branch",
                    "GitHub Repository",
                    "A public repository containing the student's development work."
                ),
                (
                    "clock.arrow.circlepath",
                    "Commit History",
                    "Evidence showing how the student manages changes to their code."
                ),
                (
                    "arrow.triangle.pull",
                    "Pull Request",
                    "Evidence of collaboration and contribution to a project."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A project managed using Git and GitHub."
                )
            ]
            
        case "Communication":
            return [
                (
                    "play.rectangle.fill",
                    "Video Demonstration",
                    "A presentation explaining a project or technical concept."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback evaluating the student's communication."
                ),
                (
                    "folder.fill",
                    "Project Presentation",
                    "Evidence of clearly explaining a completed project."
                )
            ]
            
        case "Teamwork":
            return [
                (
                    "person.3.fill",
                    "Group Project",
                    "Evidence showing contribution to a collaborative project."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback on collaboration and teamwork."
                ),
                (
                    "person.2.fill",
                    "Peer Feedback",
                    "Feedback from other members of the project team."
                )
            ]
            
        case "Problem Solving":
            return [
                (
                    "flag.fill",
                    "LTC Challenge",
                    "A programming challenge demonstrating analytical thinking."
                ),
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Code demonstrating how a problem was analysed and solved."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A practical project demonstrating solution development."
                )
            ]
            
        default:
            return [
                (
                    "chevron.left.forwardslash.chevron.right",
                    "Code Sample",
                    "Code demonstrating the skill."
                ),
                (
                    "flag.fill",
                    "LTC Challenge",
                    "A challenge demonstrating the skill."
                ),
                (
                    "folder.fill",
                    "Project",
                    "A project demonstrating the skill."
                ),
                (
                    "play.rectangle.fill",
                    "Video Demonstration",
                    "A video demonstrating the skill."
                ),
                (
                    "text.bubble.fill",
                    "Facilitator Feedback",
                    "Feedback from an MCRI facilitator."
                ),
                (
                    "doc.text",
                    "Assessment",
                    "An assessment demonstrating the skill."
                )
            ]
        }
    }
}

struct EvidenceExample: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 30)
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            Color.secondary.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}
