//
//  DashboardView .swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

//
//  DashboardView .swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

//
//  DashboardView .swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import AVKit
import AVFoundation

// MARK: - Skill Type (Technical vs Essential)
// NOTE: This enum is new. Your `SkillRecord` struct (defined in your Models file,
// not in this file) also needs a `type: SkillType` property for this to compile.
// Add this line to that struct's definition:
//     var type: SkillType = .technical
// The default value means any existing SkillRecord(...) calls elsewhere in your
// project keep compiling unchanged.
enum SkillType: String, CaseIterable, Codable {
    case technical = "Technical"
    case essential = "Essential"
    
    var iconName: String {
        switch self {
        case .technical: return "chevron.left.forwardslash.chevron.right"
        case .essential: return "person.fill.checkmark"
        }
    }
}
private let navy = Color(
    red: 0.09,
    green: 0.13,
    blue: 0.22
)



// MARK: - Main Skill Tracker View

struct SkillTrackerView: View {
    @Environment(AppDataManager.self) private var dataManager
    @State private var showingAddSkillSheet = false
    
    var currentUserIndex: Int? {
        dataManager.students.firstIndex(where: { $0.isCurrentUser })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("WelcomePageBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                Color(hex: "#153A55")
                    .opacity(0.55) // adjust so it reads clearly over the image
                    .ignoresSafeArea()
                
                List {
                if let index = currentUserIndex {
                    ForEach(dataManager.students[index].skills) { skill in
                        if let skillIndex = dataManager.students[index].skills.firstIndex(where: { $0.id == skill.id }) {
                            NavigationLink(destination: SkillDetailView(skill: Binding(
                                get: { dataManager.students[index].skills[skillIndex] },
                                set: { dataManager.students[index].skills[skillIndex] = $0 }
                            ))) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(spacing: 6) {
                                            Image(systemName: skill.type.iconName)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text(skill.name)
                                                .font(.headline)
                                        }
                                        Text(skill.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    StatusBadge(status: skill.currentStatus)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .onDelete { offsets in
                        dataManager.students[index].skills.remove(atOffsets: offsets)
                    }
                }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Skill Records")
                        .font(.system(size: 25, weight: .bold)) // Adjust size here
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(
                navy,
                for: .navigationBar
            )
            .toolbarBackground(
                .visible,
                for: .navigationBar
            )
            .toolbarColorScheme(
                .dark,
                for: .navigationBar
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSkillSheet = true }) {
                        Image(systemName: "plus")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showingAddSkillSheet) {
                if let index = currentUserIndex {
                    AddSkillSheet(currentUserIndex: index)
                }
            }
        }
    }
}

// MARK: - Add New Skill Sheet

struct AddSkillSheet: View {
    @Environment(AppDataManager.self) private var dataManager
    @Environment(\.dismiss) private var dismiss
    
    let currentUserIndex: Int
    @State private var skillName = ""
    @State private var skillDescription = ""
    @State private var skillType: SkillType = .technical
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Skill Information")) {
                    TextField("Skill Name (e.g., Optionals)", text: $skillName)
                    TextField("Description", text: $skillDescription, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Skill Type", selection: $skillType) {
                        ForEach(SkillType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add New Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newSkill = SkillRecord(
                            name: skillName.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: skillDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                            evidences: []
                        )
                        if dataManager.students.indices.contains(currentUserIndex) {
                            dataManager.students[currentUserIndex].skills.append(newSkill)
                        }
                        dismiss()
                    }
                    .disabled(skillName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Skill Detail & Evidence View

struct SkillDetailView: View {
    @Binding var skill: SkillRecord
    @State private var showingAddEvidenceSheet = false
    
    var body: some View {
        List {
            Section(header: Text("Skill Overview")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(skill.name)
                            .font(.title2.bold())
                        Text(skill.type.rawValue)
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                    }
                    Text(skill.description)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Current Status:")
                            .font(.subheadline.bold())
                        StatusBadge(status: skill.currentStatus)
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 4)
            }
            
            Section(header: HStack {
                Text("Submitted Evidence")
                Spacer()
                Button(action: { showingAddEvidenceSheet = true }) {
                    Label("Add Evidence", systemImage: "plus.circle.fill")
                        .font(.caption.bold())
                }
            }) {
                if skill.evidences.isEmpty {
                    Text("No evidence attached yet.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(skill.evidences) { evidence in
                        if let evidenceIndex = skill.evidences.firstIndex(where: { $0.id == evidence.id }) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(evidence.title)
                                    .font(.headline)
                                Spacer()
                                Menu {
                                    ForEach(SkillStatus.allCases, id: \.self) { status in
                                        Button(action: {
                                            skill.evidences[evidenceIndex].status = status
                                        }) {
                                            if status == evidence.status {
                                                Label(status.rawValue, systemImage: "checkmark")
                                            } else {
                                                Text(status.rawValue)
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        StatusBadge(status: evidence.status)
                                        Image(systemName: "chevron.down")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            Text("Reviewer: \(evidence.reviewer)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            // Render all attached items for this evidence
                            if !evidence.attachments.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(evidence.attachments) { attachment in
                                        AttachmentRowView(attachment: attachment)
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 6)
                        }
                    }
                    .onDelete { offsets in
                        skill.evidences.remove(atOffsets: offsets)
                    }
                }
            }
        }
        .navigationTitle(skill.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddEvidenceSheet) {
            AddEvidenceSheet(skill: $skill)
        }
    }
}

// MARK: - Row View for Displaying an Attachment

struct AttachmentRowView: View {
    let attachment: Attachment
    @State private var showingVideoPlayer = false
    @State private var showingImageViewer = false
    @State private var videoThumbnail: UIImage?
    
    var body: some View {
        Group {
            switch attachment.type {
            case .photo:
                if let data = attachment.fileData, let uiImage = UIImage(data: data) {
                    Button(action: { showingImageViewer = true }) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showingImageViewer) {
                        ImageDetailSheet(image: uiImage, fileName: attachment.fileName)
                    }
                }
                
            case .video:
                if let data = attachment.fileData {
                    Button(action: { showingVideoPlayer = true }) {
                        ZStack {
                            if let thumbnail = videoThumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(Color.black.opacity(0.25))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.tertiarySystemGroupedBackground))
                                    .frame(height: 140)
                                    .frame(maxWidth: .infinity)
                                    .overlay(ProgressView())
                            }
                            
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Text(attachment.fileName ?? "Video Clip")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.black.opacity(0.4))
                                        .cornerRadius(6)
                                    Spacer()
                                }
                                .padding(8)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .task {
                        if videoThumbnail == nil {
                            videoThumbnail = await Self.generateThumbnail(from: data)
                        }
                    }
                    .sheet(isPresented: $showingVideoPlayer) {
                        VideoPlayerSheet(videoData: data)
                    }
                }
                
            case .document:
                HStack {
                    Image(systemName: "doc.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text(attachment.fileName ?? "Document")
                            .font(.subheadline.bold())
                            .lineLimit(1)
                        if let data = attachment.fileData {
                            Text(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
                
            case .gitHub, .codeSample:
                HStack {
                    Image(systemName: attachment.type.iconName)
                        .foregroundColor(.blue)
                    Text(attachment.urlOrText)
                        .font(.caption2)
                        .fontDesign(.monospaced)
                        .lineLimit(2)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(6)
            }
        }
    }
    
    // Generates a preview frame from raw video Data by writing it to a temp file
    // and pulling the first frame via AVAssetImageGenerator.
    static func generateThumbnail(from videoData: Data) async -> UIImage? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
        do {
            try videoData.write(to: fileURL)
        } catch {
            return nil
        }
        defer { try? FileManager.default.removeItem(at: fileURL) }
        
        let asset = AVURLAsset(url: fileURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try await generator.image(at: CMTime(seconds: 0, preferredTimescale: 600)).image
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
}

// Helper to play Video Data in a Sheet
struct VideoPlayerSheet: View {
    let videoData: Data
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    @State private var tempURL: URL?
    
    var body: some View {
        NavigationStack {
            Group {
                if let player = player {
                    VideoPlayer(player: player)
                } else {
                    ProgressView("Loading Video...")
                }
            }
            .navigationTitle("Video Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                let tempDir = FileManager.default.temporaryDirectory
                let fileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                try? videoData.write(to: fileURL)
                self.tempURL = fileURL
                self.player = AVPlayer(url: fileURL)
                self.player?.play()
            }
            .onDisappear {
                player?.pause()
                if let tempURL = tempURL {
                    try? FileManager.default.removeItem(at: tempURL)
                }
            }
        }
    }
}

// MARK: - Add Evidence Sheet (Multi-Attachment Picker)

struct AddEvidenceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var skill: SkillRecord
    
    @State private var title = ""
    @State private var reviewer = "Facilitator"
    @State private var selectedStatus: SkillStatus = .needsReview
    
    // Multiple Attachments Collection
    @State private var attachments: [Attachment] = []
    
    // Media & File Import States
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedVideoItems: [PhotosPickerItem] = []
    @State private var showingFileImporter = false
    @State private var linkInput = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Evidence Details")) {
                    TextField("Evidence Title (e.g. Project 1)", text: $title)
                    TextField("Reviewer (e.g. Facilitator)", text: $reviewer)
                    
                    Picker("Status", selection: $selectedStatus) {
                        ForEach(SkillStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section(header: Text("Add Attachments")) {
                    // Photos Picker
                    PhotosPicker(selection: $selectedPhotoItems, matching: .images) {
                        Label("Add Photos", systemImage: "photo.badge.plus")
                    }
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        Task {
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    let attachment = Attachment(
                                        type: .photo,
                                        fileData: data,
                                        fileName: "Photo.jpg"
                                    )
                                    attachments.append(attachment)
                                }
                            }
                            selectedPhotoItems = []
                        }
                    }
                    
                    // Videos Picker
                    PhotosPicker(selection: $selectedVideoItems, matching: .videos) {
                        Label("Add Videos", systemImage: "video.badge.plus")
                    }
                    .onChange(of: selectedVideoItems) { _, newItems in
                        Task {
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    let attachment = Attachment(
                                        type: .video,
                                        fileData: data,
                                        fileName: "Video.mov"
                                    )
                                    attachments.append(attachment)
                                }
                            }
                            selectedVideoItems = []
                        }
                    }
                    
                    // Document Importer
                    Button(action: { showingFileImporter = true }) {
                        Label("Add Document / File", systemImage: "doc.badge.plus")
                    }
                    .fileImporter(
                        isPresented: $showingFileImporter,
                        allowedContentTypes: [.pdf, .item],
                        allowsMultipleSelection: true
                    ) { result in
                        if case .success(let urls) = result {
                            for url in urls {
                                if url.startAccessingSecurityScopedResource() {
                                    defer { url.stopAccessingSecurityScopedResource() }
                                    if let data = try? Data(contentsOf: url) {
                                        let attachment = Attachment(
                                            type: .document,
                                            fileData: data,
                                            fileName: url.lastPathComponent
                                        )
                                        attachments.append(attachment)
                                    }
                                }
                            }
                        }
                    }
                    
                    // URL / Link Input
                    HStack {
                        TextField("GitHub / URL Link", text: $linkInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        
                        Button("Add") {
                            guard !linkInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            let attachment = Attachment(
                                type: .gitHub,
                                urlOrText: linkInput.trimmingCharacters(in: .whitespaces)
                            )
                            attachments.append(attachment)
                            linkInput = ""
                        }
                        .disabled(linkInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                
                // List of attached items so far
                if !attachments.isEmpty {
                    Section(header: Text("Attached Items (\(attachments.count))")) {
                        ForEach(attachments) { item in
                            HStack {
                                Label(item.fileName ?? item.type.rawValue, systemImage: item.type.iconName)
                                    .font(.subheadline)
                                Spacer()
                                Button(role: .destructive) {
                                    attachments.removeAll(where: { $0.id == item.id })
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Attach Evidence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEvidence = Evidence(
                            title: title.isEmpty ? "New Evidence" : title,
                            reviewer: reviewer.isEmpty ? "Facilitator" : reviewer,
                            status: selectedStatus,
                            attachments: attachments
                        )
                        skill.evidences.append(newEvidence)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Status Badge Component

struct StatusBadge: View {
    let status: SkillStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.15))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

#Preview {
    SkillTrackerView()
        .environment(AppDataManager())
}
struct ImageDetailSheet: View {
    let image: UIImage
    let fileName: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .navigationTitle(fileName ?? "Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
