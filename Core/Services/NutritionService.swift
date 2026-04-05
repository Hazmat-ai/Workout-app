import Foundation

actor NutritionService {
    
    func calculateTDEE(profile: UserProfile) -> Int {
        var baseBMR: Double = (10.0 * profile.weightKg) + (6.25 * profile.heightCm) - (5.0 * Double(profile.age))
        baseBMR += profile.biologicalSex == .male ? 5.0 : -161.0
        
        let multiplier: Double
        switch profile.activityLevel {
        case .sedentary: multiplier = 1.2
        case .lightlyActive: multiplier = 1.375
        case .moderatelyActive: multiplier = 1.55
        case .veryActive: multiplier = 1.725
        case .extraActive: multiplier = 1.9
        }
        
        var tdee = baseBMR * multiplier
        
        // Adjust for goal
        switch profile.goal {
        case .fatLoss: tdee -= 500
        case .muscleGain: tdee += 300
        case .endurance, .maintain: break
        }
        
        return Int(tdee)
    }
    
    func calculateMacroTargets(tdee: Int, goal: UserProfile.FitnessGoal) -> MacroTargets {
        let pRatio, cRatio, fRatio: Double
        
        switch goal {
        case .fatLoss:
            pRatio = 0.35; cRatio = 0.35; fRatio = 0.30
        case .muscleGain:
            pRatio = 0.30; cRatio = 0.45; fRatio = 0.25
        case .endurance:
            pRatio = 0.20; cRatio = 0.60; fRatio = 0.20
        case .maintain:
            pRatio = 0.25; cRatio = 0.50; fRatio = 0.25
        }
        
        let proteinGrams = (Double(tdee) * pRatio) / 4.0
        let carbsGrams = (Double(tdee) * cRatio) / 4.0
        let fatGrams = (Double(tdee) * fRatio) / 9.0
        
        return MacroTargets(proteinGrams: proteinGrams, carbsGrams: carbsGrams, fatGrams: fatGrams)
    }
}
