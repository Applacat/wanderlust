//
//  DataLoader.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation
import SwiftData

/// Loads trip data from JSON into SwiftData
@MainActor
final class DataLoader {

    // MARK: - Activity Type Inference

    /// Infers activity type from place name and description
    private static func inferActivityType(place: String, what: String) -> ActivityType {
        let combined = (place + " " + what).lowercased()

        // Transport keywords
        if combined.contains("airport") || combined.contains("flight") ||
           combined.contains("depart") || combined.contains("land in") {
            return .transport
        }

        // Train/station keywords
        if combined.contains("station") || combined.contains("train") ||
           combined.contains("eurostar") || combined.contains("thalys") ||
           combined.contains("centraal") || combined.contains("gare") {
            return .train
        }

        // Church/religious keywords
        if combined.contains("church") || combined.contains("cathedral") ||
           combined.contains("basilica") || combined.contains("abbey") ||
           combined.contains("temple") || combined.contains("shrine") {
            return .shrine
        }

        // Theme park keywords
        if combined.contains("disney") || combined.contains("universal") ||
           combined.contains("theme park") {
            return .themePark
        }

        // Museum/landmark keywords
        if combined.contains("museum") || combined.contains("gallery") ||
           combined.contains("exhibition") || combined.contains("tower") ||
           combined.contains("observation") || combined.contains("castle") ||
           combined.contains("palace") || combined.contains("louvre") ||
           combined.contains("rijksmuseum") || combined.contains("tate") ||
           combined.contains("british museum") {
            return .museum
        }

        // Hotel keywords
        if combined.contains("hotel") || combined.contains("check in") ||
           combined.contains("check-in") || combined.contains("hostel") {
            return .hotel
        }

        // Restaurant keywords
        if combined.contains("restaurant") || combined.contains("bistro") ||
           combined.contains("café") || combined.contains("cafe") ||
           combined.contains("dinner") || combined.contains("lunch") ||
           combined.contains("breakfast") || combined.contains("pub") ||
           combined.contains("bar") {
            return .restaurant
        }

        // Neighborhood/district keywords
        if combined.contains("district") || combined.contains("quarter") ||
           combined.contains("neighborhood") || combined.contains("walk") ||
           combined.contains("explore") || combined.contains("wander") ||
           combined.contains("marais") || combined.contains("jordaan") ||
           combined.contains("montmartre") || combined.contains("covent") {
            return .neighborhood
        }

        // Store/shopping keywords
        if combined.contains("shop") || combined.contains("store") ||
           combined.contains("mall") || combined.contains("market") ||
           combined.contains("bookstore") {
            return .store
        }

        return .general
    }

    /// Loads the trip data if the database is empty
    static func loadInitialDataIfNeeded(modelContext: ModelContext) {
        // Check if we already have data
        let descriptor = FetchDescriptor<Day>()
        let existingDays = (try? modelContext.fetch(descriptor)) ?? []

        guard existingDays.isEmpty else {
            #if DEBUG
            print("DataLoader: Data already exists, skipping load")
            #endif
            return
        }

        // Load from JSON
        guard let url = Bundle.main.url(forResource: "EuropeTrip", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            #if DEBUG
            print("DataLoader: Could not find EuropeTrip.json")
            #endif
            return
        }

        do {
            let tripData = try JSONDecoder().decode(TripJSON.self, from: data)

            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFullDate]

            for dayData in tripData.days {
                guard let date = dateFormatter.date(from: dayData.date) else {
                    #if DEBUG
                    print("DataLoader: Could not parse date \(dayData.date)")
                    #endif
                    continue
                }

                let day = Day(date: date, destination: dayData.destination)

                // Add timed activities
                for activityData in dayData.timedActivities {
                    let priority = ActivityPriority(rawValue: activityData.priority) ?? .flexible
                    let inferredType = inferActivityType(
                        place: activityData.place,
                        what: activityData.what
                    )

                    let activity = TimedActivity(
                        time: activityData.time,
                        place: activityData.place,
                        what: activityData.what,
                        context: activityData.context,
                        priority: priority,
                        activityType: inferredType
                    )

                    // Add sub-activities if any
                    for subData in activityData.subActivities ?? [] {
                        let subPriority = ActivityPriority(rawValue: subData.priority) ?? .flexible
                        let subActivity = SubActivity(
                            what: subData.what,
                            context: subData.context,
                            priority: subPriority,
                            place: subData.place
                        )
                        activity.subActivities.append(subActivity)
                    }

                    day.timedActivities.append(activity)
                }

                // Add untimed activities
                for activityData in dayData.untimedActivities {
                    let priority = ActivityPriority(rawValue: activityData.priority) ?? .flexible

                    let activity = UntimedActivity(
                        place: activityData.place,
                        what: activityData.what,
                        context: activityData.context,
                        priority: priority,
                        category: activityData.category
                    )

                    day.untimedActivities.append(activity)
                }

                modelContext.insert(day)
            }

            try modelContext.save()
            #if DEBUG
            print("DataLoader: Successfully loaded \(tripData.days.count) days")
            #endif

        } catch {
            #if DEBUG
            print("DataLoader: Error loading data - \(error)")
            #endif
        }
    }
}

// MARK: - JSON Decoding Types

private struct TripJSON: Codable {
    let tripName: String
    let travelers: [String]
    let days: [DayJSON]
}

private struct DayJSON: Codable {
    let date: String
    let destination: String
    let timedActivities: [TimedActivityJSON]
    let untimedActivities: [UntimedActivityJSON]
}

private struct TimedActivityJSON: Codable {
    let time: String
    let place: String
    let what: String
    let context: String
    let priority: String
    let subActivities: [SubActivityJSON]?
}

private struct UntimedActivityJSON: Codable {
    let place: String
    let what: String
    let context: String
    let priority: String
    let category: String?
}

private struct SubActivityJSON: Codable {
    let what: String
    let context: String
    let priority: String
    let place: String?
}
