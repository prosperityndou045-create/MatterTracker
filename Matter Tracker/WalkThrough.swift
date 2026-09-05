//
//  WalkThrough.swift.
//  Matter Tracker.
//  Created by Prosperity on 4/9/2026.


import SwiftUI

// MARK: - Walkthrough View

struct WalkthroughView: View {

    let student: Student

    var body: some View {

        List {

            // MARK: - Student Information

            Section {

                Text(student.name)
                    .font(.headline)

                Text("Review the student's projects, skills and evidence.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // MARK: - Student Evidence

            Section("Student Evidence") {

                // MARK: Projects

                NavigationLink {

                    StudentProjectsView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "Projects",
                        description: "View projects created by the student.",
                        icon: "folder.fill"
                    )
                }

                // MARK: Essential Skills

                NavigationLink {

                    EssentialSkillsView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "Essential Skills",
                        description: "Rate Communication, Teamwork, Problem Solving and Leadership.",
                        icon: "star.fill"
                    )
                }

                // MARK: Code Samples

                NavigationLink {

                    CodeSamplesView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "Code Samples",
                        description: "View code samples uploaded by the student.",
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                // MARK: LTC Challenges

                NavigationLink {

                    LTCChallengesView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "LTC Challenges",
                        description: "View completed LTC challenges.",
                        icon: "flag.fill"
                    )
                }

                // MARK: GitHub Repositories

                NavigationLink {

                    GitHubRepositoriesView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "GitHub Repositories",
                        description: "View the student's GitHub repositories.",
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                // MARK: Videos

                NavigationLink {

                    StudentVideosView(
                        student: student
                    )

                } label: {

                    WalkthroughRow(
                        title: "Videos",
                        description: "View videos uploaded by the student.",
                        icon: "video.fill"
                    )
                }

                // MARK: Facilitator Feedback

                NavigationLink {

                    FacilitatorFeedbackView(
                        student: student
                    )

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


// MARK: - Walkthrough Row

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

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

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


// MARK: - Student Projects

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

                ForEach(
                    projects,
                    id: \.self
                ) { project in

                    NavigationLink {

                        ProjectDetailView(
                            projectName: project
                        )

                    } label: {

                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {

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


// MARK: - Project Detail

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

                Link(
                    destination: githubURL
                ) {

                    HStack {

                        Image(
                            systemName: "chevron.left.forwardslash.chevron.right"
                        )
                        .foregroundStyle(.blue)

                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {

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

            return URL(
                string: "https://github.com/student/food-review-app"
            )!

        case "Banking App":

            return URL(
                string: "https://github.com/student/banking-app"
            )!

        case "Clothing Store App":

            return URL(
                string: "https://github.com/student/clothing-store-app"
            )!

        default:

            return URL(
                string: "https://github.com"
            )!
        }
    }
}


// MARK: - Essential Skills

struct EssentialSkillsView: View {

    let student: Student

    let skills = [
        "Communication",
        "Teamwork",
        "Problem Solving",
        "Leadership"
    ]

    // Each skill has its own rating
    @State private var ratings: [String: Int] = [
        "Communication": 0,
        "Teamwork": 0,
        "Problem Solving": 0,
        "Leadership": 0
    ]

    var body: some View {

        List {

            // MARK: - Student Information

            Section {

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text(student.name)
                        .font(.headline)

                    Text(
                        "Rate the student's essential skills from 1 to 5 stars."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }

            // MARK: - Skills

            Section("Essential Skills") {

                ForEach(
                    skills,
                    id: \.self
                ) { skill in

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        // Skill name and rating number

                        HStack {

                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)

                            Text(skill)
                                .fontWeight(.semibold)

                            Spacer()

                            Text(
                                "\(ratings[skill] ?? 0)/5"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        // MARK: - Five Star Rating

                        HStack(spacing: 12) {

                            ForEach(
                                1...5,
                                id: \.self
                            ) { star in

                                Button {

                                    ratings[skill] = star

                                } label: {

                                    Image(
                                        systemName:
                                            star <= (ratings[skill] ?? 0)
                                            ? "star.fill"
                                            : "star"
                                    )
                                    .font(.title2)
                                    .foregroundStyle(
                                        star <= (ratings[skill] ?? 0)
                                        ? .yellow
                                        : .gray
                                    )
                                }
                                .buttonStyle(.plain)
                            }

                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                }
            }

            // MARK: - Rating Summary

            Section("Rating Summary") {

                ForEach(
                    skills,
                    id: \.self
                ) { skill in

                    HStack {

                        Text(skill)
                            .font(.subheadline)

                        Spacer()

                        HStack(spacing: 2) {

                            ForEach(
                                1...5,
                                id: \.self
                            ) { star in

                                Image(
                                    systemName:
                                        star <= (ratings[skill] ?? 0)
                                        ? "star.fill"
                                        : "star"
                                )
                                .font(.caption)
                                .foregroundStyle(
                                    star <= (ratings[skill] ?? 0)
                                    ? .yellow
                                    : .gray
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Essential Skills")
    }
}


// MARK: - Code Samples

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

                ForEach(
                    samples,
                    id: \.self
                ) { sample in

                    NavigationLink {

                        CodeSampleDetailView(
                            sampleName: sample
                        )

                    } label: {

                        HStack {

                            Image(
                                systemName:
                                    "chevron.left.forwardslash.chevron.right"
                            )
                            .foregroundStyle(.blue)

                            VStack(
                                alignment: .leading
                            ) {

                                Text(sample)
                                    .fontWeight(.semibold)

                                Text(
                                    "Uploaded by \(student.name)"
                                )
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


// MARK: - Code Sample Detail

struct CodeSampleDetailView: View {

    let sampleName: String

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                Text(sampleName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Student Code")
                    .font(.headline)

                Text(
                    """
                    struct ContentView: View {
                    
                        var body: some View {
                            Text("Hello World")
                        }
                    }
                    """
                )
                .font(
                    .system(
                        .body,
                        design: .monospaced
                    )
                )
                .padding()
                .background(
                    Color(.systemGray6)
                )
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Code Sample")
    }
}


// MARK: - LTC Challenges

struct LTCChallengesView: View {

    let student: Student

    var body: some View {

        List {

            Text(
                "LTC challenges completed by \(student.name)"
            )
        }
        .navigationTitle("LTC Challenges")
    }
}


// MARK: - GitHub Repositories

struct GitHubRepositoriesView: View {

    let student: Student

    var body: some View {

        List {

            Text(
                "GitHub repositories belonging to \(student.name)"
            )
        }
        .navigationTitle("GitHub Repositories")
    }
}


// MARK: - Student Videos

struct StudentVideosView: View {

    let student: Student

    var body: some View {

        List {

            Text(
                "Videos uploaded by \(student.name)"
            )
        }
        .navigationTitle("Videos")
    }
}


// MARK: - Facilitator Feedback

struct FacilitatorFeedbackView: View {

    let student: Student

    var body: some View {

        List {

            Text(
                "Facilitator feedback for \(student.name)"
            )
        }
        .navigationTitle("Facilitator Feedback")
    }
}


// MARK: - Student Assessments

struct StudentAssessmentsView: View {

    let student: Student

    var body: some View {

        List {

            Text(
                "Assessments for \(student.name)"
            )
        }
        .navigationTitle("Assessments")
    }
}
