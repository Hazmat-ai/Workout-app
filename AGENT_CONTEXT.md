# AGENT_CONTEXT.md — FitForge iOS App

> This file is the authoritative context document for any AI agent, developer, or LLM-assisted coding session working on the **FitForge** iOS app. Read this fully before writing any code.

---

## 🎯 Mission Statement

Build a **Swift-only, SwiftUI-first** iOS fitness app called **FitForge** that:
1. Generates personalized workout plans for users of all fitness levels
2. Tracks daily calorie intake and macro breakdowns
3. Suggests meals based on remaining calorie budget and goals
4. Guides new users with exercise photos and instructional videos
5. Looks and feels premium — black background, electric blue accents, zero compromise on UI quality

---

## ⚠️ Hard Constraints (Never Violate These)

- ✅ **Swift ONLY** — no Objective-C, no React Native, no Flutter, no cross-platform code
- ✅ **SwiftUI ONLY** for all UI — no UIKit unless absolutely required by a system API (e.g., `AVPlayerViewController`)
- ✅ **Minimum iOS target: iOS 17.0**
- ✅ **Xcode 15+** — use all modern Swift concurrency (`async/await`, `actor`, `@Observable`)
- ✅ Colors are ALWAYS `#000000` background with `#007AFF`→`#00C3FF` blue accents
- ✅ Every exercise MUST have an image AND a video reference
- ✅ No third-party package managers unless explicitly approved (prefer native Apple frameworks)
- ❌ No storyboards
- ❌ No UIKit ViewControllers as primary screens
- ❌ No hardcoded strings — use `LocalizedStringKey` or a `Strings` enum
- ❌ No force-unwraps (`!`) except in tests — use `guard let` or `if let`
- ❌ No `@StateObject` with `ObservableObject` — use `@Observable` macro (iOS 17+)

---

## 🏗 Architecture

### Pattern: MVVM + Service Layer

```
View  →  ViewModel (@Observable)  →  Service  →  Repository/DataSource
```

- **Views** — pure SwiftUI, zero business logic
- **ViewModels** — `@Observable` classes, one per screen/feature
- **Services** — pure Swift classes/actors handling business logic
- **Repositories** — abstract data access (Core Data, network, HealthKit)
- **Models** — `Codable`, `Identifiable`, value types (`struct`) where possible

### Module Boundaries

```
┌─────────────────────────────────────────┐
│                   App                   │
│  FitForgeApp.swift  |  AppState.swift   │
└────────────┬────────────────────────────┘
             │
    ┌────────▼────────┐
    │    Features      │  (one folder per tab/feature)
    │  Onboarding      │
    │  Dashboard       │
    │  Workout         │
    │  Nutrition       │
    │  Profile         │
    └────────┬─────────┘
             │
    ┌────────▼─────────┐
    │      Core         │
    │  Models           │
    │  Services         │
    │  Persistence      │
    └────────┬──────────┘
             │
    ┌────────▼──────────┐
    │    Components      │  (shared reusable UI)
    └────────────────────┘
```

---

## 📦 Models Reference

### User
```swift
// Models/User.swift
@Observable
final class UserProfile {
    var id: UUID = UUID()
    var name: String = ""
    var age: Int = 25
    var weightKg: Double = 70.0
    var heightCm: Double = 175.0
    var biologicalSex: BiologicalSex = .male
    var activityLevel: ActivityLevel = .moderatelyActive
    var fitnessLevel: FitnessLevel = .beginner
    var goal: FitnessGoal = .fatLoss
    var dietaryPreferences: [DietaryPreference] = []
    var dailyCalorieTarget: Int = 2000      // recomputed via NutritionService
    var macroTargets: MacroTargets = .default

    enum BiologicalSex { case male, female }
    enum ActivityLevel { case sedentary, lightlyActive, moderatelyActive, veryActive, extraActive }
    enum FitnessLevel: String, CaseIterable { case beginner, intermediate, advanced }
    enum FitnessGoal: String, CaseIterable { case fatLoss, muscleGain, endurance, maintain }
    enum DietaryPreference: String, CaseIterable { case vegan, vegetarian, glutenFree, dairyFree, keto, paleo }
}

struct MacroTargets: Codable {
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double

    static var `default`: MacroTargets {
        MacroTargets(proteinGrams: 150, carbsGrams: 200, fatGrams: 65)
    }
}
```

