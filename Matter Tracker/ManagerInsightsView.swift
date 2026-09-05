import SwiftUI

struct ManagerInsightsView: View {
    
    let selectedCohort: String
    
    var data: CohortInsightData? {
        sampleCohortData[selectedCohort]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Program Insights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("A quick overview of what is happening in this cohort.")
                        .foregroundStyle(.secondary)
                }
                
                if let data = data {
                    
                    // MARK: - Overall Update
                    InsightCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Overall Progress",
                        text: overallInsight(data)
                    )
                    
                    // MARK: - Positive Trend
                    InsightCard(
                        icon: "arrow.up.circle.fill",
                        title: "Positive Trend",
                        text: strongestSkillInsight(data)
                    )
                    
                    // MARK: - Needs Attention
                    InsightCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Needs Attention",
                        text: weakestSkillInsight(data)
                    )
                    
                    // MARK: - Evidence
                    InsightCard(
                        icon: "doc.text.fill",
                        title: "Evidence Activity",
                        text: evidenceInsight(data)
                    )
                    
                    // MARK: - Recommendation
                    InsightCard(
                        icon: "lightbulb.fill",
                        title: "Recommendation",
                        text: recommendationInsight(data)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
    
    // MARK: - Insight Calculations
    
    func overallInsight(_ data: CohortInsightData) -> String {
        let average = (
            data.communication +
            data.teamwork +
            data.problemSolving +
            data.loops +
            data.functions
        ) / 5
        
        return "The cohort has an average skill demonstration rate of \(average)%. \(data.students) students are currently being tracked."
    }
    
    func strongestSkillInsight(_ data: CohortInsightData) -> String {
        let skills = [
            ("Communication", data.communication),
            ("Teamwork", data.teamwork),
            ("Problem Solving", data.problemSolving),
            ("Loops", data.loops),
            ("Functions", data.functions)
        ]
        
        let strongest = skills.max { $0.1 < $1.1 }!
        
        return "\(strongest.0) is currently the strongest demonstrated skill at \(strongest.1)%."
    }
    
    func weakestSkillInsight(_ data: CohortInsightData) -> String {
        let skills = [
            ("Communication", data.communication),
            ("Teamwork", data.teamwork),
            ("Problem Solving", data.problemSolving),
            ("Loops", data.loops),
            ("Functions", data.functions)
        ]
        
        let weakest = skills.min { $0.1 < $1.1 }!
        
        return "\(weakest.0) is currently the least demonstrated skill at \(weakest.1)%. This area may require additional support."
    }
    
    func evidenceInsight(_ data: CohortInsightData) -> String {
        return "\(data.evidenceSubmitted) pieces of evidence have been submitted, with \(data.pendingReviews) currently awaiting review."
    }
    
    func recommendationInsight(_ data: CohortInsightData) -> String {
        let skills = [
            ("Communication", data.communication),
            ("Teamwork", data.teamwork),
            ("Problem Solving", data.problemSolving),
            ("Loops", data.loops),
            ("Functions", data.functions)
        ]
        
        let weakest = skills.min { $0.1 < $1.1 }!
        
        return "Consider providing additional learning opportunities and support around \(weakest.0)."
    }
}


struct InsightCard: View {
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

