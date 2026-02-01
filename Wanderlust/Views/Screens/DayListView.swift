//
//  DayListView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI
import SwiftData

/// Main itinerary view showing all days as scrolling cards
struct DayListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Day.date) private var days: [Day]

    var body: some View {
        NavigationStack {
            Group {
                if days.isEmpty {
                    emptyState
                } else {
                    daysList
                }
            }
            .navigationTitle("Itinerary")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addSampleData) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        ContentUnavailableView(
            "No Days Planned",
            systemImage: "calendar.badge.plus",
            description: Text("Your adventure awaits!")
        )
    }

    private var daysList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(days) { day in
                    NavigationLink(value: day) {
                        DayCard(day: day)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .navigationDestination(for: Day.self) { day in
            DayDetailView(day: day)
        }
    }

    // MARK: - Actions

    private func addSampleData() {
        withAnimation {
            // Sample Day 1: Tokyo
            let day1 = Day(date: Date(), destination: "Tokyo, Japan")

            let activity1 = TimedActivity(
                time: "9:00 AM",
                place: "Nintendo Museum",
                what: "Explore gaming history and interactive exhibits",
                context: "**Tip:** Book tickets online in advance. Allow 3-4 hours.",
                priority: .mustDo
            )

            let activity2 = TimedActivity(
                time: "2:00 PM",
                place: "Shibuya Crossing",
                what: "Experience the world's busiest intersection",
                context: "Best photos from Starbucks 2nd floor",
                priority: .flexible
            )

            day1.timedActivities.append(activity1)
            day1.timedActivities.append(activity2)

            let foodTip = UntimedActivity(
                place: "Ichiran Ramen",
                what: "Famous solo-dining tonkotsu ramen",
                context: "Order extra noodles (kaedama) for ¥190",
                priority: .mustDo,
                category: "Food"
            )
            day1.untimedActivities.append(foodTip)

            modelContext.insert(day1)

            // Sample Day 2: Disney
            let day2 = Day(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                destination: "Tokyo DisneySea"
            )

            let disneyActivity = TimedActivity(
                time: "8:00 AM",
                place: "Fantasy Springs",
                what: "Sprint to new area at rope drop",
                context: "**Priority rides:** Anna & Elsa, Peter Pan, Rapunzel",
                priority: .mustDo
            )

            let subActivity1 = SubActivity(
                what: "Anna & Elsa's Frozen Journey",
                context: "Use DPA if available",
                priority: .mustDo
            )
            let subActivity2 = SubActivity(
                what: "Peter Pan's Never Land Adventure",
                context: "Longest wait times, go first",
                priority: .mustDo
            )

            disneyActivity.subActivities.append(subActivity1)
            disneyActivity.subActivities.append(subActivity2)
            day2.timedActivities.append(disneyActivity)

            modelContext.insert(day2)
        }
    }
}


#Preview {
    DayListView()
        .modelContainer(for: Day.self, inMemory: true)
}