### Exercise
```swift
// Models/Exercise.swift
struct Exercise: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var muscleGroups: [MuscleGroup]          // primary + secondary
    var equipment: Equipment
    var difficulty: UserProfile.FitnessLevel
    var imageAssetNames: [String]            // ["squat_start", "squat_end"]
    var videoFileName: String                // "beginner_squat.mp4"
    var formCues: [String]                   // ordered beginner instructions
    var estimatedCaloriesPerMinute: Double
}

enum MuscleGroup: String, CaseIterable, Codable {
    case chest, back, shoulders, biceps, triceps
    case quads, hamstrings, glutes, calves, core, fullBody
}

enum Equipment: String, CaseIterable, Codable {
    case bodyweight, dumbbells, barbell, cables, resistanceBands
    case pullUpBar, bench, kettlebell, machine
}
```

### Workout
```swift
// Models/Workout.swift
struct WorkoutPlan: Codable, Identifiable {
    let id: UUID
    var name: String
    var generatedAt: Date
    var fitnessLevel: UserProfile.FitnessLevel
    var goal: UserProfile.FitnessGoal
    var estimatedDurationMinutes: Int
    var blocks: [ExerciseBlock]             // ordered list of exercises
    var totalEstimatedCalories: Int
}

struct ExerciseBlock: Codable, Identifiable {
    let id: UUID
    var exercise: Exercise
    var sets: Int
    var reps: Int                           // target reps (or 0 if duration-based)
    var durationSeconds: Int?               // for planks, holds, etc.
    var restSeconds: Int
    var weightKg: Double?                   // nil = bodyweight
    var notes: String?
}

struct CompletedWorkout: Codable, Identifiable {
    let id: UUID
    var planId: UUID
    var startedAt: Date
    var finishedAt: Date
    var completedBlocks: [CompletedBlock]
    var totalCaloriesBurned: Int
}

struct CompletedBlock: Codable, Identifiable {
    let id: UUID
    var exerciseBlockId: UUID
    var completedSets: [CompletedSet]
}

struct CompletedSet: Codable, Identifiable {
    let id: UUID
    var reps: Int
    var weightKg: Double?
    var durationSeconds: Int?
}
```

### Nutrition
```swift
// Models/Meal.swift
struct FoodItem: Codable, Identifiable {
    let id: UUID
    var name: String
    var brand: String?
    var servingSizeGrams: Double
    var caloriesPerServing: Int
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double
    var fiberGrams: Double
    var imageAssetName: String?
}

struct FoodEntry: Codable, Identifiable {
    let id: UUID
    var foodItem: FoodItem
    var servings: Double                    // multiplier on serving size
    var loggedAt: Date
    var mealType: MealType

    enum MealType: String, Codable, CaseIterable {
        case breakfast, lunch, dinner, snack
    }
}

struct CalorieLog: Codable, Identifiable {
    let id: UUID
    var date: Date                          // day-only (midnight normalized)
    var entries: [FoodEntry]

    var totalCalories: Int {
        entries.reduce(0) { $0 + Int(Double($1.foodItem.caloriesPerServing) * $1.servings) }
    }
    var totalProtein: Double {
        entries.reduce(0) { $0 + $1.foodItem.proteinGrams * $1.servings }
    }
    var totalCarbs: Double {
        entries.reduce(0) { $0 + $1.foodItem.carbsGrams * $1.servings }
    }
    var totalFat: Double {
        entries.reduce(0) { $0 + $1.foodItem.fatGrams * $1.servings }
    }
}

struct MealSuggestion: Codable, Identifiable {
    let id: UUID
    var name: String
    var mealType: FoodEntry.MealType
    var description: String
    var imageAssetName: String
    var items: [FoodItem]
    var totalCalories: Int
    var totalProtein: Double
    var totalCarbs: Double
    var totalFat: Double
    var prepTimeMinutes: Int
    var difficultyLevel: String             // "Easy" / "Medium" / "Hard"
    var instructions: [String]
}
```

---

## ⚙️ Services Reference

### WorkoutGeneratorService
```swift
// Services/WorkoutGeneratorService.swift
// Responsibility: Generate WorkoutPlan from user inputs

actor WorkoutGeneratorService {

    // Primary entry point
    func generatePlan(
        fitnessLevel: UserProfile.FitnessLevel,
        goal: UserProfile.FitnessGoal,
        availableEquipment: [Equipment],
        targetDurationMinutes: Int,
        focusMuscleGroups: [MuscleGroup]
    ) async throws -> WorkoutPlan

    // Rep/set/rest scheme by goal
    // fatLoss   → 3 sets × 15 reps, 45s rest, compound-first ordering
    // muscleGain → 4 sets × 8 reps, 90s rest, push-pull split
    // endurance  → 3 sets × 20 reps, 30s rest, circuit-style
    // maintain   → 3 sets × 12 reps, 60s rest, balanced

    // Beginner plan rules:
    // - Max 5 exercises per session
    // - Always includes warm-up (5 min) + cooldown block
    // - Only bodyweight or light dumbbell exercises
    // - Every exercise has a formCue tip shown to user before starting

    // Duration fitting: iterate exercise list, accumulate time estimate,
    // stop when (sets × reps × 3s) + (sets × restSeconds) exceeds budget
}
```

