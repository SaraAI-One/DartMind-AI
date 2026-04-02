# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DartMind AI is an iOS app for darts players that provides training analytics, AI coaching, and competition tracking. The app uses a layered architecture with a smart scoreboard UI, player data platform, and AI tactical engine.

## Build & Development Commands

```bash
# Build the project
swift build

# Run the app (requires Xcode)
xcode-build-and-run

# Clean build artifacts
swift build --clean
```

## Architecture

The codebase is organized into four main layers:

**Views** (`Sources/Views/`)
- `App.swift` - Entry point and app lifecycle
- `MainTabView.swift` - Tab navigation (Scoreboard, Profile, Stats, History)
- `ScoreboardView.swift` - Live game scoring interface with turn logic and bust handling
- `ProfileView.swift` - Player profile management
- `StatsView.swift` - Player statistics and performance metrics
- `HistoryView.swift` - Match history with sorting

**Engine** (`Sources/Engine/`)
- `AICheckoutEngine.swift` - Calculates optimal dart checkout routes and success probabilities based on player hit rates. Uses a predefined checkout table for scores up to 170, with fallback logic for non-standard scores.

**Models** (`Sources/Models/`)
- `Models.swift` - Core data structures: `PlayerStats`, `Match`, `PlayerProfile`, `CheckoutRecommendation`

**Utils** (`Sources/Utils/`)
- `Extensions.swift` - Helper extensions for common operations

## Key Design Patterns

- **Data Flow**: Views read from Models and call Engine functions for calculations
- **Hit Rate Tracking**: Player performance is tracked via `hitRates` dictionary mapping dart targets (T20, D16, Bull, etc.) to success probabilities
- **Checkout Logic**: The AI engine recommends checkout routes based on remaining score and player's historical hit rates on specific targets
- **Mock Data**: Models include mock data for development and testing

## Important Implementation Details

- Checkout calculations use probability multiplication: success chance = product of hit rates for each dart in the route
- Probabilities are clamped to [0, 1] range
- Scores above 170 cannot be finished in one visit (darts rule)
- The app tracks match history with opponent names, scores, game modes (501, 301, Cricket), and results
