//
//  DayCard.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Glass card displaying a day's overview in the itinerary list
struct DayCard: View {
    let day: Day

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row: destination + date
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.destination)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(day.date.formatted(.dateTime.weekday(.wide).month().day()))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Must-do indicator if any must-do activities
                if day.hasMustDo {
                    PriorityBadge(priority: .mustDo)
                }
            }

            // Activity stats row
            HStack(spacing: 16) {
                Label("\(day.timedActivities.count) planned",
                      systemImage: "clock.fill")
                    .foregroundStyle(Color.wanderlustTeal)

                if !day.untimedActivities.isEmpty {
                    Label("\(day.untimedActivities.count) tips",
                          systemImage: "lightbulb.fill")
                        .foregroundStyle(Color.wanderlustCoral)
                }

                Spacer()
            }
            .font(.caption)
            .fontWeight(.semibold)
        }
        .padding(16)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}

#Preview {
    let previewDay = Day(date: Date(), destination: "Tokyo, Japan")

    return VStack(spacing: 16) {
        DayCard(day: previewDay)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
