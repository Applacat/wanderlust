//
//  ActivityType.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Activity type for contextual quick actions and gradient backgrounds
enum ActivityType: String, Codable, CaseIterable {
    case museum
    case restaurant
    case hotel
    case themePark
    case neighborhood
    case transport
    case train
    case store
    case shrine
    case general

    // MARK: - Quick Actions

    /// Contextual action button based on activity type
    var quickAction: (icon: String, label: String, urlScheme: String)? {
        switch self {
        case .hotel:
            return ("phone.fill", "Call", "tel:")
        case .restaurant:
            return ("map.fill", "Maps", "maps:")
        case .themePark:
            return ("list.bullet.rectangle", "Rides", "https://")
        case .museum:
            return ("ticket.fill", "Tickets", "https://")
        case .transport, .train:
            return ("clock.fill", "Schedule", "https://")
        case .store:
            return ("globe", "Website", "https://")
        case .shrine:
            return ("map.fill", "Maps", "maps:")
        case .neighborhood:
            return ("map.fill", "Explore", "maps:")
        case .general:
            return nil
        }
    }

    // MARK: - Hero Image

    /// Whether this activity type should fetch a hero image from Unsplash
    var needsHeroImage: Bool {
        // All activity types get hero images - every place deserves a photo
        return true
    }

    // MARK: - Gradient Colors

    /// Background gradient colors for content-first cards
    var gradientColors: [Color] {
        switch self {
        case .museum:
            return [Color(hex: "2D5A27"), Color(hex: "1A3A18")] // Forest green
        case .themePark:
            return [Color(hex: "1E3A8A"), Color(hex: "3B82F6")] // Disney blue
        case .restaurant:
            return [Color(hex: "DC2626"), Color(hex: "7F1D1D")] // Warm red
        case .hotel:
            return [Color(hex: "4A7D94"), Color(hex: "2A3D45")] // Ocean dusk
        case .neighborhood:
            return [Color(hex: "F59E0B"), Color(hex: "D97706")] // Amber
        case .train, .transport:
            return [Color(hex: "0EA5E9"), Color(hex: "0369A1")] // Sky blue
        case .store:
            return [Color(hex: "8B5CF6"), Color(hex: "6D28D9")] // Purple
        case .shrine:
            return [Color(hex: "EF4444"), Color(hex: "B91C1C")] // Torii red
        case .general:
            return [Color(hex: "E8937D"), Color(hex: "C75B39")] // Coral sunset
        }
    }
}
