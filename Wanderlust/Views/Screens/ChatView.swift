//
//  ChatView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI
import SwiftData

/// Chat tab - AI assistant for modifying itinerary
struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Day.date) private var days: [Day]

    @State private var messageText: String = ""
    @State private var showSettings = false
    @State private var claudeService = ClaudeService()
    @State private var aiResponse: ClaudeModificationResponse?
    @State private var showProposal = false

    @AppStorage("claudeAPIKey") private var apiKey: String = ""

    var hasAPIKey: Bool { !apiKey.isEmpty }

    var body: some View {
        NavigationStack {
            VStack {
                if claudeService.isLoading {
                    loadingView
                } else if let response = aiResponse, showProposal {
                    proposalView(response: response)
                } else {
                    emptyStateView
                }

                Spacer()

                // Input area
                inputArea
            }
            .navigationTitle("Chat")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .alert("Error", isPresented: .constant(claudeService.lastError != nil)) {
                Button("OK") { claudeService.lastError = nil }
            } message: {
                Text(claudeService.lastError ?? "Unknown error")
            }
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)

            Text("Thinking...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.wanderlustTeal.opacity(0.5))

            Text("AI Assistant")
                .font(.title2)
                .fontWeight(.bold)

            Text("Ask me to modify your itinerary")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !hasAPIKey {
                Button(action: { showSettings = true }) {
                    Label("Add API Key", systemImage: "key.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.wanderlustTeal)
                .padding(.top, 8)
            }

            Spacer()
        }
        .padding()
    }

    private func proposalView(response: ClaudeModificationResponse) -> some View {
        VStack(spacing: 16) {
            Spacer()

            // Show AI reasoning
            VStack(alignment: .leading, spacing: 8) {
                Text("AI Suggestion")
                    .font(.headline)
                    .fontWeight(.bold)

                Text(response.reasoning)
                    .font(.body)

                if !response.warnings.isEmpty {
                    ForEach(response.warnings, id: \.self) { warning in
                        Label(warning, systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            // Action buttons
            HStack(spacing: 12) {
                Button(action: cancelProposal) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.bordered)

                Button(action: applyProposal) {
                    Text("Apply Changes")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.wanderlustTeal)
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    private var inputArea: some View {
        HStack(spacing: 12) {
            TextField("Ask AI...", text: $messageText)
                .textFieldStyle(.roundedBorder)
                .disabled(!hasAPIKey || claudeService.isLoading)

            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(hasAPIKey && !messageText.isEmpty ? Color.wanderlustTeal : Color.gray)
                    .clipShape(Circle())
            }
            .disabled(!hasAPIKey || messageText.isEmpty || claudeService.isLoading)
        }
        .padding()
        .background(.thinMaterial)
    }

    // MARK: - Actions

    private func sendMessage() {
        guard !messageText.isEmpty, hasAPIKey else { return }

        let request = messageText
        messageText = ""

        // Build itinerary DTO
        let itinerary = ItineraryDTO(days: days.map { DayDTO(from: $0) })

        Task {
            do {
                let response = try await claudeService.sendModificationRequest(
                    userRequest: request,
                    itinerary: itinerary,
                    apiKey: apiKey
                )
                aiResponse = response
                showProposal = true
            } catch {
                claudeService.lastError = error.localizedDescription
            }
        }
    }

    private func applyProposal() {
        guard let response = aiResponse else { return }

        // Apply modifications to SwiftData
        for modification in response.modifications {
            applyModification(modification)
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        cancelProposal()
    }

    private func cancelProposal() {
        aiResponse = nil
        showProposal = false
    }

    private func applyModification(_ modification: Modification) {
        // Find the activity by ID and apply changes
        guard let dayIndex = modification.dayIndex,
              dayIndex < days.count else { return }

        let day = days[dayIndex]

        switch modification.target {
        case .timedActivity:
            if let activity = day.timedActivities.first(where: { $0.id.uuidString == modification.activityId }) {
                if let time = modification.changes.time { activity.time = time }
                if let place = modification.changes.place { activity.place = place }
                if let what = modification.changes.what { activity.what = what }
                if let context = modification.changes.context { activity.context = context }
                if let priorityStr = modification.changes.priority,
                   let priority = ActivityPriority(rawValue: priorityStr) {
                    activity.priority = priority
                }
            }

        case .untimedActivity:
            if let activity = day.untimedActivities.first(where: { $0.id.uuidString == modification.activityId }) {
                if let place = modification.changes.place { activity.place = place }
                if let what = modification.changes.what { activity.what = what }
                if let context = modification.changes.context { activity.context = context }
                if let priorityStr = modification.changes.priority,
                   let priority = ActivityPriority(rawValue: priorityStr) {
                    activity.priority = priority
                }
            }

        case .subActivity:
            // Find sub-activity across all activities
            for timedActivity in day.timedActivities {
                if let sub = timedActivity.subActivities.first(where: { $0.id.uuidString == modification.activityId }) {
                    if let what = modification.changes.what { sub.what = what }
                    if let context = modification.changes.context { sub.context = context }
                    if let priorityStr = modification.changes.priority,
                       let priority = ActivityPriority(rawValue: priorityStr) {
                        sub.priority = priority
                    }
                }
            }
        }
    }
}


#Preview {
    ChatView()
}