### NutritionService
```swift
// Services/NutritionService.swift
// Responsibility: TDEE calc, macro targets, meal suggestion generation

actor NutritionService {

    // Mifflin-St Jeor BMR
    // Male:   BMR = 10W + 6.25H - 5A + 5
    // Female: BMR = 10W + 6.25H - 5A - 161
    // W = weight kg, H = height cm, A = age
    func calculateTDEE(profile: UserProfile) -> Int

    // Macro split by goal:
    // fatLoss:    protein 35%, carbs 35%, fat 30%
    // muscleGain: protein 30%, carbs 45%, fat 25%
    // endurance:  protein 20%, carbs 60%, fat 20%
    // maintain:   protein 25%, carbs 50%, fat 25%
    func calculateMacroTargets(tdee: Int, goal: UserProfile.FitnessGoal) -> MacroTargets

    // Meal suggestion scoring:
    // score = (macroAlignmentScore × 0.6) + (preferenceMatchScore × 0.4)
    // macroAlignmentScore = 1 - abs(meal.protein/meal.calories - target.proteinRatio)
    // Returns top 3 suggestions (one per primary meal type)
    func generateMealSuggestions(
        remainingCalories: Int,
        targets: MacroTargets,
        preferences: [UserProfile.DietaryPreference],
        excludeIds: [UUID]
    ) async -> [MealSuggestion]

    // USDA FoodData Central API integration
    // GET https://api.nal.usda.gov/fdc/v1/foods/search?query={q}&api_key={key}
    func searchFoods(query: String) async throws -> [FoodItem]
}
```

### HealthKitService
```swift
// Services/HealthKitService.swift
// Responsibility: Read/write Apple Health data

actor HealthKitService {

    // Request permissions on first launch
    func requestAuthorization() async throws

    // Read types: stepCount, activeEnergyBurned, heartRate, bodyMass
    // Write types: workout (HKWorkout)

    func fetchTodayActiveCalories() async throws -> Int
    func fetchTodaySteps() async throws -> Int
    func fetchLatestWeight() async throws -> Double?
    func saveCompletedWorkout(_ workout: CompletedWorkout) async throws
}
```

### MediaService
```swift
// Services/MediaService.swift
// Responsibility: Manage video and image assets for exercises

final class MediaService {

    // Returns URL for bundled video file
    func videoURL(for exercise: Exercise) -> URL?

    // Returns UIImage for exercise at given position index
    func exerciseImage(named assetName: String) -> UIImage?

    // Preloads AVPlayerItem for an exercise video (call before ExerciseDetailView appears)
    func preloadVideo(for exercise: Exercise) async
}
```

---

## 🎨 UI / Component Guidelines

### Color System
```swift
// Extensions/Color+FitForge.swift
extension Color {
    static let ffBackground     = Color(hex: "#000000")
    static let ffSurface        = Color(hex: "#0A0A0A")
    static let ffCard           = Color(hex: "#111111")
    static let ffAccentBlue     = Color(hex: "#007AFF")
    static let ffAccentBlueMid  = Color(hex: "#0099DD")
    static let ffAccentBlueBright = Color(hex: "#00C3FF")
    static let ffTextPrimary    = Color.white
    static let ffTextSecondary  = Color(hex: "#8E8E93")
    static let ffSuccess        = Color(hex: "#30D158")
    static let ffDanger         = Color(hex: "#FF3B30")
    static let ffWarning        = Color(hex: "#FF9F0A")
}
```

### Component Contracts

**GlassCard** — all content cards must use this
```swift
GlassCard {
    // your content
}
// → dark blur background + blue top-edge glow border + soft blue shadow
```

**BluePulseButton** — primary CTAs only
```swift
BluePulseButton(title: "Start Workout") { /* action */ }
// → full-width, blue gradient, pulsing glow, haptic on tap
```

**AnimatedRingView** — calorie / progress rings
```swift
AnimatedRingView(
    progress: 0.72,           // 0.0 to 1.0
    ringColor: .ffAccentBlue,
    trackColor: .ffCard,
    lineWidth: 14,
    size: 120
)
```

