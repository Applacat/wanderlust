//
//  PriorityBadge.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Visual badge indicating activity priority level
struct PriorityBadge: View {
    let priority: ActivityPriority

    var body: some View {
        Image(systemName: priority.icon)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(priority.color)
            .padding(6)
            .background(priority.color.opacity(0.15))
            .clipShape(Circle())
    }
}

#Preview {
    HStack(spacing: 16) {
        PriorityBadge(priority: .mustDo)
        PriorityBadge(priority: .flexible)
        PriorityBadge(priority: .skip)
    }
    .padding()
}
