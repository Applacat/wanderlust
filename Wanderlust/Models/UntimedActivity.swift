//
//  UntimedActivity.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation
import SwiftData

/// Food/general recommendations without a specific time
@Model
final class UntimedActivity {
    var id: UUID = UUID()
    var place: String
    var what: String
    var context: String
    var priority: ActivityPriority
    var category: String?         // "Food", "Tip"

    // MARK: - Companion Metadata (Content-First Experience)

    /// The emotional hook
    var emotionalTagline: String = ""

    /// Time-sensitive warning
    var urgentNote: String?

    /// The highlights
    var dontMiss: [String] = []

    /// Practical tips
    var practicalTips: [String] = []

    /// Activity type for contextual actions and visuals
    var activityTypeRaw: String = ActivityType.general.rawValue

    var activityType: ActivityType {
        get { ActivityType(rawValue: activityTypeRaw) ?? .general }
        set { activityTypeRaw = newValue.rawValue }
    }

    @Relationship(deleteRule: .cascade, inverse: \SubActivity.untimedParent)
    var subActivities: [SubActivity] = []

    var day: Day?

    init(
        place: String,
        what: String,
        context: String = "",
        priority: ActivityPriority = .flexible,
        category: String? = nil,
        emotionalTagline: String = "",
        urgentNote: String? = nil,
        dontMiss: [String] = [],
        practicalTips: [String] = [],
        activityType: ActivityType = .general
    ) {
        self.place = place
        self.what = what
        self.context = context
        self.priority = priority
        self.category = category
        self.emotionalTagline = emotionalTagline
        self.urgentNote = urgentNote
        self.dontMiss = dontMiss
        self.practicalTips = practicalTips
        self.activityTypeRaw = activityType.rawValue
    }
}
