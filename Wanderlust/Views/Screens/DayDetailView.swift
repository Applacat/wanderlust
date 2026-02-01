//
//  DayDetailView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Detail view showing all activities for a specific day
struct DayDetailView: View {
    let day: Day
    @State private var editingTimedActivity: TimedActivity?
    @State private var editingUntimedActivity: UntimedActivity?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Day header
                dayHeader

                // Timed activities section
                if !day.timedActivities.isEmpty {
                    timedActivitiesSection
                }

                // Untimed activities section (food, tips)
                if !day.untimedActivities.isEmpty {
                    untimedActivitiesSection
                }
            }
            .padding()
        }
        .navigationTitle(day.destination)
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $editingTimedActivity) { activity in
            TimedActivityEditSheet(activity: activity)
        }
        .sheet(item: $editingUntimedActivity) { activity in
            UntimedActivityEditSheet(activity: activity)
        }
    }

    // MARK: - Subviews

    private var dayHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Label("\(day.timedActivities.count) activities",
                      systemImage: "clock.fill")
                    .foregroundStyle(Color.wanderlustTeal)

                if !day.untimedActivities.isEmpty {
                    Label("\(day.untimedActivities.count) tips",
                          systemImage: "lightbulb.fill")
                        .foregroundStyle(Color.wanderlustCoral)
                }

                if day.hasMustDo {
                    Label("Must-do",
                          systemImage: "star.fill")
                        .foregroundStyle(Color.wanderlustGold)
                }
            }
            .font(.caption)
            .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// Sort activities by time string (e.g., "9:00 AM" < "2:00 PM")
    private var sortedTimedActivities: [TimedActivity] {
        day.timedActivities.sorted { a, b in
            parseTime(a.time) < parseTime(b.time)
        }
    }

    /// Convert time string to minutes since midnight for sorting
    private func parseTime(_ timeString: String) -> Int {
        let clean = timeString.uppercased().trimmingCharacters(in: .whitespaces)
        let isPM = clean.contains("PM")
        let isAM = clean.contains("AM")

        let numericPart = clean
            .replacingOccurrences(of: "AM", with: "")
            .replacingOccurrences(of: "PM", with: "")
            .trimmingCharacters(in: .whitespaces)

        let parts = numericPart.split(separator: ":").compactMap { Int($0) }
        guard let hour = parts.first else { return 0 }
        let minute = parts.count > 1 ? parts[1] : 0

        var hours24 = hour
        if isPM && hour != 12 { hours24 += 12 }
        if isAM && hour == 12 { hours24 = 0 }

        return hours24 * 60 + minute
    }

    private var timedActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 4)

            LazyVStack(spacing: 12) {
                ForEach(sortedTimedActivities) { activity in
                    NavigationLink(value: activity) {
                        ActivityRowCard(activity: activity) {
                            editingTimedActivity = activity
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationDestination(for: TimedActivity.self) { activity in
            ActivityDetailView(activity: activity)
        }
    }

    private var untimedActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tips & Recommendations")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 4)

            LazyVStack(spacing: 12) {
                ForEach(day.untimedActivities) { activity in
                    NavigationLink(value: activity) {
                        UntimedActivityRowCard(activity: activity) {
                            editingUntimedActivity = activity
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationDestination(for: UntimedActivity.self) { activity in
            UntimedActivityDetailView(activity: activity)
        }
    }
}


#Preview {
    NavigationStack {
        let day = Day(date: Date(), destination: "Tokyo, Japan")
        DayDetailView(day: day)
    }
}
