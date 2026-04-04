import Foundation

struct Exercise: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var muscleGroups: [MuscleGroup]
    var equipment: Equipment
    var difficulty: UserProfile.FitnessLevel
    var imageAssetNames: [String]
    var videoFileName: String
    var formCues: [String]
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
