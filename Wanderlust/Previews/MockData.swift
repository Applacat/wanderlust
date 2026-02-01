//
//  MockData.swift
//  Wanderlust
//
//  Mock data for SwiftUI previews
//

import Foundation
import SwiftUI

// MARK: - Preview Color Extensions

extension Color {
    // Preview-only hex initializer (avoids conflict with main app)
    init(previewHex hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Companion color palette
    static let companionCoral = Color(previewHex: "E8937D")
    static let companionOcean = Color(previewHex: "4A7D94")
    static let companionSand = Color(previewHex: "E8CEB0")
    static let companionSunset = Color(previewHex: "F4A261")
    static let companionDusk = Color(previewHex: "2A3D45")
}

// MARK: - Companion Metadata (New Fields for Rich Experience)

/// Rich metadata that makes an activity come alive
struct CompanionMetadata {
    let emotionalTagline: String       // "Like stepping inside Miyazaki's mind"
    let urgentNote: String?            // "Late = denied entry"
    let dontMiss: [String]             // The 3 things you can't skip
    let practicalTips: [String]        // Insider knowledge
    let imageURL: String?              // Curated image (not generic)
    let estimatedDuration: TimeInterval // How long you'll be here
    let travelTimeFromPrevious: Int?   // Minutes to get here
}

// MARK: - Mock Activities with Rich Data

struct MockActivity: Identifiable, Equatable {
    let id = UUID()
    let time: String
    let place: String
    let what: String
    let context: String
    let priority: ActivityPriority
    let companion: CompanionMetadata

    // Computed: Is this activity urgent right now?
    var isUrgent: Bool {
        companion.urgentNote != nil
    }

    static func == (lhs: MockActivity, rhs: MockActivity) -> Bool {
        lhs.id == rhs.id
    }
}

struct MockDay: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let destination: String
    let activities: [MockActivity]
    let dayNumber: Int
    let totalDays: Int

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    static func == (lhs: MockDay, rhs: MockDay) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Japan Trip Mock Data

enum JapanTrip {

    // MARK: Day 1 - Tokyo Arrival
    static let day1 = MockDay(
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        destination: "Tokyo",
        activities: [
            MockActivity(
                time: "3:00 PM",
                place: "Shinjuku Station",
                what: "Arrive & check into hotel",
                context: "Drop bags, grab Suica card",
                priority: .mustDo,
                companion: CompanionMetadata(
                    emotionalTagline: "Your Japan adventure begins",
                    urgentNote: nil,
                    dontMiss: ["Get Suica card from machine (English available)", "Grab a konbini onigiri - your first taste"],
                    practicalTips: ["Hotel check-in usually 3pm", "Coin lockers at station if early"],
                    imageURL: nil,
                    estimatedDuration: 60 * 60,
                    travelTimeFromPrevious: nil
                )
            ),
            MockActivity(
                time: "6:00 PM",
                place: "Omoide Yokocho",
                what: "Dinner in Piss Alley",
                context: "Yakitori and atmosphere",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Tiny bars, big memories",
                    urgentNote: nil,
                    dontMiss: ["Yakitori at any stall with smoke", "The vibe after dark"],
                    practicalTips: ["Cash only everywhere", "Most stalls seat 6-8 max", "Point and nod works fine"],
                    imageURL: nil,
                    estimatedDuration: 90 * 60,
                    travelTimeFromPrevious: 15
                )
            )
        ],
        dayNumber: 1,
        totalDays: 7
    )