**VideoThumbnailCard** — for exercise cards in list
```swift
VideoThumbnailCard(
    thumbnailImage: image,
    title: exercise.name,
    duration: "30s",
    onTap: { /* open ExerciseDetailView */ }
)
// → full-bleed image, gradient overlay, blue play button badge
```

**ExerciseVideoPlayer** — for full-screen exercise video
```swift
ExerciseVideoPlayer(videoURL: url, isLooping: true)
// wraps AVPlayerViewController inside a SwiftUI View
// auto-plays on appear, pauses on disappear
```

---

## 📺 Video & Media Requirements

### Exercise Videos
- Format: H.264 MP4, portrait orientation (9:16)
- Resolution: 1080×1920
- Duration: 15–45 seconds, seamlessly loopable
- Audio: optional — soft background music or silent
- Naming: `{difficulty}_{exercise_snake_case}.mp4`
  - Example: `beginner_squat.mp4`, `intermediate_deadlift.mp4`
- Bundle location: `Resources/Videos/`
- Production alternative: Stream from CDN using `AVAsset(url: remoteURL)`

### Exercise Photos
- Format: JPEG, 2× resolution
- Size: 800×600px per photo
- 2 photos per exercise: start position + end/peak position
- Naming: `{exercise_snake_case}_start`, `{exercise_snake_case}_end`
- Location: `Assets.xcassets/ExerciseImages/`

### Meal Photos
- Format: JPEG, square crop
- Size: 600×600px
- One photo per meal suggestion
- Naming: `meal_{meal_name_snake_case}`
- Location: `Assets.xcassets/MealImages/`

---

## 📱 Screen Inventory & Navigation

### Tab Bar (5 tabs)
```
[🏠 Home] [💪 Workout] [🍎 Nutrition] [📊 Progress] [👤 Profile]
```

Tab bar: black background, blue active indicator, SF Symbols filled/unfilled

### Screen Map

```
Onboarding (first launch only)
  └── WelcomeView
  └── ProfileSetupView
  └── GoalSelectionView
  └── EquipmentSelectionView
  └── OnboardingCompleteView

Home Tab
  └── DashboardView
        ├── DailyRingView (calories + activity)
        ├── TodaySummaryCard (next workout, meals logged)
        └── QuickStartButton → WorkoutGeneratorView

Workout Tab
  └── WorkoutHomeView
        ├── GeneratePlanButton → WorkoutGeneratorView
        │     └── (generates) → WorkoutPreviewView
        │           └── StartButton → ActiveWorkoutView
        │                 └── (complete) → WorkoutSummaryView
        └── ExerciseLibraryView
              └── ExerciseDetailView
                    ├── ExerciseVideoPlayer
                    ├── FormCuesList
                    └── ImageGallery (start/end photos)

Nutrition Tab
  └── NutritionHomeView
        ├── MacroChartView (Swift Charts donut)
        ├── CalorieRingView
        ├── AddFoodButton → CalorieLogView
        │     └── FoodSearchView → FoodDetailView → add to log
        └── MealSuggestionsView
              └── MealDetailView (full recipe + instructions)

Progress Tab
  └── ProgressView
        ├── WeightChartView (Swift Charts line)
        ├── WorkoutVolumeChart
        ├── PRTracker (personal records per exercise)
        └── StreakCalendarView

Profile Tab
  └── ProfileView
        ├── EditProfileView
        ├── SettingsView
        │     ├── NotificationsToggle
        │     ├── HealthKitToggle
        │     ├── DietaryPreferencesView
        │     └── AppearanceSettings
        └── AboutView
```

---

## 🏃 Active Workout Flow (Critical UX)

```
ActiveWorkoutView state machine:

[ready] → user taps START → [exerciseIntro]
  - show exercise name, image, form cues (3-second countdown)

[exerciseIntro] → countdown completes → [activeSet]
  - large timer, current set/rep counter
  - "Done Set" button (green, full-width)
  - "Skip" button (ghost, top-right)

[activeSet] → user taps Done Set → [rest]
  - rest timer countdown (45/60/90s based on goal)
  - next exercise preview at bottom
  - "Skip Rest" option

[rest] → timer ends OR skip → [activeSet] (next set)
  OR [exerciseIntro] (next exercise, if sets complete)
  OR [workoutComplete] (if last exercise, last set)

[workoutComplete] → WorkoutSummaryView
  - total time, calories burned, exercises completed
  - "Save Workout" → writes to CoreData + HealthKit
```

---

## 🗃 Persistence Strategy

