//
//  SubActivity.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation
import SwiftData

/// Nested items within activities (e.g., Disney ride recommendations)
@Model
final class SubActivity {
    var id: UUID = UUID()
    var what: String
    var context: String
    var priority: ActivityPriority
    var place: String?

    var timedParent: TimedActivity?
    var untimedParent: UntimedActivity?

    init(
        what: String,
        context: String = "",
        priority: ActivityPriority = .flexible,
        place: String? = nil
    ) {
        self.what = what
        self.context = context
        self.priority = priority
        self.place = place
    }
}
