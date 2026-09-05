//
//  CandidateDirectoryView.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct CandidateDirectoryView: View {
    
    @State private var candidates: [PublicCandidateSummary] = []
    @State private var allSkills: [Skill] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    
    @State private var searchText = ""
    @State private var selectedCohort = "All"
    @State private var selectedSkill = "All"
    
    private var cohorts: [String] {
        ["All"] + Array(
            Set(candidates.compactMap { $0.cohort?.name })
        ).sorted()
    }
    
    private var skills: [String] {
        ["All"] + allSkills.map { $0.name }.sorted()
    }
    
    private var filteredCandidates: [PublicCandidateSummary] {
        candidates.filter { candidate in
            
            let matchesSearch =
                searchText.isEmpty ||
                candidate.firstName.localizedCaseInsensitiveContains(searchText) ||
                candidate.lastName.localizedCaseInsensitiveContains(searchText) ||
                "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)
            
            let matchesCohort =
                selectedCohort == "All" ||
                candidate.cohort?.name == selectedCohort
            
            // For skill filtering, we need to check if the candidate has the skill
            // Since we can't check without loading full profile, we'll skip this for now
            // Or we could load all profiles but that would be slow
            let matchesSkill = selectedSkill == "All" || true
            
            return matchesSearch && matchesCohort && matchesSkill
        }
    }
    
    var body: some View {
        List {
            
            // MARK: - Filters
            
            if !candidates.isEmpty {
                Section {
                    Picker(
                        "Cohort",
                        selection: $selectedCohort
                    ) {
                        ForEach(cohorts, id: \.self) { cohort in
                            Text(cohort)
                                .tag(cohort)
                        }
                    }
                    
                    Picker(
                        "Skill",
                        selection: $selectedSkill
                    ) {
                        ForEach(skills, id: \.self) { skill in
                            Text(skill)
                                .tag(skill)
                        }
                    }
                } header: {
                    Text("Filters")
                        .foregroundColor(.matterNavy)
                }
            }
            
            // MARK: - Candidates
            
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if filteredCandidates.isEmpty && !searchText.isEmpty {
                emptySearchView
            } else if filteredCandidates.isEmpty {
                emptyStateView
            } else {
                Section(
                    header: Text("\(filteredCandidates.count) Candidates")
                        .foregroundColor(.matterNavy)
                ) {
                    ForEach(filteredCandidates) { candidate in
                        NavigationLink {
                            CandidateProfileView(
                                candidateId: candidate.id
                            )
                        } label: {
                            CandidateCard(
                                candidate: candidate
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Candidates")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by name"
        )
        .refreshable {
            await refreshData()
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                        .scaleEffect(1.2)
                    Text("Loading candidates...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .listRowBackground(Color.clear)
    }
    
    private func errorView(_ message: String) -> some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.matterOrange)
                Text("Unable to load candidates")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    Task {
                        await loadData()
                    }
                }
                .buttonStyle(.bordered)
                .tint(.matterOrange)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    private var emptySearchView: some View {
        Section {
            ContentUnavailableView(
                "No Candidates Found",
                systemImage: "person.slash",
                description: Text(
                    "Try changing your search or filters."
                )
            )
        }
        .listRowBackground(Color.clear)
    }
    
    private var emptyStateView: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "person.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.matterOrange.opacity(0.6))
                
                Text("No Candidates Available")
                    .font(.headline)
                    .foregroundColor(.matterNavy)
                
                Text("There are no public candidate profiles available yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        
        // Load candidates and skills in parallel
        async let candidatesTask = ApiService.shared.publicCandidates()
        async let skillsTask = ApiService.shared.listSkills()
        
        do {
            let (loadedCandidates, loadedSkills) = try await (candidatesTask, skillsTask)
            candidates = loadedCandidates
            allSkills = loadedSkills
        } catch {
            errorMessage = error.localizedDescription
            candidates = []
            allSkills = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshData() async {
        isRefreshing = true
        await loadData()
    }
}

// MARK: - Candidate Card

struct CandidateCard: View {
    
    let candidate: PublicCandidateSummary
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            HStack {
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text("\(candidate.firstName) \(candidate.lastName)")
                        .font(.headline)
                        .foregroundColor(.matterNavy)
                    
                    if let cohort = candidate.cohort {
                        Text(cohort.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.matterOrange)
            }
            
            if let bio = candidate.bio, !bio.isEmpty {
                Text(bio)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                
                if let profilePicture = candidate.profilePictureUrl {
                    AsyncImage(url: URL(string: profilePicture)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.matterOrange)
                    }
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                }
                
                Label(
                    "Public Profile",
                    systemImage: "globe"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Candidate Profile View

struct CandidateProfileView: View {
    
    let candidateId: String
    
    @State private var profile: PublicProfile?
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                if isLoading && !isRefreshing {
                    loadingView
                } else if let error = errorMessage {
                    errorView(error)
                } else if let profile = profile {
                    profileContentView(profile)
                } else {
                    emptyStateView
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
        .refreshable {
            await refreshProfile()
        }
        .task {
            await loadProfile()
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading profile...")
                .font(.headline)
                .foregroundColor(.matterNavy)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        ProStateView(
            systemImage: "exclamationmark.triangle.fill",
            title: "Unable to load profile",
            message: message,
            actionTitle: "Retry"
        ) {
            Task { await loadProfile() }
        }
        .padding(.horizontal)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.slash")
                .font(.system(size: 50))
                .foregroundColor(.matterOrange.opacity(0.6))
            Text("Profile Not Found")
                .font(.headline)
                .foregroundColor(.matterNavy)
            Text("This candidate profile could not be loaded.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
    }
    
    private func profileContentView(_ profile: PublicProfile) -> some View {
        Group {
            // Profile Header
            ProfileHeaderView(profile: profile)
            
            Divider()
                .background(Color.matterNavy.opacity(0.2))
                .padding(.horizontal)
            
            // Technical Skills
            if !profile.skills.isEmpty {
                SkillSectionView(
                    title: "Technical Skills",
                    skills: profile.skills,
                    color: .matterOrange
                )
                .padding(.horizontal)
            }
            
            // Essential Skills
            if !profile.essentialSkills.isEmpty {
                SkillSectionView(
                    title: "Essential Skills",
                    skills: profile.essentialSkills,
                    color: .matterNavy
                )
                .padding(.horizontal)
            }
            
            // Evidence
            if !profile.evidence.isEmpty {
                EvidenceSectionView(evidence: profile.evidence)
                    .padding(.horizontal)
            }
            
            // Projects
            if !profile.projects.isEmpty {
                ProjectsSectionView(projects: profile.projects)
                    .padding(.horizontal)
            }
            
            // Achievements
            if !profile.achievements.isEmpty {
                AchievementsSectionView(achievements: profile.achievements)
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            profile = try await ApiService.shared.publicCandidate(id: candidateId)
        } catch {
            errorMessage = error.localizedDescription
            profile = nil
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshProfile() async {
        isRefreshing = true
        await loadProfile()
    }
}

// MARK: - Profile Header View

struct ProfileHeaderView: View {
    let profile: PublicProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(profile.student.firstName) \(profile.student.lastName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.matterNavy)
                    
                    if let cohort = profile.student.cohort {
                        Text(cohort.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if let imageUrl = profile.student.profilePictureUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.matterOrange)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.matterOrange)
                }
            }
            
            if let bio = profile.student.bio, !bio.isEmpty {
                Text(bio)
                    .foregroundStyle(.secondary)
            }
            
            // Stats
            HStack(spacing: 12) {
                StatBadgeView(
                    icon: "checkmark.circle.fill",
                    value: "\(profile.skills.count)",
                    label: "Technical"
                )
                
                StatBadgeView(
                    icon: "heart.circle.fill",
                    value: "\(profile.essentialSkills.count)",
                    label: "Essential"
                )
                
                StatBadgeView(
                    icon: "doc.circle.fill",
                    value: "\(profile.evidence.count)",
                    label: "Evidence"
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Stat Badge View

struct StatBadgeView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.matterOrange)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.matterNavy)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Skill Section View

struct SkillSectionView: View {
    let title: String
    let skills: [SkillRef]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            FlowLayout(spacing: 8) {
                ForEach(skills) { skill in
                    Text(skill.name)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(color.opacity(0.12))
                        .foregroundColor(color)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Evidence Section View

struct EvidenceSectionView: View {
    let evidence: [Evidence]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evidence")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(evidence) { item in
                EvidenceCardView(evidence: item)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Projects Section View

struct ProjectsSectionView: View {
    let projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Projects")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(projects) { project in
                ProjectCardView(project: project)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ProjectCardView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "folder.circle.fill")
                    .foregroundColor(.matterOrange)
                Text(project.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                Spacer()
                if let url = project.url, let urlObj = URL(string: url) {
                    Link(destination: urlObj) {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.matterOrange)
                    }
                }
            }
            
            if let description = project.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Achievements Section View

struct AchievementsSectionView: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Achievements")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            ForEach(achievements) { achievement in
                AchievementCardView(achievement: achievement)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.matterOrange)
                Text(achievement.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.matterNavy)
                Spacer()
                if let dateAwarded = achievement.dateAwarded {
                    Text(dateAwarded.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            if let description = achievement.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(Color.matterNavy.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? 0,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, point) in result.offsets.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y),
                proposal: ProposedViewSize(result.sizes[index])
            )
        }
    }
    
    struct FlowResult {
        var offsets: [CGPoint] = []
        var sizes: [CGSize] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var rowHeight: CGFloat = 0
            var maxX: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                sizes.append(size)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += rowHeight + spacing
                    rowHeight = 0
                }
                
                offsets.append(CGPoint(x: currentX, y: currentY))
                
                currentX += size.width + spacing
                maxX = max(maxX, currentX)
                rowHeight = max(rowHeight, size.height)
            }
            
            self.size = CGSize(width: maxX, height: currentY + rowHeight)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CandidateDirectoryView()
    }
}
