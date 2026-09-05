//
//  StudentWeeklyReport.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

//
//  WeeklyStatusReportView.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//
//  Lets the student log a weekly check-in: a BoldVoice score, which Swift
//  book they're working through (Explorations vs Fundamentals), and the
//  section they're on — each dated, building a day-to-day history that
//  persists via AppDataManager.

import SwiftUI

// MARK: - Theme (kept separate from other files to avoid redeclaration conflicts)

private let reportNavy = Color(red: 0.09, green: 0.13, blue: 0.22)
private let reportOrange = Color(red: 0.91, green: 0.44, blue: 0.19)

struct WeeklyStatusReportView: View {
    @Environment(AppDataManager.self) private var dataManager
    @State private var showingAddSheet = false
    
    private var sortedReports: [WeeklyStatusEntry] {
        dataManager.weeklyReports.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack {
            Image("WelcomePageBackground")
                .resizable()
                .ignoresSafeArea()
            
            Color(hex: "#153A55")
                .opacity(0.55)
                .ignoresSafeArea()
            
            List {
                if sortedReports.isEmpty {
                    Text("No weekly check-ins yet. Tap + to add your first one.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(sortedReports) { entry in
                        WeeklyReportRow(entry: entry)
                    }
                    .onDelete { offsets in
                        // Map offsets from the sorted (display) list back to
                        // the underlying storage order before deleting.
                        let idsToDelete = offsets.map { sortedReports[$0].id }
                        let storageOffsets = IndexSet(
                            dataManager.weeklyReports.indices.filter {
                                idsToDelete.contains(dataManager.weeklyReports[$0].id)
                            }
                        )
                        dataManager.deleteWeeklyReport(at: storageOffsets)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Weekly Status Report")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(reportNavy, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddWeeklyReportSheet()
        }
    }
}

// MARK: - Report Row

struct WeeklyReportRow: View {
    let entry: WeeklyStatusEntry
    
    private var dateFormatted: String {
        entry.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatted)
                    .font(.subheadline.bold())
                
                Spacer()
                
                Label("\(entry.boldVoiceScore)", systemImage: "waveform")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(reportOrange.opacity(0.15))
                    .foregroundColor(reportOrange)
                    .cornerRadius(6)
            }
            
            Text(entry.book.rawValue)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Text("Section: \(entry.section)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Weekly Report Sheet

struct AddWeeklyReportSheet: View {
    @Environment(AppDataManager.self) private var dataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var date = Date()
    @State private var boldVoiceScoreText = ""
    @State private var selectedBook: SwiftBook = .fundamentals
    @State private var section = ""
    
    private var isValid: Bool {
        !section.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && Int(boldVoiceScoreText) != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section(header: Text("BoldVoice Score")) {
                    TextField("e.g. 82", text: $boldVoiceScoreText)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Swift Book")) {
                    Picker("Book", selection: $selectedBook) {
                        ForEach(SwiftBook.allCases) { book in
                            Text(book.shortName).tag(book)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Section / Unit")) {
                    TextField("e.g. Unit 3, Lesson 2", text: $section)
                }
            }
            .navigationTitle("New Weekly Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let score = Int(boldVoiceScoreText) else { return }
                        let entry = WeeklyStatusEntry(
                            date: date,
                            boldVoiceScore: score,
                            book: selectedBook,
                            section: section.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dataManager.addWeeklyReport(entry)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        WeeklyStatusReportView()
    }
    .environment(AppDataManager())
}
