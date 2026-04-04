import Foundation

struct WorkoutPlan: Codable, Identifiable {
    let id: UUID
    var name: String
    var generatedAt: Date
    var fitnessLevel: UserProfile.FitnessLevel
    var goal: UserProfile.FitnessGoal
    var estimatedDurationMinutes: Int
    var blocks: [ExerciseBlock]
    var totalEstimatedCalories: Int
}

struct ExerciseBlock: Codable, Identifiable {
    let id: UUID
    var exercise: Exercise
    var sets: Int
    var reps: Int
    var durationSeconds: Int?
    var restSeconds: Int
    var weightKg: Double?
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
