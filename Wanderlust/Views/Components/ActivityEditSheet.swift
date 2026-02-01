//
//  ActivityEditSheet.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Edit sheet for modifying timed activity properties
struct TimedActivityEditSheet: View {
    @Bindable var activity: TimedActivity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Time & Place") {
                    TextField("Time", text: $activity.time)
                    TextField("Place", text: $activity.place)
                }

                Section("Details") {
                    TextField("What to do", text: $activity.what)

                    VStack(alignment: .leading) {
                        Text("Notes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $activity.context)
                            .frame(minHeight: 100)
                    }
                }

                Section("Priority") {
                    Picker("Priority", selection: $activity.priority) {
                        ForEach(ActivityPriority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundStyle(priority.color)
                                Text(priority.displayName)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // SwiftData auto-saves on property change
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

/// Edit sheet for modifying untimed activity properties
struct UntimedActivityEditSheet: View {
    @Bindable var activity: UntimedActivity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Place") {
                    TextField("Place", text: $activity.place)
                }

                Section("Details") {
                    TextField("What to do", text: $activity.what)

                    VStack(alignment: .leading) {
                        Text("Notes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $activity.context)
                            .frame(minHeight: 100)
                    }
                }

                Section("Category") {
                    Picker("Category", selection: Binding(
                        get: { activity.category ?? "Tip" },
                        set: { activity.category = $0 }
                    )) {
                        Text("Food").tag("Food")
                        Text("Tip").tag("Tip")
                    }
                    .pickerStyle(.segmented)
                }

                Section("Priority") {
                    Picker("Priority", selection: $activity.priority) {
                        ForEach(ActivityPriority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundStyle(priority.color)
                                Text(priority.displayName)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Edit Tip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Text("Edit Sheet Preview")
}
