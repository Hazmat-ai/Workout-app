import Foundation

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
    var dailyCalorieTarget: Int = 2000
    var macroTargets: MacroTargets = .default

    enum BiologicalSex: String, Codable, CaseIterable { case male, female }
    enum ActivityLevel: String, Codable, CaseIterable { case sedentary, lightlyActive, moderatelyActive, veryActive, extraActive }
    enum FitnessLevel: String, Codable, CaseIterable { case beginner, intermediate, advanced }
    enum FitnessGoal: String, Codable, CaseIterable { case fatLoss, muscleGain, endurance, maintain }
    enum DietaryPreference: String, Codable, CaseIterable { case vegan, vegetarian, glutenFree, dairyFree, keto, paleo }
}

struct MacroTargets: Codable {
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double

    static var `default`: MacroTargets {
        MacroTargets(proteinGrams: 150, carbsGrams: 200, fatGrams: 65)
    }
}
