# ⚡ FitForge — iOS Workout & Nutrition App

> A Swift-native fitness companion that generates personalized workouts, tracks calories, and serves smart meal suggestions — wrapped in a bold black & electric blue UI.

---

## 📱 App Overview

**FitForge** is a full-featured iOS fitness app built entirely in **Swift** using **SwiftUI** and native Apple frameworks. It targets beginners and intermediate athletes who want an all-in-one solution for training and nutrition — with rich visual and video guidance so new clients are never left guessing.

---

## 🎨 Design Language

| Token | Value |
|---|---|
| Primary Background | `#000000` |
| Surface / Card | `#0A0A0A` / `#111111` |
| Electric Blue Accent | `#007AFF` → `#00C3FF` (gradient) |
| Text Primary | `#FFFFFF` |
| Text Secondary | `#8E8E93` |
| Danger / Burn | `#FF3B30` |
| Success / Complete | `#30D158` |

**Typography**
- Display / Headers → `SF Pro Rounded` Bold
- Body → `SF Pro Text` Regular / Medium
- Monospaced stats → `SF Mono`

**Visual Style**
- Dark glassmorphism cards with blue glow borders
- Animated blue gradient rings for progress
- Full-bleed video thumbnails with overlay stats
- Haptic feedback on all major interactions

---

## 🗂 Project Structure

```
FitForge/
├── App/
│   ├── FitForgeApp.swift               # @main entry point
│   └── AppState.swift                  # Global ObservableObject
│
├── Core/
│   ├── Models/
│   │   ├── User.swift                  # Profile, goals, stats
│   │   ├── Workout.swift               # WorkoutPlan, Exercise, Set
│   │   ├── Meal.swift                  # MealSuggestion, FoodItem, MacroBreakdown
│   │   └── CalorieLog.swift            # Daily log entries
│   │
│   ├── Services/
│   │   ├── WorkoutGeneratorService.swift   # AI-driven plan builder
│   │   ├── NutritionService.swift          # Calorie calc + meal engine
│   │   ├── MediaService.swift              # Video/image asset manager
│   │   └── HealthKitService.swift          # Apple Health integration
│   │
│   └── Persistence/
│       ├── CoreDataStack.swift
│       └── FitForge.xcdatamodeld
│
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift         # Welcome + goal setup
│   │   ├── ProfileSetupView.swift       # Age, weight, height, fitness level
│   │   └── GoalSelectionView.swift     # Lose fat / Build muscle / Maintain
│   │
│   ├── Dashboard/
│   │   ├── DashboardView.swift          # Home tab
│   │   ├── DailyRingView.swift          # Calorie + activity rings
│   │   └── TodaySummaryCard.swift
│   │
│   ├── Workout/
│   │   ├── WorkoutHomeView.swift        # Browse & start workouts
│   │   ├── WorkoutGeneratorView.swift   # AI plan builder UI
│   │   ├── ActiveWorkoutView.swift      # Live timer + set tracker
│   │   ├── ExerciseDetailView.swift     # Image + video demo for each exercise
│   │   ├── ExerciseVideoPlayer.swift    # AVPlayer wrapper
│   │   └── WorkoutHistoryView.swift
│   │
│   ├── Nutrition/
│   │   ├── NutritionHomeView.swift      # Daily calorie overview
│   │   ├── CalorieLogView.swift         # Add / remove food log entries
│   │   ├── FoodSearchView.swift         # Search food database
│   │   ├── MealSuggestionsView.swift    # Generated meal cards
│   │   └── MacroChartView.swift         # SwiftUI Charts breakdown
│   │
│   └── Profile/
│       ├── ProfileView.swift
│       ├── SettingsView.swift
│       └── ProgressView.swift           # Weight + strength history charts
│
├── Components/
│   ├── GlassCard.swift                  # Reusable dark glass card
│   ├── BluePulseButton.swift            # Primary CTA button with glow
│   ├── AnimatedRingView.swift           # Circular progress ring
│   ├── VideoThumbnailCard.swift         # Thumbnail + play overlay
│   ├── MacroBadge.swift                 # P / C / F colored tags
│   └── StatRow.swift                    # Label + value row
│
├── Resources/
│   ├── Assets.xcassets/
│   │   ├── ExerciseImages/             # Per-exercise reference photos
│   │   └── MealImages/                 # Food photography assets
│   │
│   └── Videos/
│       ├── beginner_squat.mp4
│       ├── beginner_pushup.mp4
│       ├── beginner_deadlift.mp4
│       └── ...                          # One video per exercise
│
└── Tests/
    ├── FitForgeTests/
    └── FitForgeUITests/
```

