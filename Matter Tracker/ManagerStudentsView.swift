import SwiftUI

struct ManagerStudentsView: View {
    
    let selectedCohort: String
    
    struct Student {
        let name: String
        let cohort: String
        let progress: Int
        let skills: String
        let evidence: String
        let evidenceStatus: String
    }
    
    let students = [
        
        // MARK: - Cohort 1
        
        Student(
            name: "Tendai Moyo",
            cohort: "Cohort 1",
            progress: 85,
            skills: "Communication, Teamwork",
            evidence: "Presentation Video",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Rudo Chikore",
            cohort: "Cohort 1",
            progress: 76,
            skills: "Functions, Problem Solving",
            evidence: "GitHub Project",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Brian Dube",
            cohort: "Cohort 1",
            progress: 88,
            skills: "Teamwork, Communication",
            evidence: "Team Project",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Nyasha Ncube",
            cohort: "Cohort 1",
            progress: 70,
            skills: "Loops, Functions",
            evidence: "Code Sample",
            evidenceStatus: "Pending"
        ),
        
        // MARK: - Cohort 2
        
        Student(
            name: "Tatenda Zhou",
            cohort: "Cohort 2",
            progress: 91,
            skills: "Problem Solving, Teamwork",
            evidence: "LTC Challenge",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Shamiso Mlambo",
            cohort: "Cohort 2",
            progress: 79,
            skills: "Communication",
            evidence: "Presentation",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Blessing Chirwa",
            cohort: "Cohort 2",
            progress: 87,
            skills: "Teamwork, Communication",
            evidence: "Group Project",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Farai Mutsvairo",
            cohort: "Cohort 2",
            progress: 74,
            skills: "Functions, Loops",
            evidence: "Code Sample",
            evidenceStatus: "Pending"
        ),
        
        // MARK: - Cohort 3
        
        Student(
            name: "Michelle Banda",
            cohort: "Cohort 3",
            progress: 82,
            skills: "Communication, Teamwork",
            evidence: "Presentation",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Daniel Mutasa",
            cohort: "Cohort 3",
            progress: 69,
            skills: "Functions",
            evidence: "GitHub Project",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Ashley Sibanda",
            cohort: "Cohort 3",
            progress: 90,
            skills: "Problem Solving, Teamwork",
            evidence: "LTC Challenge",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Kudzai Ndlovu",
            cohort: "Cohort 3",
            progress: 73,
            skills: "Loops, Communication",
            evidence: "Code Sample",
            evidenceStatus: "Pending"
        ),
        
        // MARK: - Cohort 4
        
        Student(
            name: "Chipo Moyo",
            cohort: "Cohort 4",
            progress: 84,
            skills: "Communication, Teamwork",
            evidence: "Team Presentation",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Ethan Dube",
            cohort: "Cohort 4",
            progress: 78,
            skills: "Functions, Loops",
            evidence: "Code Sample",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Anesu Chirwa",
            cohort: "Cohort 4",
            progress: 71,
            skills: "Problem Solving",
            evidence: "LTC Challenge",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Precious Ncube",
            cohort: "Cohort 4",
            progress: 89,
            skills: "Teamwork, Communication",
            evidence: "Team Project",
            evidenceStatus: "Verified"
        ),
        
        // MARK: - Cohort 5
        
        Student(
            name: "Tapiwa Zhou",
            cohort: "Cohort 5",
            progress: 92,
            skills: "Communication, Teamwork",
            evidence: "Presentation",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Natasha Mlambo",
            cohort: "Cohort 5",
            progress: 81,
            skills: "Problem Solving",
            evidence: "Project",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Caleb Mutasa",
            cohort: "Cohort 5",
            progress: 75,
            skills: "Functions, Loops",
            evidence: "Code Sample",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Rumbidzai Banda",
            cohort: "Cohort 5",
            progress: 86,
            skills: "Teamwork",
            evidence: "Team Project",
            evidenceStatus: "Verified"
        ),
        
        // MARK: - Cohort 6
        
        Student(
            name: "Munyaradzi Dube",
            cohort: "Cohort 6",
            progress: 88,
            skills: "Communication, Teamwork",
            evidence: "Presentation",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Linda Ncube",
            cohort: "Cohort 6",
            progress: 77,
            skills: "Functions, Problem Solving",
            evidence: "GitHub Project",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Takudzwa Moyo",
            cohort: "Cohort 6",
            progress: 83,
            skills: "Loops, Teamwork",
            evidence: "Code Sample",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Melissa Chikore",
            cohort: "Cohort 6",
            progress: 79,
            skills: "Communication",
            evidence: "Presentation",
            evidenceStatus: "Verified"
        ),
        
        // MARK: - Cohort 7
        
        Student(
            name: "Simba Zhou",
            cohort: "Cohort 7",
            progress: 94,
            skills: "Teamwork, Communication",
            evidence: "Team Project",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Rutendo Mutsvairo",
            cohort: "Cohort 7",
            progress: 82,
            skills: "Problem Solving",
            evidence: "LTC Challenge",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Jason Banda",
            cohort: "Cohort 7",
            progress: 73,
            skills: "Functions",
            evidence: "GitHub Project",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Nyasha Chirwa",
            cohort: "Cohort 7",
            progress: 87,
            skills: "Communication, Teamwork",
            evidence: "Presentation",
            evidenceStatus: "Verified"
        ),
        
        // MARK: - Cohort 8
        
        Student(
            name: "Tinashe Ncube",
            cohort: "Cohort 8",
            progress: 89,
            skills: "Teamwork, Problem Solving",
            evidence: "Team Project",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Sharon Moyo",
            cohort: "Cohort 8",
            progress: 76,
            skills: "Communication",
            evidence: "Presentation",
            evidenceStatus: "Pending"
        ),
        
        Student(
            name: "Gary Mutasa",
            cohort: "Cohort 8",
            progress: 84,
            skills: "Functions, Loops",
            evidence: "Code Sample",
            evidenceStatus: "Verified"
        ),
        
        Student(
            name: "Brenda Dube",
            cohort: "Cohort 8",
            progress: 91,
            skills: "Teamwork, Communication",
            evidence: "Group Project",
            evidenceStatus: "Verified"
        )
    ]
    
