import SwiftUI

struct SkillsFrameworkView: View {
    
    let groups: [MockData.FrameworkGroup]
    
    var body: some View {
        List {
            ForEach(groups) { group in
                
                Section(group.category) {
                    
                    ForEach(group.entries) { entry in
                        
                        NavigationLink {
                            SkillFrameworkDetailView(
                                entry: entry
                            )
                        } label: {
                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {
                                Text(entry.name)
                                    .fontWeight(.semibold)
                                
                                Text(entry.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Skills Framework")
    }
}
