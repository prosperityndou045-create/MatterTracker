import SwiftUI

// MARK: - Facilitator Dashboard

struct FacilitatorDashboardView: View {
    
    var body: some View {
        
        // NavigationStack allows us to navigate
        // from the dashboard to other pages.
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Header
                    
                    Text("Facilitator Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Monitor and support your assigned students.")
                        .foregroundStyle(.secondary)
                    
                    
                    // MARK: Dashboard Summary
                    
                    HStack(spacing: 15) {
                        
                        DashboardCard(
                            title: "Students",
                            value: "24",
                            icon: "person.3.fill"
                        )
                        
                        DashboardCard(
                            title: "Pending",
                            value: "8",
                            icon: "clock.fill"
                        )
                    }
                    
                    
                    HStack(spacing: 15) {
                        
                        DashboardCard(
                            title: "Completed",
                            value: "16",
                            icon: "checkmark.circle.fill"
                        )
                        
                        DashboardCard(
                            title: "Progress",
                            value: "72%",
                            icon: "chart.bar.fill"
                        )
                    }
                    
                    
                    // MARK: Quick Actions
                    
                    Text("Quick Actions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    
                    // MARK: Assigned Students
                    
                    NavigationLink {
                        
                        // This is the page that opens
                        // when the facilitator taps
                        // "Assigned Students".
                        AssignedStudentsView()
                        
                    } label: {
                        
                        DashboardRow(
                            title: "Assigned Students",
                            subtitle: "View and manage your students",
                            icon: "person.2.fill"
                        )
                    }
                    
                    
                    // MARK: Pending Evidence
                    
                    NavigationLink {
                        
                        EvidenceReviewView()
                        
                    } label: {
                        
                        DashboardRow(
                            title: "Pending Evidence",
                            subtitle: "Review student submissions",
                            icon: "doc.text.fill"
                        )
                    }
                    
                    
                    // MARK: Student Progress
                    
                    NavigationLink {
                        
                        StudentProgressView()
                        
                    } label: {
                        
                        DashboardRow(
                            title: "Student Progress",
                            subtitle: "Monitor student development",
                            icon: "chart.line.uptrend.xyaxis"
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}


// MARK: - Dashboard Card

struct DashboardCard: View {
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            // Icon
            Image(systemName: icon)
                .font(.title2)
            
            // Number
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            // Card title
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


// MARK: - Dashboard Row

struct DashboardRow: View {
    
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            
            Spacer()
            
            
            // Arrow showing that this row
            // can be opened.
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


// MARK: - Temporary Views

// You can replace these with your actual views later.

struct EvidenceReviewView: View {
    
    var body: some View {
        
        Text("Evidence Review")
            .navigationTitle("Evidence")
    }
}


struct StudentProgressView: View {
    
    var body: some View {
        
        Text("Student Progress")
            .navigationTitle("Progress")
    }
}


// MARK: - Preview

#Preview {
    FacilitatorDashboardView()
}