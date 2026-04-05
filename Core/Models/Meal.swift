import Foundation

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
    var servings: Double
    var loggedAt: Date
    var mealType: MealType

    enum MealType: String, Codable, CaseIterable {
        case breakfast, lunch, dinner, snack
    }
}

struct CalorieLog: Codable, Identifiable {
    let id: UUID
    var date: Date
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
    var difficultyLevel: String
    var instructions: [String]
}
