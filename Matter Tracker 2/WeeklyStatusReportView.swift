
//
//  WeeklyStatusReportView.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI

struct WeeklyStatusReportView: View {
    @State private var reports: [WeeklyStatusEntry] = []
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    @State private var showingAddSheet = false
    
    private var sortedReports: [WeeklyStatusEntry] {
        reports.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.matterNavy
                .ignoresSafeArea()
            
            // Decorative gradient
            VStack {
                Circle()
                    .fill(Color.matterOrange.opacity(0.08))
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: -100)
                
                Spacer()
                
                Circle()
                    .fill(Color.matterOrange.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .offset(x: -120, y: 100)
            }
            .ignoresSafeArea()
            
            if isLoading && !isRefreshing {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else {
                List {
                    if sortedReports.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(sortedReports) { entry in
                            WeeklyReportRow(entry: entry)
                        }
                        .onDelete { offsets in
                            let idsToDelete = offsets.map { sortedReports[$0].id }
                            Task {
                                for id in idsToDelete {
                                    await deleteReport(id: id)
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .refreshable {
                    await refreshReports()
                }
            }
        }
        .navigationTitle("Weekly Check-ins")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Weekly Check-ins")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.matterOrange)
                }
            }
        }
        .task {
            await loadReports()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddWeeklyReportSheet(onSave: {
                await loadReports()
            })
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            
            Text("Loading your check-ins...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.matterOrange)
            
            Text("Unable to Load Check-ins")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                Task { await loadReports() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.matterOrange)
                    .cornerRadius(10)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(.matterOrange.opacity(0.6))
            
            Text("No Check-ins Yet")
                .font(.headline)
                .foregroundColor(.matterNavy)
            
            Text("Start tracking your weekly progress by adding your first check-in.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddSheet = true
            } label: {
                Label("Add Your First Check-in", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.matterOrange)
                    .cornerRadius(10)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .listRowBackground(Color.clear)
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadReports() async {
        isLoading = true
        errorMessage = nil
        
        do {
            reports = try await ApiService.shared.getWeeklyReports()
        } catch {
            errorMessage = error.localizedDescription
            reports = []
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    @MainActor
    private func refreshReports() async {
        isRefreshing = true
        await loadReports()
    }
    
    @MainActor
    private func deleteReport(id: String) async {
        do {
            try await ApiService.shared.deleteWeeklyReport(id: id)
            await loadReports()
        } catch {
            errorMessage = error.localizedDescription
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Date
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.matterOrange)
                    
                    Text(dateFormatted)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.matterNavy)
                }
                
                Spacer()
                
                // Score
                HStack(spacing: 6) {
                    Image(systemName: "waveform")
                        .font(.caption)
                        .foregroundColor(.matterOrange)
                    
                    Text("\(entry.boldVoiceScore)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.matterOrange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.matterOrange.opacity(0.12))
                .clipShape(Capsule())
            }
            
            // Book
            HStack(spacing: 6) {
                Image(systemName: "book.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(entry.book.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.matterNavy)
            }
            
            // Section
            HStack(spacing: 6) {
                Image(systemName: "list.bullet.rectangle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Section: \(entry.section)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

// MARK: - Add Weekly Report Sheet

struct AddWeeklyReportSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: () async -> Void
    
    @State private var date = Date()
    @State private var boldVoiceScoreText = ""
    @State private var selectedBook: SwiftBook = .fundamentals
    @State private var section = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    private var isValid: Bool {
        !section.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && Int(boldVoiceScoreText) != nil
            && (Int(boldVoiceScoreText) ?? 0) >= 0
            && (Int(boldVoiceScoreText) ?? 0) <= 100
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .accentColor(.matterOrange)
                } header: {
                    Text("Date")
                        .foregroundColor(.matterNavy)
                }
                
                Section {
                    TextField("e.g. 82", text: $boldVoiceScoreText)
                        .keyboardType(.numberPad)
                    
                    if let score = Int(boldVoiceScoreText), score < 0 || score > 100 {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Score must be between 0 and 100")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("BoldVoice Score")
                        .foregroundColor(.matterNavy)
                }
                
                Section {
                    Picker("Book", selection: $selectedBook) {
                        ForEach(SwiftBook.allCases) { book in
                            Text(book.shortName).tag(book)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.matterOrange)
                } header: {
                    Text("Swift Book")
                        .foregroundColor(.matterNavy)
                }
                
                Section {
                    TextField("e.g. Unit 3, Lesson 2", text: $section)
                } header: {
                    Text("Section / Unit")
                        .foregroundColor(.matterNavy)
                }
                
                if let error = errorMessage {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section {
                    Button {
                        submitReport()
                    } label: {
                        if isSubmitting {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                Text("Saving...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Save Check-in")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isValid || isSubmitting)
                    .buttonStyle(.borderedProminent)
                    .tint(.matterOrange)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.matterOrange)
                }
            }
        }
    }
    
    @MainActor
    private func submitReport() {
        guard let score = Int(boldVoiceScoreText), score >= 0 && score <= 100 else { return }
        
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await ApiService.shared.createWeeklyReport(
                    date: date,
                    boldVoiceScore: score,
                    book: selectedBook,
                    section: section.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                
                await MainActor.run {
                    isSubmitting = false
                    dismiss()
                    
                    Task {
                        await onSave()
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
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
}
