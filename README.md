# Wanderlust

A travel app I built with Claude Code in about 35 minutes. I'm a product marketer — not an engineer — using a workflow I put together with planning loops, adversarial review agents, and a lot of iteration. This is what came out.

## The Interesting Part

I tested the chat feature with two prompts on the same activity:

> "Move the Seine River Cruise to 9 AM."

The app responded:

> ⚠️ Warning — This conflicts with the Eiffel Tower visit at 9:00 AM. Consider rescheduling one of these activities.

Then:

> "Move the Seine River Cruise to 9 PM."

> ✓ Moving the Seine River Cruise to 9:00 PM. This works well — your evening is free after dinner.

Same activity. Different times. One warns, one confirms. I didn't write conflict detection. I didn't write confirmation logic. I didn't write rebooking suggestions.

## What's Actually In The Code

Here's everything I gave Claude about schedule modifications (`Wanderlust/Services/ClaudeService.swift`, lines 83-101):

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

No function that checks for conflicts. No logic that compares times. Just field names and an array called `warnings`.

## How It Works (I Think)

1. **The field names carry meaning.** `time` and `place` aren't random strings — Claude understands what they represent.

2. **The app sends the whole schedule, not just one activity.** Claude can see what else is happening that day.

3. **The `warnings` array is intentionally open-ended.** I just said "any concerns." Claude decided conflicts are a concern worth flagging.

The schema acts as a contract for *structure*, but the intelligence comes from the model reasoning about the data it's given. I designed the schema to leave room for that.

## Verifying There's No Hidden Logic

I grepped the codebase to make sure Claude Code didn't sneak in a conflict-checking function:

```bash
grep -ri "conflict|overlap|collision|clash" Wanderlust/
grep -ri "isBefore|isAfter|overlaps|intersects" Wanderlust/
grep -ri "time.*compare|time.*==|time.*<|time.*>" Wanderlust/
grep -ri "detect|check.*time|validate.*time" Wanderlust/
```

**Results:**
- "conflict" only appears in code comments about naming collisions
- No time comparison logic anywhere
- The only warning-related code is *displaying* warnings from the API — not generating them

The smoking gun is `ChatView.swift:228`:

```swift
if let time = modification.changes.time { activity.time = time }
```

No validation. No "check if something else is at this time." Just assigns the value. Clone the repo and verify for yourself.

## The Files That Matter

| File | What It Does |
|------|-------------|
| `Wanderlust/Services/ClaudeService.swift` | Talks to Claude. The prompt is lines 76-110. |
| `Wanderlust/Models/DTOs.swift` | The data structure Claude sees. |
| `Wanderlust/Views/Screens/ChatView.swift` | Where the warnings show up. |

## Running It

You'll need:
- Xcode 16+
- A Claude API key

Setup:
1. Clone this
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

## The Workflow

Here's how I built it:

1. Rambled about what I wanted. A note-taker agent cleaned it up.
2. Expert agents (product, design, engineering) turned it into a spec.
3. Lisa (planning agent) asked me questions. When I didn't understand, I said "make the Apple choice."
4. Bart (adversarial agent) tried to break things between every step.
5. Ralph loops until it worked.

Maybe the adversarial review forced cleaner schemas. Maybe the open-ended `warnings` array is doing more work than it looks. I'd love to hear what people think.

---

MIT Licensed.
