//
//  StudentProfileView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//
import SwiftUI

struct StudentProfileView: View {
    
    // The student selected from Assigned Students.
    let student: Student
    
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 25) {
                
                
                VStack(spacing: 10) {
                    
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 90))
                    
                    Text(student.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(student.email)
                        .foregroundStyle(.secondary)
                }
            
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Overall Progress")
                        .font(.headline)
                    
                    ProgressView(
                        value: Double(student.progress),
                        total: 100
                    )
                    
                    Text("\(student.progress)% completed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            
                HStack {
                    
                    // Completed skills
                    VStack {
                        
                        Text("\(student.skillsCompleted)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Completed")
                            .font(.caption)
                    }
                    
                    
                    Spacer()
                
                    VStack {
                        
                        Text("\(student.totalSkills - student.skillsCompleted)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Remaining")
                            .font(.caption)
                    }
                    
                    
                    Spacer()
                
                    VStack {
                        
                        Text("\(student.totalSkills)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Total Skills")
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                NavigationLink {
                    
                   
                    WalkthroughView(student: student)
                    
                } label: {
                    
                    Text("Start Walkthrough")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Student Profile")
    }
}