---

## 🚀 Features

### 🏋️ Workout Engine
- **AI Workout Generator** — user inputs fitness level, available equipment, time, and goal → app generates a structured plan with sets, reps, and rest periods
- **Exercise Library** — 100+ exercises with:
  - High-quality reference **photo** (start & end position)
  - Looping **instructional video** via `AVPlayer`
  - Written form cues broken into beginner-friendly steps
- **Active Workout Mode** — full-screen timer, auto-advance sets, rest countdown with haptic alerts
- **Workout History** — logged sessions with volume, duration, and PR tracking

### 🍎 Nutrition & Calorie Tracking
- **TDEE Calculator** — computes daily calorie target based on user profile using Mifflin-St Jeor formula
- **Food Log** — search and add meals from a built-in food database (USDA-compatible structure)
- **Macro Breakdown** — animated donut chart for Protein / Carbs / Fat using `Swift Charts`
- **Calorie Ring** — visual ring on dashboard fills as user logs food throughout the day
- **Meal Suggestions Engine** — generates 3 meal suggestions per day (breakfast, lunch, dinner) based on:
  - Remaining calorie budget
  - User's macro targets
  - Dietary preferences (set in Profile)

### 📸 Visual Guidance for New Clients
- Every exercise has a **video tutorial** shot from a clear angle with beginner pacing
- **Onboarding tour** uses full-screen illustrated cards explaining each app section
- **Meal cards** include a food photo and macro snapshot so users know exactly what they're eating
- Tooltip overlays on first use of each major feature

### ❤️ HealthKit Integration
- Reads: Steps, Active Energy, Heart Rate, Body Weight
- Writes: Workouts, Energy Burned
- Dashboard syncs HealthKit calories into the daily ring automatically

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.10+ |
| UI Framework | SwiftUI |
| Video Playback | AVFoundation / AVKit |
| Charts | Swift Charts (iOS 16+) |
| Persistence | Core Data + CloudKit sync |
| Health | HealthKit |
| Networking | URLSession + async/await |
| Nutrition Data | USDA FoodData Central API |
| Min iOS Target | iOS 17.0 |
| Xcode Version | Xcode 15+ |

---

## 🔧 Setup & Installation

### Prerequisites
- macOS 14 Sonoma or later
- Xcode 15.0+
- iOS 17.0+ device or simulator
- Apple Developer account (for HealthKit entitlements)

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/your-username/FitForge.git
cd FitForge

# 2. Open in Xcode
open FitForge.xcodeproj

# 3. Set your development team
# Xcode → Signing & Capabilities → Team

# 4. Add entitlements
# HealthKit → enable in Signing & Capabilities
# CloudKit → enable for Core Data sync (optional)

# 5. Add your USDA API key
# Create Config.xcconfig and add:
# USDA_API_KEY = your_key_here
# Get a free key at: https://fdc.nal.usda.gov/api-guide.html

# 6. Build & Run
# Select target device → ⌘R
```

### Info.plist Keys Required
```xml
<key>NSHealthShareUsageDescription</key>
<string>FitForge reads your activity and health data to personalize your experience.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>FitForge saves your workouts to Apple Health.</string>

<key>NSCameraUsageDescription</key>
<string>Used to scan food barcodes for quick calorie logging.</string>
```

---

## 📐 Workout Generator Logic

```swift
// WorkoutGeneratorService.swift — simplified algorithm

struct WorkoutInput {
    let fitnessLevel: FitnessLevel    // beginner / intermediate / advanced
    let goal: FitnessGoal             // fatLoss / muscleGain / endurance
    let equipment: [Equipment]        // bodyweight / dumbbells / barbell / cables
    let durationMinutes: Int          // 20 / 30 / 45 / 60
    let muscleGroups: [MuscleGroup]   // user-selected focus areas
}

