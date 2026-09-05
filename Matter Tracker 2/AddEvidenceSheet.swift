//
//  AddEvidenceSheet.swift
//  Matter Tracker
//
//  Created by Mthusi on 5/9/2026.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import AVKit
import AVFoundation

// MARK: - Add Evidence Sheet with File Upload

struct AddEvidenceSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let skillId: String
    @State private var currentUserId: String?
    
    @State private var title = ""
    @State private var description = ""
    @State private var evidenceType: EvidenceType = .project
    @State private var githubUrl = ""
    @State private var videoUrl = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var uploadProgress: Double = 0
    @State private var showProgress = false
    
    // File attachments
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedVideoItems: [PhotosPickerItem] = []
    @State private var showingFileImporter = false
    @State private var attachments: [Attachment] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Evidence Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Type", selection: $evidenceType) {
                        ForEach(EvidenceType.allCases, id: \.self) { type in
                            Text(type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                .tag(type)
                        }
                    }
                }
                
                Section("Links (Optional)") {
                    TextField("GitHub URL", text: $githubUrl)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Video URL", text: $videoUrl)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section("Attachments") {
                    // Photos Picker
                    PhotosPicker(selection: $selectedPhotoItems, matching: .images) {
                        Label("Add Photos", systemImage: "photo.badge.plus")
                            .foregroundColor(.matterOrange)
                    }
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        Task {
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    let attachment = Attachment(
                                        type: .photo,
                                        fileData: data,
                                        fileName: "Photo_\(Date().timeIntervalSince1970).jpg"
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
                            .foregroundColor(.matterOrange)
                    }
                    .onChange(of: selectedVideoItems) { _, newItems in
                        Task {
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    let attachment = Attachment(
                                        type: .video,
                                        fileData: data,
                                        fileName: "Video_\(Date().timeIntervalSince1970).mov"
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
                            .foregroundColor(.matterOrange)
                    }
                    .fileImporter(
                        isPresented: $showingFileImporter,
                        allowedContentTypes: [.pdf, .text, .plainText, .image, .item],
                        allowsMultipleSelection: true
                    ) { result in
                        switch result {
                        case .success(let urls):
                            for url in urls {
                                let gotAccess = url.startAccessingSecurityScopedResource()
                                defer {
                                    if gotAccess {
                                        url.stopAccessingSecurityScopedResource()
                                    }
                                }
                                
                                if let data = try? Data(contentsOf: url) {
                                    let attachment = Attachment(
                                        type: .document,
                                        fileData: data,
                                        fileName: url.lastPathComponent
                                    )
                                    attachments.append(attachment)
                                }
                            }
                        case .failure(let error):
                            print("File import error: \(error)")
                        }
                    }
                    
                    // Code sample input
                    HStack {
                        TextField("Code Sample URL", text: $githubUrl)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                
                // Attachments list
                if !attachments.isEmpty {
                    Section("Attached Files (\(attachments.count))") {
                        ForEach(attachments) { item in
                            HStack {
                                Image(systemName: attachmentIcon(for: item.type))
                                    .foregroundColor(.matterOrange)
                                Text(item.fileName ?? "File")
                                    .font(.subheadline)
                                Spacer()
                                if let data = item.fileData {
                                    Text(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
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
                
                if showProgress {
                    Section("Upload Progress") {
                        ProgressView(value: uploadProgress, total: 1.0)
                            .progressViewStyle(.linear)
                            .tint(.matterOrange)
                        Text("\(Int(uploadProgress * 100))% complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
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
                        submitEvidenceWithFiles()
                    } label: {
                        if isSubmitting {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                Text("Submitting...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Submit Evidence")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
                    .buttonStyle(.borderedProminent)
                    .tint(.matterOrange)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Add Evidence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.matterOrange)
                }
            }
        }
        .task {
            await loadCurrentUser()
        }
    }
    
    // MARK: - Helper Functions
    
    private func attachmentIcon(for type: AttachmentType) -> String {
        switch type {
        case .photo: return "photo.fill"
        case .video: return "video.fill"
        case .document: return "doc.fill"
        case .gitHub: return "chevron.left.forwardslash.chevron.right"
        case .codeSample: return "chevron.left.forwardslash.chevron.right"
        }
    }

    private func mimeType(for fileName: String) -> String {
        let ext = (fileName as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "gif": return "image/gif"
        case "pdf": return "application/pdf"
        case "txt": return "text/plain"
        case "swift": return "text/x-swift"
        case "mov": return "video/quicktime"
        case "mp4": return "video/mp4"
        case "doc", "docx": return "application/msword"
        case "xls", "xlsx": return "application/vnd.ms-excel"
        default: return "application/octet-stream"
        }
    }
    
    @MainActor
    private func loadCurrentUser() async {
        do {
            let user = try await ApiService.shared.me()
            currentUserId = user.id
        } catch {
            print("Failed to load user: \(error)")
        }
    }
    
    @MainActor
    private func submitEvidenceWithFiles() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        guard let userId = currentUserId else { return }
        
        isSubmitting = true
        errorMessage = nil
        showProgress = true
        uploadProgress = 0
        
        Task {
            do {
                // Prepare attachments for upload
                let files = attachments.map { attachment in
                    (
                        data: attachment.fileData ?? Data(),
                        fileName: attachment.fileName ?? "file",
                        mimeType: mimeType(for: attachment.fileName ?? "file")
                    )
                }
                
                // Submit evidence with files
                _ = try await ApiService.shared.submitEvidenceWithFiles(
                    studentId: userId,
                    skillId: skillId,
                    type: evidenceType,
                    title: trimmedTitle,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                    attachmentFiles: files,
                    githubUrl: githubUrl.isEmpty ? nil : githubUrl,
                    videoUrl: videoUrl.isEmpty ? nil : videoUrl
                )
                
                await MainActor.run {
                    isSubmitting = false
                    showProgress = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    showProgress = false
                    errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddEvidenceSheet(skillId: "test-skill-id")
}
