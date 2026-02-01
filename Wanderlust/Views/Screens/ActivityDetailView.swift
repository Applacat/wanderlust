//
//  ActivityDetailView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Full detail view for a timed activity
struct ActivityDetailView: View {
    let activity: TimedActivity
    @State private var showEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with time and priority
                headerSection

                // What to do
                whatSection

                // Context/tips (markdown)
                if !activity.context.isEmpty {
                    contextSection
                }

                // Sub-activities
                if !activity.subActivities.isEmpty {
                    subActivitiesSection
                }
            }
            .padding()
        }
        .navigationTitle(activity.place)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showEditSheet = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            // Edit sheet will be implemented in US-2.1
            Text("Edit Sheet Placeholder")
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color.wanderlustTeal)
                    Text(activity.time)
                        .font(.title3)
                        .fontWeight(.bold)
                }

                Text(activity.place)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            PriorityBadge(priority: activity.priority)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var whatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What to do")
                .font(.headline)
                .fontWeight(.bold)

            Text(activity.what)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tips & Notes")
                .font(.headline)
                .fontWeight(.bold)

            // Basic markdown rendering
            Text(LocalizedStringKey(activity.context))
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var subActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 4)

            ForEach(activity.subActivities) { subActivity in
                SubActivityRow(subActivity: subActivity)
            }
        }
    }
}

/// Row displaying a sub-activity
struct SubActivityRow: View {
    let subActivity: SubActivity

    var body: some View {
        HStack(spacing: 12) {
            // Priority indicator
            Circle()
                .fill(subActivity.priority.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(subActivity.what)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if !subActivity.context.isEmpty {
                    Text(subActivity.context)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let place = subActivity.place {
                    Label(place, systemImage: "mappin")
                        .font(.caption2)
                        .foregroundStyle(Color.wanderlustTeal)
                }
            }

            Spacer()

            PriorityBadge(priority: subActivity.priority)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Untimed Activity Detail

/// Full detail view for an untimed activity (food, tips)
struct UntimedActivityDetailView: View {
    let activity: UntimedActivity
    @State private var showEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with category and priority
                headerSection

                // What
                whatSection

                // Context
                if !activity.context.isEmpty {
                    contextSection
                }

                // Sub-activities
                if !activity.subActivities.isEmpty {
                    subActivitiesSection
                }
            }
            .padding()
        }
        .navigationTitle(activity.place)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showEditSheet = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            Text("Edit Sheet Placeholder")
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: activity.category == "Food" ? "fork.knife" : "lightbulb.fill")
                        .foregroundStyle(activity.category == "Food" ? Color.wanderlustCoral : Color.wanderlustTeal)
                    Text(activity.category ?? "Tip")
                        .font(.title3)
                        .fontWeight(.bold)
                }

                Text(activity.place)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            PriorityBadge(priority: activity.priority)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var whatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommendation")
                .font(.headline)
                .fontWeight(.bold)

            Text(activity.what)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tips & Notes")
                .font(.headline)
                .fontWeight(.bold)

            Text(LocalizedStringKey(activity.context))
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var subActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 4)

            ForEach(activity.subActivities) { subActivity in
                SubActivityRow(subActivity: subActivity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text("Activity Detail Preview")
    }
}
