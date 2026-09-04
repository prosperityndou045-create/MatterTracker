//
//  ProjectDetailView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    
                    Image(
                        systemName: "folder.fill"
                    )
                    .font(.largeTitle)
                    
                    Text(project.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(project.description)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // MARK: Technologies
                
                Text("Technologies")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(
                    project.technologies,
                    id: \.self
                ) { technology in
                    
                    Label(
                        technology,
                        systemImage: "chevron.left.forwardslash.chevron.right"
                    )
                }
                
                Text("Skills Demonstrated")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(
                    project.skillsDemonstrated,
                    id: \.self
                ) { skill in
                    
                    Label(
                        skill,
                        systemImage: "checkmark.circle"
                    )
                }
                        
                if !project.evidence.isEmpty {
                    
                    Text("Project Evidence")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(project.evidence) { evidence in
                        
                        NavigationLink {
                            
                            EvidenceDetailView(
                                evidence: evidence
                            )
                            
                        } label: {
                            
                            EvidenceRow(
                                evidence: evidence
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                
                if let repositoryURL = project.repositoryURL,
                   let url = URL(string: repositoryURL) {
                    
                    Link(
                        destination: url
                    ) {
                        
                        HStack {
                            
                            Image(
                                systemName: "chevron.left.forwardslash.chevron.right"
                            )
                            
                            Text("View Repository")
                            
                            Spacer()
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
                }
            }
            .padding()
        }
        .navigationTitle("Project")
        .navigationBarTitleDisplayMode(.inline)
    }
}
