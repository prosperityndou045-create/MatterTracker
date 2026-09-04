//
//  AssignedStudents.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//
import SwiftUI

//models
struct Student: Identifiable {
    
    let id = UUID()
    
    let name: String
    let email: String
    let progress: Int
    let skillsCompleted: Int
    let totalSkills: Int
}



struct Skill: Identifiable {
    
    let id = UUID()
    
    let name: String
    let description: String
    let status: String
}

struct Evidence: Identifiable {
    
    let id = UUID()
    
    let title: String
    let type: String
    let description: String
    let date: String
}

struct AssignedStudentsView: View {
    
    // Later, these can come from your database/API.
    let students = [
        
        Student(
            name: "John Banda",
            email: "john@gmail.com",
            progress: 75,
            skillsCompleted: 6,
            totalSkills: 8
        ),
        
        Student(
            name: "Mary Phiri",
            email: "mary@gmail.com",
            progress: 50,
            skillsCompleted: 4,
            totalSkills: 8
        ),
        
        Student(
            name: "Peter Zulu",
            email: "peter@gmail.com",
            progress: 90,
            skillsCompleted: 7,
            totalSkills: 8
        )
    ]
    
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                Section("Assigned Students") {
                    
                    ForEach(students) { student in
                        
                        NavigationLink {
                            
                            StudentProfileView(student: student)
                            
                        } label: {
                            
                            HStack(spacing: 15) {
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 45))
                                
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    
                                    Text(student.name)
                                        .font(.headline)
                                    
                                
                                    Text(student.email)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                
                                    ProgressView(
                                        value: Double(student.progress),
                                        total: 100
                                    )
                                    
                                   
                                    Text("\(student.progress)% complete")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Assigned Students")
        }
    }
}
