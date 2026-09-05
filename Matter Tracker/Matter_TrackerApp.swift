//
//  Matter_TrackerApp.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.


import SwiftUI

@main
struct MatterTrackerApp: App {
    
    @AppStorage("darkModeEnabled")
    private var darkModeEnabled = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomePage()
            }
            .preferredColorScheme(
                darkModeEnabled ? .dark : .light
            )
        }
    }
}


