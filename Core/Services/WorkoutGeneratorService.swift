import Foundation

actor WorkoutGeneratorService {
    
    func generatePlan(
        fitnessLevel: UserProfile.FitnessLevel,
        goal: UserProfile.FitnessGoal,
        availableEquipment: [Equipment],
        targetDurationMinutes: Int,
        focusMuscleGroups: [MuscleGroup]
    ) async throws -> WorkoutPlan {
        
        let allExercises = Self.mockDatabase()
        
        // Filter by fitness level
        let available = allExercises.filter { ex in
            ex.difficulty == fitnessLevel || (fitnessLevel == .intermediate && ex.difficulty == .beginner) || (fitnessLevel == .advanced)
        }
        
        // Simple heuristic: pick 4-6 exercises that match the muscle groups
        var selected: [Exercise] = []
        for muscle in focusMuscleGroups {
            if let match = available.first(where: { $0.muscleGroups.contains(muscle) && !selected.contains($0) }) {
                selected.append(match)
            }
        }
        
        // Fill up to 5 exercises if missing
        if selected.count < 5 {
            let remain = available.filter { !selected.contains($0) }.shuffled()
            selected.append(contentsOf: remain.prefix(5 - selected.count))
        }
        
        var sets = 3
        var reps = 12
        var rest = 60
        
        switch goal {
        case .fatLoss:
            sets = 3
            reps = 15
            rest = 45
        case .muscleGain:
            sets = 4
            reps = 8
            rest = 90
        case .endurance:
            sets = 3
            reps = 20
            rest = 30
        case .maintain:
            sets = 3
            reps = 12
            rest = 60
        }
        
        var blocks: [ExerciseBlock] = []
        var totalCalories = 0
        
        for ex in selected {
            let block = ExerciseBlock(
                id: UUID(),
                exercise: ex,
                sets: sets,
                reps: reps,
                durationSeconds: nil,
                restSeconds: rest,
                weightKg: nil,
                notes: nil
            )
            blocks.append(block)
            totalCalories += Int(ex.estimatedCaloriesPerMinute * Double(sets) * 1.5)
        }
        
        return WorkoutPlan(
            id: UUID(),
            name: "\(goal.rawValue.capitalized) Protocol",
            generatedAt: Date(),
            fitnessLevel: fitnessLevel,
            goal: goal,
            estimatedDurationMinutes: targetDurationMinutes,
            blocks: blocks,
            totalEstimatedCalories: totalCalories
        )
    }
    
    static func mockDatabase() -> [Exercise] {
        return [
            Exercise(id: UUID(), name: "Push Up", description: "Standard push up.", muscleGroups: [.chest, .triceps], equipment: .bodyweight, difficulty: .beginner, imageAssetNames: [], videoFileName: "", formCues: ["Keep core tight", "Go all the way down"], estimatedCaloriesPerMinute: 8.0),
            Exercise(id: UUID(), name: "Squat", description: "Bodyweight squat.", muscleGroups: [.quads, .glutes], equipment: .bodyweight, difficulty: .beginner, imageAssetNames: [], videoFileName: "", formCues: ["Knees track over toes", "Chest up"], estimatedCaloriesPerMinute: 10.0),
            Exercise(id: UUID(), name: "Pull Up", description: "Standard pull up.", muscleGroups: [.back, .biceps], equipment: .pullUpBar, difficulty: .intermediate, imageAssetNames: [], videoFileName: "", formCues: ["Pull chest to bar", "Engage lats"], estimatedCaloriesPerMinute: 12.0),
            Exercise(id: UUID(), name: "Plank", description: "Core strength plank.", muscleGroups: [.core], equipment: .bodyweight, difficulty: .beginner, imageAssetNames: [], videoFileName: "", formCues: ["Straight line from head to heels"], estimatedCaloriesPerMinute: 5.0)
        ]
    }
}