    // MARK: Day 2 - Ghibli Day (TODAY in preview) — Full day with 9 activities
    static let day2 = MockDay(
        date: Date(),
        destination: "Mitaka & Kichijoji",
        activities: [
            MockActivity(
                time: "7:30 AM",
                place: "Hotel Lobby",
                what: "Early checkout & store luggage",
                context: "Beat the morning rush",
                priority: .mustDo,
                companion: CompanionMetadata(
                    emotionalTagline: "Adventure awaits",
                    urgentNote: nil,
                    dontMiss: ["Grab a konbini breakfast"],
                    practicalTips: ["Coin lockers at Shinjuku if hotel won't hold bags"],
                    imageURL: nil,
                    estimatedDuration: 30 * 60,
                    travelTimeFromPrevious: nil
                )
            ),
            MockActivity(
                time: "8:30 AM",
                place: "Shinjuku Station",
                what: "Train to Kichijoji",
                context: "JR Chuo Line - 20 min",
                priority: .mustDo,
                companion: CompanionMetadata(
                    emotionalTagline: "The commute becomes the journey",
                    urgentNote: nil,
                    dontMiss: ["Watch the city turn to suburbs"],
                    practicalTips: ["Tap Suica, no ticket needed"],
                    imageURL: nil,
                    estimatedDuration: 25 * 60,
                    travelTimeFromPrevious: 10
                )
            ),
            MockActivity(
                time: "9:00 AM",
                place: "Light Up Coffee",
                what: "Third wave coffee & people watching",
                context: "Fuel up before the museum",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Tokyo's best pour-over",
                    urgentNote: nil,
                    dontMiss: ["The single origin Ethiopian"],
                    practicalTips: ["Small space, might wait for seats"],
                    imageURL: nil,
                    estimatedDuration: 45 * 60,
                    travelTimeFromPrevious: 5
                )
            ),
            MockActivity(
                time: "10:00 AM",
                place: "Kichijoji",
                what: "Explore the neighborhood",
                context: "Cute shops, good vibes",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Tokyo's coziest neighborhood",
                    urgentNote: nil,
                    dontMiss: ["Satou menchi katsu (croquette) - cash only, line worth it"],
                    practicalTips: ["Walk through Sun Road arcade"],
                    imageURL: nil,
                    estimatedDuration: 90 * 60,
                    travelTimeFromPrevious: 5
                )
            ),
            MockActivity(
                time: "12:00 PM",
                place: "Inokashira Park",
                what: "Walk through the park to Ghibli",
                context: "The pilgrimage begins",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "The path Miyazaki walks every day",
                    urgentNote: nil,
                    dontMiss: ["Shrine in the middle of the lake", "Swan boats if you have time"],
                    practicalTips: ["15 min walk to museum", "Good bathrooms near the cafe"],
                    imageURL: nil,
                    estimatedDuration: 45 * 60,
                    travelTimeFromPrevious: 5
                )
            ),
            MockActivity(
                time: "2:00 PM",
                place: "Ghibli Museum",
                what: "Explore Miyazaki's world",
                context: "Timed entry - DON'T BE LATE",
                priority: .mustDo,
                companion: CompanionMetadata(
                    emotionalTagline: "Like stepping inside Miyazaki's mind",
                    urgentNote: "Late = denied entry. No exceptions. Leave by 1:45.",
                    dontMiss: [
                        "Rooftop robot soldier - you can touch it",
                        "Short film (only shows HERE, nowhere else)",
                        "Catbus room - adults allowed if no kids waiting"
                    ],
                    practicalTips: [
                        "Show PRINTED tickets at gate",
                        "No photos inside (yes, really)",
                        "Cafe has 30-min waits - skip or commit",
                        "Gift shop is worth it - exclusive items"
                    ],
                    imageURL: nil,
                    estimatedDuration: 3 * 60 * 60,
                    travelTimeFromPrevious: 15
                )
            ),
            MockActivity(
                time: "5:00 PM",
                place: "Mitaka Station",
                what: "Train to Shibuya",
                context: "JR Chuo → Yamanote",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Back to the neon",
                    urgentNote: nil,
                    dontMiss: ["Transfer at Shinjuku - follow signs"],
                    practicalTips: ["35 min total with transfer"],
                    imageURL: nil,
                    estimatedDuration: 40 * 60,
                    travelTimeFromPrevious: 10
                )
            ),
            MockActivity(
                time: "6:00 PM",
                place: "Shibuya Crossing",
                what: "The famous scramble at dusk",
                context: "1,000 people. Zero collisions.",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Organized chaos, Tokyo style",
                    urgentNote: nil,
                    dontMiss: ["Cross it at least twice", "Starbucks 2F for the view"],
                    practicalTips: ["Best at dusk when lights come on", "Hachiko statue is tiny"],
                    imageURL: nil,
                    estimatedDuration: 30 * 60,
                    travelTimeFromPrevious: 5
                )
            ),
            MockActivity(
                time: "7:30 PM",
                place: "Ichiran Ramen",
                what: "Solo ramen booth experience",
                context: "The famous individual booths",
                priority: .flexible,
                companion: CompanionMetadata(
                    emotionalTagline: "Ramen as meditation",
                    urgentNote: nil,
                    dontMiss: ["Customize EVERYTHING on the form", "Extra noodles (kaedama)"],
                    practicalTips: ["Order at machine first, then seat"],
                    imageURL: nil,
                    estimatedDuration: 45 * 60,
                    travelTimeFromPrevious: 10
                )
            ),
            MockActivity(
                time: "9:00 PM",
                place: "Shibuya Night Walk",
                what: "Explore the backstreets",
                context: "Neon, izakayas, nightlife",
                priority: .skip,
                companion: CompanionMetadata(
                    emotionalTagline: "When Tokyo really comes alive",
                    urgentNote: nil,
                    dontMiss: ["Nonbei Yokocho (Drunkard's Alley)", "Don Quijote for souvenirs"],
                    practicalTips: ["Safe to wander, trains until midnight"],
                    imageURL: nil,
                    estimatedDuration: 90 * 60,
                    travelTimeFromPrevious: 5
                )
            )
        ],
        dayNumber: 2,
        totalDays: 7
    )

    // MARK: Day 3 - DisneySea
    static let day3 = MockDay(
        date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        destination: "Tokyo DisneySea",
        activities: [
            MockActivity(
                time: "7:30 AM",
                place: "Tokyo DisneySea",
                what: "Rope drop - BE EARLY",
                context: "Gates open 8am but line forms by 7",
                priority: .mustDo,
                companion: CompanionMetadata(
                    emotionalTagline: "The most beautiful Disney park on Earth",
                    urgentNote: "Arrive 7:30 or earlier. Line builds FAST.",
                    dontMiss: [
                        "Journey to the Center of the Earth (rope drop this)",
                        "Fantasy Springs - new area, go early",
                        "Tower of Terror - different story than US version"
                    ],
                    practicalTips: [
                        "Download TDR app for wait times",
                        "Mobile order food to skip lines",
                        "Bring portable charger - app drains battery"
                    ],
                    imageURL: nil,
                    estimatedDuration: 12 * 60 * 60,
                    travelTimeFromPrevious: 45
                )
            )
        ],
        dayNumber: 3,
        totalDays: 7
    )

    // MARK: All Days
    static let allDays: [MockDay] = [day1, day2, day3]

    // MARK: Current Activity (for NOW view)
    static var currentActivity: MockActivity {
        // Simulate it being 1:45 PM - time to head to Ghibli
        day2.activities[2] // Ghibli Museum
    }

    static var nextActivity: MockActivity {
        day2.activities[3] // Shibuya
    }
}

// MARK: - Time Helpers for Preview

extension MockActivity {
    /// Simulated "minutes away" for preview
    var minutesAway: Int {
        companion.travelTimeFromPrevious ?? 15
    }

    /// Simulated "leave by" time
    var leaveByTime: String {
        guard companion.urgentNote != nil else { return "" }
        // In real app, this would be computed from current time + travel time
        return "1:45 PM"
    }
}

