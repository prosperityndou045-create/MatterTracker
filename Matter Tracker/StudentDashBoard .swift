//
//  StudentDashBoard .swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI

// MARK: - File-scoped theme (kept separate from other files to avoid redeclaration conflicts)

private let dashNavy = Color(red: 0.09, green: 0.13, blue: 0.22)
private let dashOrange = Color(red: 0.91, green: 0.44, blue: 0.19)

struct StudentDashboardView: View {
    @Environment(AppDataManager.self) private var dataManager
    
    // Sample dashboard state data (unchanged)
    @State private var completedTasksCount = 4
    @State private var totalTasksCount = 6
    
    // MARK: Derived data from AppDataManager
    
    private var currentUserIndex: Int? {
        dataManager.students.firstIndex(where: { $0.isCurrentUser })
    }
    
    private var currentSkills: [SkillRecord] {
        guard let index = currentUserIndex else { return [] }
        return dataManager.students[index].skills
    }
    
    private var skillsDemonstratedCount: Int {
        currentSkills.filter { $0.currentStatus == .demonstrated }.count
    }
    
    private var totalEvidenceCount: Int {
        currentSkills.reduce(0) { $0 + $1.evidences.count }
    }
    
    private var pendingReviewCount: Int {
        currentSkills.reduce(0) { count, skill in
            count + skill.evidences.filter { $0.status == .needsReview }.count
        }
    }
    
    private var overallProgressPercent: Int {
        guard !currentSkills.isEmpty else { return 0 }
        return Int((Double(skillsDemonstratedCount) / Double(currentSkills.count)) * 100)
    }
    
    private var latestWeeklyReport: WeeklyStatusEntry? {
        dataManager.weeklyReports.max(by: { $0.date < $1.date })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("WelcomePageBackground")
                        .resizable()
                        .ignoresSafeArea()

                Color(hex: "#153A55")
                        .opacity(0.75) // adjust so it reads clearly over the image
                        .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        statsGrid
                        weeklyStatusSection
                        skillsEvidenceSection
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(dashNavy, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    // MARK: - 1. Header: welcome text + avatar shortcut (unchanged functionality, restyled)
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                // Displays saved student name dynamically from AppDataManager
                Text(dataManager.name)
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            Spacer()
            
            // Shortcut to Profile View
            NavigationLink(destination: ProfileView()) {
                if let imageData = dataManager.profileImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(dashOrange)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - 2. Stat grid (real data, matches wireframe's 4-up cards)
    
    private var statsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            DashStatCard(icon: "graduationcap.fill", title: "Skills\ndemonstrated", value: "\(skillsDemonstratedCount)")
            DashStatCard(icon: "checkmark.circle.fill", title: "Evidence\nSubmitted", value: "\(totalEvidenceCount)")
            DashStatCard(icon: "timer", title: "Pending\nReview", value: "\(pendingReviewCount)")
            DashStatCard(icon: "trophy.fill", title: "Overall\nProgress", value: "\(overallProgressPercent)%")
        }
        .padding(.horizontal)
    }
    
    // MARK: - 3. Weekly Status Report shortcut (new)
    
    private var weeklyStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Status Report")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            NavigationLink(destination: WeeklyStatusReportView()) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(dashOrange, lineWidth: 1.5)
                            .frame(width: 46, height: 46)
                        Image(systemName: "waveform")
                            .foregroundColor(.black.opacity(0.75))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if let latest = latestWeeklyReport {
                            Text("Last check-in: \(latest.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                            Text("\(latest.book.shortName) · Section \(latest.section) · Score \(latest.boldVoiceScore)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        } else {
                            Text("No check-ins yet")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                            Text("Tap to log this week's progress")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(14)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
    
    // MARK: - 5. Skills Evidence list (new: real skills, tap -> SkillDetailView)
    
    private var skillsEvidenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills Evidence")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if let index = currentUserIndex, !currentSkills.isEmpty {
                VStack(spacing: 12) {
                    ForEach(currentSkills.prefix(4)) { skill in
                        if let skillIndex = dataManager.students[index].skills.firstIndex(where: { $0.id == skill.id }) {
                            NavigationLink(destination: SkillDetailView(skill: Binding(
                                get: { dataManager.students[index].skills[skillIndex] },
                                set: { dataManager.students[index].skills[skillIndex] = $0 }
                            ))) {
                                DashSkillRow(icon: skill.type.iconName, title: skill.name, subtitle: skill.description)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No skills added yet.")
                    .foregroundColor(.white.opacity(0.6))
                    .italic()
                    .padding(.horizontal)
            }
            
            NavigationLink(destination: SkillTrackerView()) {
                Label("Add a new skill", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(dashOrange)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
    
    
    // MARK: - Supporting Components
    
    /// Wireframe-style stat card (icon badge, 2-line label, big value)
    struct DashStatCard: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(dashOrange)
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(value)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(dashOrange)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
            .background(Color.white.opacity(0.06))
            .cornerRadius(14)
        }
    }
    
    /// Wireframe-style skill row (icon, title, subtitle, arrow) on a white card
    struct DashSkillRow: View {
        let icon: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(dashOrange, lineWidth: 1.5)
                        .frame(width: 46, height: 46)
                    Image(systemName: icon)
                        .foregroundColor(.black.opacity(0.75))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(14)
        }
    }
    
    struct DashboardScheduleCard: View {
        let course: String
        let time: String
        let room: String
        let color: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                    Text(time)
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                }
                Text(course)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(room)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: 160, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    struct DashboardGridButton: View {
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            Button(action: {
                print("\(title) tapped")
            }) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Canvas Preview
}
#Preview {
    StudentDashboardView()
        .environment(AppDataManager())
}
