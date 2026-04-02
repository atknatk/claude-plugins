# Mobile Agents Plugin

Provides generic **iOS UI/UX Specialist** and **Android UI/UX Specialist** agents for mobile development quality gates.

## What It Provides

- **agents/ios-ui-specialist.md** — Reviews SwiftUI code against Apple Human Interface Guidelines, accessibility (VoiceOver, Dynamic Type), and iOS platform idioms.
- **agents/android-ui-specialist.md** — Reviews Jetpack Compose code against Material Design 3, accessibility (TalkBack, font scaling), and Android platform idioms.

## How It Works

Both agents read the project's `CLAUDE.md` first to pick up project-specific context: brand colors, tech stack, architecture conventions, and handoff path patterns.

This means the agents are generic and reusable across any mobile project. Project-specific details live in the project itself, not in these agents.

## Project Override Points

Projects customize behavior by including the following in their `CLAUDE.md`:

- **Brand palette** — Primary/secondary colors the agents check for consistency
- **Handoff path pattern** — Where agents write review summaries (e.g., `docs/pipeline/<name>-ios-ui.handoff.md`)
- **Architecture doc references** — Mobile architecture plans the agents should consult
- **Pipeline order** — Where these agents fit in the project's development pipeline
