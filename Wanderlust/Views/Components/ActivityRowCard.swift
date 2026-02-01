//
//  ActivityRowCard.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Row card displaying a timed activity's overview
struct ActivityRowCard: View {
    let activity: TimedActivity
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            // Time column (visual anchor)
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.time)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.wanderlustTeal)
            }
            .frame(width: 70, alignment: .leading)

            // Main content
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.place)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(activity.what)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            // Priority badge
            PriorityBadge(priority: activity.priority)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
        .onLongPressGesture {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onLongPress?()
        }
    }
}

/// Row card for untimed activities (food, tips)
struct UntimedActivityRowCard: View {
    let activity: UntimedActivity
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            VStack {
                Image(systemName: activity.category == "Food" ? "fork.knife" : "lightbulb.fill")
                    .font(.title3)
                    .foregroundStyle(activity.category == "Food" ? Color.wanderlustCoral : Color.wanderlustTeal)
            }
            .frame(width: 40)

            // Main content
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.place)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(activity.what)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            // Priority badge
            PriorityBadge(priority: activity.priority)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
        .onLongPressGesture {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onLongPress?()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Preview would need actual data
        Text("Activity Row Preview")
    }
    .padding()
}