### Core Data Entities
- `CDUserProfile` — singleton user record
- `CDCalorieLog` — one per calendar day
- `CDFoodEntry` — many per log
- `CDWorkoutPlan` — generated plans (keep last 30)
- `CDCompletedWorkout` — full history
- `CDFoodItem` — cached food items from USDA API

### CloudKit Sync
- Enable **NSPersistentCloudKitContainer** for user data sync across devices
- Exclude heavy media (videos) from sync
- Use `NSMergeByPropertyObjectTrumpMergePolicy` for conflict resolution

### UserDefaults (lightweight flags)
```swift
// AppStorageKeys.swift
enum AppStorageKey {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let lastSelectedTab = "lastSelectedTab"
    static let dailyReminderHour = "dailyReminderHour"
}
```

---

## 🔔 Notifications

Implement local notifications using `UserNotifications`:

| Trigger | Title | Body |
|---|---|---|
| Daily 8am | "🔥 Morning fuel up!" | "Log your breakfast to hit your goals." |
| Daily 6pm | "💪 Time to train?" | "You haven't logged a workout yet today." |
| After 2-day gap | "We miss you, {name}" | "Jump back in — your plan is ready." |
| Goal reached | "🎯 Calorie goal hit!" | "You've hit your nutrition target for today." |

---

## 🧪 Testing Requirements

| Test Target | Coverage Goal | Key Test Cases |
|---|---|---|
| `WorkoutGeneratorTests` | 90% | Plan respects duration budget; beginner max 5 exercises; correct rep scheme per goal |
| `NutritionServiceTests` | 90% | TDEE within ±5% of manual calc; macro splits sum to 100%; meal score ranking is deterministic |
| `CalorieLogTests` | 85% | Daily totals compute correctly; entries persist and reload correctly |
| `HealthKitMockTests` | 70% | Auth denied gracefully; mock calorie reads return expected values |
| `UITests` | 60% | Onboarding complete flow; add food and see ring update; start and complete a workout |

---

## 🧩 Beginner-Friendly Features Checklist

Ensure every one of these is implemented before v1.0 ship:

- [ ] Onboarding explains each tab with an animated illustration
- [ ] Every exercise shows a video BEFORE the set starts (3-second preview)
- [ ] Form cue tooltips appear on first active workout session
- [ ] Meal suggestions include a photo AND ingredient list AND instructions
- [ ] Dashboard has a "What should I do today?" card for zero-state users
- [ ] Empty states on all screens (no blank white boxes)
- [ ] "What is this?" info buttons on every macro / stat label
- [ ] Beginner workout plans are labeled "New to fitness? Start here"
- [ ] Rest timer has an animation and optional vibration
- [ ] App is fully accessible (Dynamic Type, VoiceOver labels, sufficient contrast)

---

## 🧠 Agent Instructions (If You Are an LLM Building This)

When generating Swift code for this project:

1. **Always use `@Observable`** — never `ObservableObject` + `@Published`
2. **Always use `async/await`** — never completion handlers or Combine
3. **Always use `actor`** for services that touch data or network
4. **Never force-unwrap** — handle optionals with `guard let`, `if let`, or `??`
5. **Always provide an empty/loading state** in every SwiftUI view
6. **Follow the naming conventions** in the Models section exactly
7. **Use `Color.ffAccentBlue`** etc. — never hardcoded hex strings in views
8. **Every new View** must also have a corresponding `#Preview` macro at the bottom
9. **Video player** must use `AVKit.AVPlayerViewController` wrapped in `UIViewControllerRepresentable`
10. **Charts** must use `import Charts` (Swift Charts, iOS 16+)
11. **All Core Data operations** must happen off the main thread using `.perform`
12. **When in doubt**, prefer Apple-native solutions over custom implementations

### Code Style
- 4-space indentation
- `// MARK: -` sections for logical groupings
- Doc comments (`///`) on all public interfaces
- `@MainActor` on all ViewModels
- Extension files named `TypeName+Purpose.swift`

---

## 📎 External API Reference

### USDA FoodData Central
- Base URL: `https://api.nal.usda.gov/fdc/v1`
- Key endpoint: `GET /foods/search?query=apple&api_key=YOUR_KEY`
- Free API key: https://fdc.nal.usda.gov/api-guide.html
- Rate limit: 3,600 requests/hour

### Apple HealthKit Types Used
```swift
// Read
HKQuantityType(.stepCount)
HKQuantityType(.activeEnergyBurned)
HKQuantityType(.heartRate)
HKQuantityType(.bodyMass)

// Write
HKObjectType.workoutType()
HKQuantityType(.activeEnergyBurned)
```

---

*Last updated: 2026 | FitForge iOS — Swift-native, no shortcuts.*
