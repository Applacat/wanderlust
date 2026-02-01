# Wanderlust

A travel app I built with Claude Code. I'm a product marketer, not a developer. Something weird happened and I'm hoping someone can explain it.

## What Happened

I built this app using a janky workflow I put together — planning loops, adversarial review agents, the works. Took about 35 minutes from first prompt to running on my phone.

Then I tested the chat. I tried two prompts on the same activity:

> "Move the Seine River Cruise to 9 AM."

The app said:

> ⚠️ Warning — This conflicts with the Eiffel Tower visit at 9:00 AM. Consider rescheduling one of these activities.

Then I tried:

> "Move the Seine River Cruise to 9 PM."

The app said:

> ✓ Moving the Seine River Cruise to 9:00 PM. This works well — your evening is free after dinner.

Same activity. Different times. One warns, one confirms. I did not write conflict detection. I did not write "it's okay" confirmation. I did not write rebooking suggestions.

## What's Actually In The Code

I went looking. Here's everything I gave Claude about schedule modifications (`Wanderlust/Services/ClaudeService.swift`, lines 83-101):

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

That's it. No function that checks for conflicts. No logic that compares times. Just field names and an array called `warnings`.

## My Guess (Probably Wrong)

I think maybe:

1. The field names mean something? Like `time` and `place` aren't random strings — Claude knows what time means.

2. The app sends the whole schedule, not just one activity. So Claude can see what else is happening that day.

3. That `warnings` array doesn't define what a warning is. I just said "any concerns." Claude decided conflicts are concerning.

But I genuinely don't know. This might be obvious to anyone who's worked with LLMs. Or it might be a fluke that won't reproduce.

## Did I Accidentally Write Conflict Detection?

This was my biggest fear — that Claude wrote a conflict-checking function somewhere and I just didn't notice. So I had Claude Code grep the codebase for me. Here's what it searched:

```bash
# Looking for conflict-related logic
grep -ri "conflict|overlap|collision|clash" Wanderlust/
grep -ri "schedule|scheduling" Wanderlust/
grep -ri "isBefore|isAfter|overlaps|intersects" Wanderlust/

# Looking for time comparison
grep -ri "time.*compare|time.*==|time.*<|time.*>" Wanderlust/
grep -ri "detect|check.*time|validate.*time" Wanderlust/

# Looking at how warnings are handled
grep -ri "warning" Wanderlust/
```

**What it found:**
- "conflict" appears in code comments about naming collisions, not schedule conflicts
- No time comparison logic anywhere
- The only warning-related code is *displaying* warnings that come back from the API — not generating them

The smoking gun is `ChatView.swift:228`. When the app applies a time change, it just does:

```swift
if let time = modification.changes.time { activity.time = time }
```

No validation. No "check if something else is at this time." Just assigns the value.

If you want to verify this yourself, clone the repo and run those greps. I might have missed something.

## The Files That Matter

If you want to poke around:

| File | What I Think It Does |
|------|---------------------|
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

Once you have it running, go to the Chat tab and try these:

**The key test (Day 1 - Paris):**
- "Move the Seine River Cruise to 9 AM" → should warn (Eiffel Tower conflict)
- "Move the Seine River Cruise to 9 PM" → should confirm it's fine

Same activity, different outcomes. This is the behavior I can't explain.

**Other conflicts:**
- "Move the Louvre to 9 AM" (conflicts with Eiffel Tower)
- "Move the Van Gogh Museum to 9 AM" (Day 4 - conflicts with Rijksmuseum)

**Schedule changes:**
- "I'm tired, skip the canal cruise"
- "Make the Tower of London a must-do"
- "What if I want to sleep in on Day 2?"

**Try to break it:**
- "Move everything to 3 PM"
- "Delete all the museums"
- "Add a trip to the moon"

I'm curious what warnings it generates and whether it's consistent for you.

## What I Want To Know

- Is this real? Or am I seeing patterns that aren't there?
- Is this obvious to ML people and I'm just late to the party?
- What would break it?
- Has anyone else seen this happen?

I'm not claiming I discovered something. I'm claiming I don't understand what I'm looking at and would love help.

## The Workflow

For what it's worth, here's how I built it:

1. Rambled about what I wanted. A note-taker agent cleaned it up.
2. Expert agents (product, design, engineering) turned it into a spec.
3. Lisa (planning agent) asked me questions. When I didn't understand, I said "make the Apple choice."
4. Bart (adversarial agent) tried to break things between every step.
5. Ralph loops until it worked.

Maybe the adversarial review forced cleaner schemas? I don't know.

---

MIT license. Do whatever.

*— A marketer who's probably in over his head*
