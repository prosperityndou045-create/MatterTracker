//
//  CohortInsightData.swift
//  Matter Tracker
//
//  Created by Tana on 5/9/2026.
//


//
//  CohortInsightData.swift
//  matter hackathon
//
//  Created by Tana on 5/9/2026.
//


import SwiftUI

struct CohortInsightData {
    let students: Int
    let skillsDemonstrated: Int
    let evidenceSubmitted: Int
    let pendingReviews: Int
    
    let communication: Int
    let teamwork: Int
    let problemSolving: Int
    let loops: Int
    let functions: Int
}

let sampleCohortData: [String: CohortInsightData] = [
    
    // MARK: - Cohort 1
    "Cohort 1": CohortInsightData(
        students: 4,
        skillsDemonstrated: 10,
        evidenceSubmitted: 4,
        pendingReviews: 2,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 50
    ),
    
    // MARK: - Cohort 2
    "Cohort 2": CohortInsightData(
        students: 4,
        skillsDemonstrated: 8,
        evidenceSubmitted: 4,
        pendingReviews: 2,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 3
    "Cohort 3": CohortInsightData(
        students: 4,
        skillsDemonstrated: 8,
        evidenceSubmitted: 4,
        pendingReviews: 2,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 4
    "Cohort 4": CohortInsightData(
        students: 4,
        skillsDemonstrated: 8,
        evidenceSubmitted: 4,
        pendingReviews: 1,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 5
    "Cohort 5": CohortInsightData(
        students: 4,
        skillsDemonstrated: 7,
        evidenceSubmitted: 4,
        pendingReviews: 1,
        communication: 25,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 6
    "Cohort 6": CohortInsightData(
        students: 4,
        skillsDemonstrated: 8,
        evidenceSubmitted: 4,
        pendingReviews: 1,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 7
    "Cohort 7": CohortInsightData(
        students: 4,
        skillsDemonstrated: 7,
        evidenceSubmitted: 4,
        pendingReviews: 1,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    ),
    
    // MARK: - Cohort 8
    "Cohort 8": CohortInsightData(
        students: 4,
        skillsDemonstrated: 8,
        evidenceSubmitted: 4,
        pendingReviews: 1,
        communication: 50,
        teamwork: 50,
        problemSolving: 25,
        loops: 25,
        functions: 25
    )
]
