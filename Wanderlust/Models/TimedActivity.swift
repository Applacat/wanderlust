//
//  TimedActivity.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation
import SwiftData

/// Activity with a specific time (main itinerary items)
@Model
final class TimedActivity {
    var id: UUID = UUID()
    var time: String              // "9:00 AM", "Morning"
    var place: String             // "Nintendo Museum"
    var what: String              // "Sprint to Fantasy Springs"
    var context: String           // Markdown tips/notes
    var priority: ActivityPriority

    // MARK: - Companion Metadata (Content-First Experience)

    /// The emotional hook - "Like stepping inside Miyazaki's mind"
    var emotionalTagline: String = ""

    /// Time-sensitive warning - "Late = denied entry. No exceptions."
    var urgentNote: String?

    /// The highlights that make this worth doing
    var dontMiss: [String] = []

    /// Practical logistics tips
    var practicalTips: [String] = []

    /// Activity type for contextual actions and visuals
    var activityTypeRaw: String = ActivityType.general.rawValue

    var activityType: ActivityType {
        get { ActivityType(rawValue: activityTypeRaw) ?? .general }
        set { activityTypeRaw = newValue.rawValue }
    }

    @Relationship(deleteRule: .cascade, inverse: \SubActivity.timedParent)
    var subActivities: [SubActivity] = []

    var day: Day?

    init(
        time: String,
        place: String,
        what: String,
        context: String = "",
        priority: ActivityPriority = .flexible,
        emotionalTagline: String = "",
        urgentNote: String? = nil,
        dontMiss: [String] = [],
        practicalTips: [String] = [],
        activityType: ActivityType = .general
    ) {
        self.time = time
        self.place = place
        self.what = what
        self.context = context
        self.priority = priority
        self.emotionalTagline = emotionalTagline
        self.urgentNote = urgentNote
        self.dontMiss = dontMiss
        self.practicalTips = practicalTips
        self.activityTypeRaw = activityType.rawValue
    }
}
