//
//  WalkThrough.swift.
//  Matter Tracker.
//  Created by Prosperity on 4/9/2026.


import SwiftUI

struct WalkthroughView: View {
    let student: Student

    var body: some View {
        List {
            Section {
                Text(student.name)
                    .font(.headline)

                Text("Review the student's projects, skills and evidence.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Student Evidence") {
                NavigationLink {
                    StudentProjectsView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "Projects",
                        description: "View projects created by the student.",
                        icon: "folder.fill"
                    )
                }

                NavigationLink {
                    EssentialSkillsView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "Essential Skills",
                        description: "Review Communication, Teamwork, Problem Solving and Leadership.",
                        icon: "star.fill"
                    )
                }

                NavigationLink {
                    CodeSamplesView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "Code Samples",
                        description: "View code samples uploaded by the student.",
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                NavigationLink {
                    LTCChallengesView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "LTC Challenges",
                        description: "View completed LTC challenges.",
                        icon: "flag.fill"
                    )
                }

                NavigationLink {
                    GitHubRepositoriesView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "GitHub Repositories",
                        description: "View the student's GitHub repositories.",
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                NavigationLink {
                    StudentVideosView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "Videos",
                        description: "View videos uploaded by the student.",
                        icon: "video.fill"
                    )
                }

                NavigationLink {
                    FacilitatorFeedbackView(student: student)
                } label: {
                    WalkthroughRow(
                        title: "Facilitator Feedback",
                        description: "View feedback previously given to the student.",
                        icon: "text.bubble.fill"
                    )
                }
            }
        }
        .navigationTitle("Walkthrough")
    }
}

struct WalkthroughRow: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

struct StudentProjectsView: View {
    let student: Student

    let projects = [
        "Food Review App",
        "Banking App",
        "Clothing Store App"
    ]

    var body: some View {
        List {
            Section("Student Projects") {
                ForEach(projects, id: \.self) { project in
                    NavigationLink {
                        ProjectDetailView(
                            projectName: project
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(project)
                                .fontWeight(.semibold)

                            Text("View project details and submitted work.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Projects")
    }
}

struct ProjectDetailView: View {
    let projectName: String

    var body: some View {
        List {
            Section("Project") {
                Text(projectName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Project submitted by the student.")
                    .foregroundStyle(.secondary)
            }

            Section("Project Information") {
                Text("Description")

                Text("This section will contain the student's project description.")
                    .foregroundStyle(.secondary)
            }

            Section("Project Repository") {
                Link(destination: githubURL) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Open GitHub Repository")
                                .fontWeight(.semibold)

                            Text("View the project's source code on GitHub.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(projectName)
    }

    private var githubURL: URL {
        switch projectName {
        case "Food Review App":
            return URL(string: "https://github.com/student/food-review-app")!

        case "Banking App":
            return URL(string: "https://github.com/student/banking-app")!

        case "Clothing Store App":
            return URL(string: "https://github.com/student/clothing-store-app")!

        default:
            return URL(string: "https://github.com")!
        }
    }
}

struct EssentialSkillsView: View {
    let student: Student

    let skills = [
        "Communication",
        "Teamwork",
        "Problem Solving",
        "Leadership"
    ]

    var body: some View {
        List {
            Section("Essential Skills") {
                ForEach(skills, id: \.self) { skill in
                    NavigationLink {
                        SkillDetailView(
                            student: student,
                            skillName: skill
                        )
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)

                            Text(skill)
                                .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Essential Skills")
    }
}

struct SkillDetailView: View {
    let student: Student
    let skillName: String

    var body: some View {
        List {
            Section("Skill") {
                Text(skillName)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Section("Evidence Demonstrating This Skill") {
                NavigationLink("Projects") {
                    StudentProjectsView(student: student)
                }

                NavigationLink("Code Samples") {
                    CodeSamplesView(student: student)
                }

                NavigationLink("LTC Challenges") {
                    LTCChallengesView(student: student)
                }

                NavigationLink("Videos") {
                    StudentVideosView(student: student)
                }

                NavigationLink("Facilitator Feedback") {
                    FacilitatorFeedbackView(student: student)
                }

                NavigationLink("Assessments") {
                    StudentAssessmentsView(student: student)
                }
            }
        }
        .navigationTitle(skillName)
    }
}

struct CodeSamplesView: View {
    let student: Student

    let samples = [
        "Swift Calculator",
        "Login Form",
        "Todo List",
        "Food Review Function"
    ]

    var body: some View {
        List {
            Section("Uploaded Code Samples") {
                ForEach(samples, id: \.self) { sample in
                    NavigationLink {
                        CodeSampleDetailView(
                            sampleName: sample
                        )
                    } label: {
                        HStack {
                            Image(
                                systemName: "chevron.left.forwardslash.chevron.right"
                            )
                            .foregroundStyle(.blue)

                            VStack(alignment: .leading) {
                                Text(sample)
                                    .fontWeight(.semibold)

                                Text("Uploaded by \(student.name)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Code Samples")
    }
}

struct CodeSampleDetailView: View {
    let sampleName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(sampleName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Student Code")
                    .font(.headline)

                Text("""
                struct ContentView: View {
                    var body: some View {
                        Text("Hello World")
                    }
                }
                """)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Code Sample")
    }
}

struct LTCChallengesView: View {
    let student: Student

    var body: some View {
        List {
            Text("LTC challenges completed by \(student.name)")
        }
        .navigationTitle("LTC Challenges")
    }
}

struct GitHubRepositoriesView: View {
    let student: Student

    var body: some View {
        List {
            Text("GitHub repositories belonging to \(student.name)")
        }
        .navigationTitle("GitHub Repositories")
    }
}

struct StudentVideosView: View {
    let student: Student

    var body: some View {
        List {
            Text("Videos uploaded by \(student.name)")
        }
        .navigationTitle("Videos")
    }
}

struct FacilitatorFeedbackView: View {
    let student: Student

    var body: some View {
        List {
            Text("Facilitator feedback for \(student.name)")
        }
        .navigationTitle("Facilitator Feedback")
    }
}

struct StudentAssessmentsView: View {
    let student: Student

    var body: some View {
        List {
            Text("Assessments for \(student.name)")
        }
        .navigationTitle("Assessments")
    }
}