    var filteredStudents: [Student] {
        if selectedCohort == "All Cohorts" {
            return students
        } else {
            return students.filter {
                $0.cohort == selectedCohort
            }
        }
    }
    
    var body: some View {
        List {
            Section(selectedCohort == "All Cohorts" ? "All Students" : selectedCohort) {
                
                ForEach(filteredStudents, id: \.name) { student in
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // MARK: - Student Name
                        HStack(spacing: 14) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(student.name)
                                    .font(.headline)
                                
                                Text("Student Progress")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(student.progress)%")
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                        
                        // MARK: - Progress
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text("\(student.progress)%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            
                            ProgressView(
                                value: Double(student.progress),
                                total: 100
                            )
                        }
                        
                        // MARK: - Skills
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Skills")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(student.skills)
                                    .font(.subheadline)
                            }
                        }
                        
                        // MARK: - Evidence
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "doc.text.fill")
                                .foregroundStyle(.secondary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Evidence")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(student.evidence)
                                    .font(.subheadline)
                            }
                        }
                        
                        // MARK: - Evidence Status
                        HStack {
                            Image(
                                systemName: student.evidenceStatus == "Verified"
                                ? "checkmark.circle.fill"
                                : "clock.fill"
                            )
                            
                            Text(student.evidenceStatus)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(
                            student.evidenceStatus == "Verified"
                            ? .green
                            : .orange
                        )
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Students")
    }
}
#Preview {
    NavigationStack {
        ManagerStudentsView(selectedCohort: "Cohort 1")
    }
}
