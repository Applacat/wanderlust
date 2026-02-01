//
//  FoodGuideView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI
import SwiftData

/// Food Guide tab - displays untimed activities with category "Food"
struct FoodGuideView: View {
    @Query(filter: #Predicate<UntimedActivity> { $0.category == "Food" })
    private var foodActivities: [UntimedActivity]

    var body: some View {
        NavigationStack {
            Group {
                if foodActivities.isEmpty {
                    emptyState
                } else {
                    foodList
                }
            }
            .navigationTitle("Food Guide")
        }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        ContentUnavailableView(
            "No Food Recommendations",
            systemImage: "fork.knife",
            description: Text("Food tips will appear here as you add them.")
        )
    }

    private var foodList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(foodActivities) { activity in
                    NavigationLink(value: activity) {
                        UntimedActivityRowCard(activity: activity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationDestination(for: UntimedActivity.self) { activity in
            UntimedActivityDetailView(activity: activity)
        }
    }
}

#Preview {
    FoodGuideView()
        .modelContainer(for: UntimedActivity.self, inMemory: true)
}
