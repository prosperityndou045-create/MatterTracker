import SwiftUI

struct ProjectDetailView: View {
    
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                // MARK: - Project Header
                
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
                
                // MARK: - Technologies
                
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
                
                // MARK: - Skills Demonstrated
                
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
                
                // MARK: - Project Evidence
                
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
                
                // MARK: - Repository
                
                if let repositoryURL = project.repositoryURL,
                   let url = URL(string: repositoryURL) {
                    
                    Link(destination: url) {
                        HStack {
                            Image(
                                systemName: "chevron.left.forwardslash.chevron.right"
                            )
                            
                            Text("View GitHub Repository")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(
                                systemName: "arrow.up.right"
                            )
                            .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundStyle(.white)
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
