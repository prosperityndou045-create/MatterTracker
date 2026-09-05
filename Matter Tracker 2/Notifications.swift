//
//  NotificationsView.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [NotificationItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    var body: some View {
        ZStack {
            Color.matterNavy.ignoresSafeArea()

            if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else if notifications.isEmpty {
                emptyView
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach($notifications) { $notification in
                            NotificationRow(notification: $notification)
                                .padding(.horizontal)
                                .onTapGesture {
                                    markAsRead(notification)
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Notifications")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    if unreadCount > 0 {
                        Text("(\(unreadCount) new)")
                            .font(.caption)
                            .foregroundColor(.matterOrange)
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                if !notifications.isEmpty {
                    Button("Clear All") {
                        clearAll()
                    }
                    .font(.subheadline)
                    .foregroundColor(.matterOrange)
                }
            }
        }
        .task {
            await loadNotifications()
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .matterOrange))
                .scaleEffect(1.5)
            Text("Loading notifications...")
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.matterOrange)
            Text("Couldn't load notifications")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
            Button("Try Again") {
                Task { await loadNotifications() }
            }
            .buttonStyle(.bordered)
            .tint(.matterOrange)
        }
        .padding(32)
    }

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.3))
            Text("No notifications")
                .font(.headline)
                .foregroundColor(.white)
            Text("You're all caught up.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 80)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Data Loading

    @MainActor
    private func loadNotifications() async {
        isLoading = true
        errorMessage = nil

        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 800_000_000)

            // In a real app, fetch from API
            // For now, create sample data
            notifications = NotificationItem.samples
        } catch {
            errorMessage = error.localizedDescription
            notifications = []
        }

        isLoading = false
    }

    // MARK: - Actions

    private func markAsRead(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
        // In a real app, send API call to mark as read
    }

    private func clearAll() {
        notifications.removeAll()
        // In a real app, send API call to clear all
    }
}

// MARK: - Notification Item

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let icon: String
    let timestamp: Date
    var isRead: Bool

    static var samples: [NotificationItem] {
        let now = Date()
        return [
            NotificationItem(
                title: "Evidence Approved",
                message: "Your evidence for 'Communication' has been approved.",
                icon: "checkmark.circle.fill",
                timestamp: now.addingTimeInterval(-120),
                isRead: false
            ),
            NotificationItem(
                title: "New Feedback",
                message: "You received feedback on your project from Facilitator.",
                icon: "message.fill",
                timestamp: now.addingTimeInterval(-3600),
                isRead: false
            ),
            NotificationItem(
                title: "Skill Demonstrated",
                message: "You've successfully demonstrated 'Teamwork'.",
                icon: "star.circle.fill",
                timestamp: now.addingTimeInterval(-7200),
                isRead: true
            ),
            NotificationItem(
                title: "Reminder: Weekly Check-in",
                message: "Don't forget to log your weekly progress.",
                icon: "calendar.badge.clock",
                timestamp: now.addingTimeInterval(-86400),
                isRead: true
            ),
        ]
    }
}

// MARK: - Notification Row

struct NotificationRow: View {
    @Binding var notification: NotificationItem

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.isRead ? Color.white.opacity(0.06) : Color.matterOrange.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: notification.icon)
                    .font(.title3)
                    .foregroundColor(notification.isRead ? .white.opacity(0.5) : .matterOrange)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(notification.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.4))
                }
                Text(notification.message)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }

            // Unread indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.matterOrange)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(notification.isRead ? Color.white.opacity(0.03) : Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(notification.isRead ? Color.clear : Color.matterOrange.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
