//
//  MainTabView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI
import SwiftData

/// Main app container with tab bar navigation
struct MainTabView: View {
    @State private var selectedTab: Tab = .itinerary

    enum Tab: String, CaseIterable {
        case itinerary = "Itinerary"
        case foodGuide = "Food Guide"
        case chat = "Chat"

        var icon: String {
            switch self {
            case .itinerary: return "calendar"
            case .foodGuide: return "fork.knife"
            case .chat: return "bubble.left.and.bubble.right"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DayListView()
                .tabItem {
                    Label(Tab.itinerary.rawValue, systemImage: Tab.itinerary.icon)
                }
                .tag(Tab.itinerary)

            FoodGuideView()
                .tabItem {
                    Label(Tab.foodGuide.rawValue, systemImage: Tab.foodGuide.icon)
                }
                .tag(Tab.foodGuide)

            ChatView()
                .tabItem {
                    Label(Tab.chat.rawValue, systemImage: Tab.chat.icon)
                }
                .tag(Tab.chat)
        }
        .tint(Color.wanderlustTeal)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: Day.self, inMemory: true)
}
