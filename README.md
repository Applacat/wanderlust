# Wanderlust

A SwiftUI travel app with a chat feature for modifying your itinerary. The app talks to Claude for schedule changes — and the interesting part is what Claude does without being told to.

## What Happens

> "Move the Seine River Cruise to 9 AM."

> ⚠️ This conflicts with the Eiffel Tower visit at 9:00 AM. Consider rescheduling one of these activities.

> "Move the Seine River Cruise to 9 PM."

> ✓ Moving the Seine River Cruise to 9:00 PM. This works well — your evening is free after dinner.

Conflict detection, confirmation logic, rebooking suggestions — none of that is in the code.

## What's In The Code

The modification schema (`Wanderlust/Services/ClaudeService.swift`, lines 83-101):

```json
{
  "type": "modify" | "add" | "delete",
  "changes": {
    "time": "<new time or null>",
    "place": "<new place or null>",
    "what": "<new description or null>",
    "priority": "mustDo" | "flexible" | "skip" | null
  },
  "warnings": ["<any concerns about the request>"]
}
```

The code that applies a time change (`ChatView.swift:228`):

```swift
if let time = modification.changes.time { activity.time = time }
```

No validation. No time comparison. Just assigns the value.

## Why It Works

1. **Self-describing field names.** `time` and `place` aren't random keys — the model understands what they represent.
2. **Full schedule as context.** The app sends the entire day's itinerary with each message, so the model can cross-reference.
3. **Open-ended warnings.** The `warnings` array says "any concerns about the request." It doesn't define what a concern is. The model decides.

The schema is a contract for structure. The intelligence comes from the model reasoning over the data it's given.

## Verify It

```bash
grep -ri "conflict|overlap|collision|clash" Wanderlust/
grep -ri "isBefore|isAfter|overlaps|intersects" Wanderlust/
grep -ri "detect|check.*time|validate.*time" Wanderlust/
```

"conflict" only appears in code comments about naming collisions. No time comparison logic anywhere. The only warning-related code is displaying warnings from the API — not generating them.

## Key Files

| File | What It Does |
|------|-------------|
| `Wanderlust/Services/ClaudeService.swift` | Claude API integration. Prompt at lines 76-110. |
| `Wanderlust/Models/DTOs.swift` | The data structures Claude sees. |
| `Wanderlust/Views/Screens/ChatView.swift` | Chat UI and modification handling. |

## Running It

- Xcode 16+
- A Claude API key

1. Clone this repo
2. Create `Wanderlust/Secrets.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLAUDE_API_KEY</key>
    <string>your-key-here</string>
</dict>
</plist>
```
3. Build and run

## Prompts To Try

Go to the Chat tab and try these:

**The key test (Day 1 - Paris):**
- "Move the Seine River Cruise to 9 AM" → should warn (Eiffel Tower conflict)
- "Move the Seine River Cruise to 9 PM" → should confirm it's fine

**Other conflicts:**
- "Move the Louvre to 9 AM" (conflicts with Eiffel Tower)
- "Move the Van Gogh Museum to 9 AM" (Day 4 - conflicts with Rijksmuseum)

**Schedule changes:**
- "I'm tired, skip the canal cruise"
- "Make the Tower of London a must-do"
- "What if I want to sleep in on Day 2?"

**Stress tests:**
- "Move everything to 3 PM"
- "Delete all the museums"
- "Add a trip to the moon"

---

MIT Licensed.