func generatePlan(from input: WorkoutInput) -> WorkoutPlan {
    // 1. Filter exercise pool by equipment + muscle groups
    // 2. Sort by difficulty matching fitnessLevel
    // 3. Apply rep/set scheme based on goal:
    //    - fatLoss:     3x15 @ 60% 1RM, 45s rest
    //    - muscleGain:  4x8  @ 75% 1RM, 90s rest
    //    - endurance:   3x20 @ 50% 1RM, 30s rest
    // 4. Auto-fill duration budget, fitting warm-up + cooldown
    // 5. Return WorkoutPlan with ordered ExerciseBlocks
}
```

---

## 🍽 Meal Suggestion Logic

```swift
// NutritionService.swift — meal generation

func generateMealSuggestions(
    remainingCalories: Int,
    macroTargets: MacroTargets,
    preferences: DietaryPreferences
) -> [MealSuggestion] {
    // 1. Split remaining calories: 30% breakfast, 40% lunch/dinner, 30% dinner
    // 2. Query meal database filtered by preferences (vegan, gluten-free, etc.)
    // 3. Score meals by macro alignment score against targets
    // 4. Return top 3 ranked meals with full MacroBreakdown
}
```

---

## 🎨 UI Component Examples

```swift
// GlassCard.swift
struct GlassCard<Content: View>: View {
    let content: Content
    var body: some View {
        content
            .padding(20)
            .background(.ultraThinMaterial)
            .background(Color(hex: "#007AFF").opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "#007AFF").opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color(hex: "#007AFF").opacity(0.2), radius: 12)
    }
}

// BluePulseButton.swift
struct BluePulseButton: View {
    let title: String
    let action: () -> Void
    @State private var isPulsing = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#007AFF"), Color(hex: "#00C3FF")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(
                    color: Color(hex: "#007AFF").opacity(isPulsing ? 0.7 : 0.3),
                    radius: isPulsing ? 20 : 8
                )
                .scaleEffect(isPulsing ? 1.02 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .sensoryFeedback(.impact, trigger: isPulsing)
    }
}
```

---

## 📊 Data Models

```swift
// Core models overview

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var age: Int
    var weightKg: Double
    var heightCm: Double
    var fitnessLevel: FitnessLevel
    var goal: FitnessGoal
    var dailyCalorieTarget: Int       // computed via TDEE
    var macroTargets: MacroTargets
}

struct Exercise: Codable, Identifiable {
    let id: UUID
    var name: String
    var muscleGroups: [MuscleGroup]
    var equipment: Equipment
    var difficulty: FitnessLevel
    var imageAssetName: String        // local asset key
    var videoFileName: String         // bundled .mp4 filename
    var formCues: [String]            // step-by-step instructions
}

struct CalorieLog: Codable, Identifiable {
    let id: UUID
    var date: Date
    var entries: [FoodEntry]
    var totalCalories: Int { entries.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double
    var totalCarbs: Double
    var totalFat: Double
}
```

---

## 🧪 Testing

```bash
# Run unit tests
⌘U in Xcode

# Key test targets:
# - WorkoutGeneratorTests   → validates plan generation logic
# - NutritionServiceTests   → verifies TDEE + macro calculations  
# - CalorieLogTests         → checks log persistence and aggregation
# - HealthKitMockTests      → mocked HK reads/writes
```

---

## 📸 Media Asset Guidelines

| Asset Type | Format | Resolution | Notes |
|---|---|---|---|
| Exercise photos | `.jpg` | 800×600 | 2 per exercise (start + end position) |
| Meal photos | `.jpg` | 600×600 | Square crop, well-lit |
| Exercise videos | `.mp4` (H.264) | 1080×1920 | Portrait, 15–45 sec, loopable |
| Onboarding illustrations | `.svg` / `.pdf` | Vector | Export @1x, @2x, @3x |

Videos are bundled in the app target. For production, consider streaming from a CDN and using `AVAsset(url:)` with remote URLs to keep the binary size down.

---

## 🗺 Roadmap

- [ ] v1.0 — Core workout generator + calorie tracking + meal suggestions
- [ ] v1.1 — HealthKit full sync + Apple Watch companion app
- [ ] v1.2 — Barcode scanner for instant food logging
- [ ] v1.3 — Progress photos + body measurement tracking
- [ ] v2.0 — Trainer mode — coaches can assign plans to clients
- [ ] v2.1 — Video upload — users record their own form for review

---

## 📄 License

MIT License — see `LICENSE` for details.

---

> Built with ❤️ and 🔵 in Swift. Train hard. Eat smart. Stay consistent.
