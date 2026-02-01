//
//  ActivityPriority.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation

/// Priority levels for activities in the itinerary
enum ActivityPriority: String, Codable, CaseIterable {
    case mustDo = "mustDo"
    case flexible = "flexible"
    case skip = "skip"

    var displayName: String {
        switch self {
        case .mustDo: return "Must-Do"
        case .flexible: return "Flexible"
        case .skip: return "Skip"
        }
    }

    var icon: String {
        switch self {
        case .mustDo: return "star.fill"
        case .flexible: return "arrow.left.arrow.right"
        case .skip: return "xmark"
        }
    }
}
