//
//  README.swift
//  Wanderlust Previews
//
//  HOW TO USE THIS PLAYGROUND
//  ==========================
//
//  1. SETUP
//     - In Xcode, right-click on the Wanderlust folder in Project Navigator
//     - Select "Add Files to Wanderlust..."
//     - Navigate to Wanderlust/Previews and add the entire folder
//     - Make sure "Create groups" is selected
//     - Make sure the Wanderlust target is checked
//
//  2. THE INTERACTION MODEL
//
//     VERTICAL AXIS = TIME
//     - Scroll up/down through your trip timeline
//     - Date scrubber on right edge (like Contacts alphabet)
//     - Touch and drag to quick-jump to any date
//
//     HORIZONTAL AXIS = DEPTH
//     - Each activity card has three faces
//     - Swipe left/right: Boring ← Hero → Fun
//     - Dot indicators show current face
//
//  3. EXPLORE THE PROTOTYPES
//
//     TimelinePrototype.swift
//     - Vertical scroll of magazine cards
//     - Date scrubber on right edge
//     - Floating chat button
//     → Try: Drag on the date scrubber to quick-jump
//
//     MagazineCardPrototype.swift
//     - The activity card with three horizontal faces
//     - Hero (landing) | Fun (soul) | Boring (logistics)
//     → Try: Swipe left/right on a card to see all faces
//
//     NowCardPrototype.swift (legacy)
//     - Earlier iteration of companion card
//     - Kept for reference
//
//     TimeTravelPrototype.swift (legacy)
//     - Magazine rack concept (horizontal days)
//     - Superseded by vertical timeline
//     - Kept for reference
//
//  4. THE THREE FACES OF A CARD
//
//     ┌─────────────────┐
//     │    BORING       │  ← Swipe left from Hero
//     │   (Logistics)   │
//     │                 │
//     │  📍 Address     │
//     │  🕐 Times       │
//     │  🎫 Tickets     │
//     └─────────────────┘
//
//     ┌─────────────────┐
//     │     HERO        │  ← Default landing
//     │   (Magazine)    │
//     │                 │
//     │  [BIG IMAGE]    │
//     │  Place Name     │
//     │  Tagline        │
//     └─────────────────┘
//
//     ┌─────────────────┐
//     │      FUN        │  ← Swipe right from Hero
//     │    (Soul)       │
//     │                 │
//     │  Editorial      │
//     │  Don't Miss     │
//     │  Tips           │
//     └─────────────────┘
//
//  5. WHAT TO EXPERIMENT WITH
//
//     Timeline:
//     - Does the scrubber feel like Contacts app?
//     - Is the vertical scroll natural for a trip timeline?
//     - Where should the chat button live?
//
//     Magazine Card:
//     - Do the three faces feel balanced?
//     - Is Hero the right landing page?
//     - Does swiping for depth feel natural?
//     - Are the dot indicators obvious enough?
//
//  6. NEXT STEPS
//
//     Once you're happy with an interaction model:
//     - Take it to Lisa (/lisa:plan) to formalize
//     - The prototype components can be adapted for production
//     - Mock data structure shows what fields we need
//
//  FILES IN THIS PLAYGROUND:
//  -------------------------
//  MockData.swift                 - Rich Japan trip data with companion metadata
//  Prototypes/
//    TimelinePrototype.swift      - Vertical timeline + date scrubber + chat FAB
//    MagazineCardPrototype.swift  - Activity card with Hero | Fun | Boring faces
//    NowCardPrototype.swift       - (Legacy) Companion card exploration
//    TimeTravelPrototype.swift    - (Legacy) Horizontal magazine rack
//

import SwiftUI

// This file exists just to provide documentation.
// The actual prototypes are in the Prototypes/ subfolder.

enum PreviewsREADME {
    static let version = "2.0"
    static let interactionModel = """
        Vertical = Time (scroll/scrub)
        Horizontal = Depth (swipe card faces)
        """
    static let cardFaces = ["Boring (logistics)", "Hero (magazine)", "Fun (soul)"]
}
