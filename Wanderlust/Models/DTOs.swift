//
//  DTOs.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//
//  Data Transfer Objects for JSON serialization with Claude API

import Foundation

// MARK: - Itinerary DTOs (for sending to Claude)

struct ItineraryDTO: Codable {
    let days: [DayDTO]
}

struct DayDTO: Codable {
    let id: String
    let date: String
    let destination: String
    let timedActivities: [TimedActivityDTO]
    let untimedActivities: [UntimedActivityDTO]

    init(from day: Day) {
        self.id = day.id.uuidString
        self.date = ISO8601DateFormatter().string(from: day.date)
        self.destination = day.destination
        self.timedActivities = day.timedActivities.map { TimedActivityDTO(from: $0) }
        self.untimedActivities = day.untimedActivities.map { UntimedActivityDTO(from: $0) }
    }
}

struct TimedActivityDTO: Codable {
    let id: String
    let time: String
    let place: String
    let what: String
    let context: String
    let priority: String
    let subActivities: [SubActivityDTO]

    init(from activity: TimedActivity) {
        self.id = activity.id.uuidString
        self.time = activity.time
        self.place = activity.place
        self.what = activity.what
        self.context = activity.context
        self.priority = activity.priority.rawValue
        self.subActivities = activity.subActivities.map { SubActivityDTO(from: $0) }
    }
}

struct UntimedActivityDTO: Codable {
    let id: String
    let place: String
    let what: String
    let context: String
    let priority: String
    let category: String?
    let subActivities: [SubActivityDTO]

    init(from activity: UntimedActivity) {
        self.id = activity.id.uuidString
        self.place = activity.place
        self.what = activity.what
        self.context = activity.context
        self.priority = activity.priority.rawValue
        self.category = activity.category
        self.subActivities = activity.subActivities.map { SubActivityDTO(from: $0) }
    }
}

struct SubActivityDTO: Codable {
    let id: String
    let what: String
    let context: String
    let priority: String
    let place: String?

    init(from subActivity: SubActivity) {
        self.id = subActivity.id.uuidString
        self.what = subActivity.what
        self.context = subActivity.context
        self.priority = subActivity.priority.rawValue
        self.place = subActivity.place
    }
}

// MARK: - Claude API Response DTOs

struct ClaudeModificationResponse: Codable {
    let modifications: [Modification]
    let reasoning: String
    let warnings: [String]
}

struct Modification: Codable {
    let type: ModificationType
    let target: TargetType
    let dayIndex: Int?
    let activityId: String
    let changes: ActivityChanges
}

enum ModificationType: String, Codable {
    case modify
    case add
    case delete
}

enum TargetType: String, Codable {
    case timedActivity
    case untimedActivity
    case subActivity
}

struct ActivityChanges: Codable {
    let time: String?
    let place: String?
    let what: String?
    let context: String?
    let priority: String?
}

// MARK: - AI Proposal (for UI display)

struct AIProposal {
    var time: String
    var place: String
    var what: String
    var context: String
    var priority: ActivityPriority

    enum ProposalField {
        case time, place, what, context, priority
    }
}
