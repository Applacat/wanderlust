//
//  Day.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation
import SwiftData

/// Container for a day's activities in the itinerary
@Model
final class Day {
    var id: UUID = UUID()
    var date: Date
    var destination: String

    @Relationship(deleteRule: .cascade, inverse: \TimedActivity.day)
    var timedActivities: [TimedActivity] = []

    @Relationship(deleteRule: .cascade, inverse: \UntimedActivity.day)
    var untimedActivities: [UntimedActivity] = []

    init(date: Date, destination: String) {
        self.date = date
        self.destination = destination
    }

    /// Returns true if this day has any must-do activities
    var hasMustDo: Bool {
        timedActivities.contains { $0.priority == .mustDo } ||
        untimedActivities.contains { $0.priority == .mustDo }
    }

    /// Total count of all activities for this day
    var activityCount: Int {
        timedActivities.count + untimedActivities.count
    }
}
