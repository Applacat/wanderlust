//
//  ContentView.swift
//  Wanderlust
//
//  Created by Jose Duarte on 1/23/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Day.self, inMemory: true)
}
