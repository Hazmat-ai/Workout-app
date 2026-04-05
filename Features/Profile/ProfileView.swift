import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(appState.userProfile.name.isEmpty ? "FitForge User" : appState.userProfile.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                Text("Goal: \(appState.userProfile.goal.rawValue.capitalized)")
                                    .foregroundColor(.ffTextSecondary)
                                Text("Level: \(appState.userProfile.fitnessLevel.rawValue.capitalized)")
                                    .foregroundColor(.ffTextSecondary)
                                Text("Weight: \(appState.userProfile.weightKg, specifier: "%.1f") kg")
                                    .foregroundColor(.ffTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Nutrition Targets")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Calories: \(appState.userProfile.dailyCalorieTarget) kcal")
                                    .foregroundColor(.ffAccentBlueBright)
                                Text("Protein: \(Int(appState.userProfile.macroTargets.proteinGrams))g")
                                    .foregroundColor(.ffTextSecondary)
                                Text("Carbs: \(Int(appState.userProfile.macroTargets.carbsGrams))g")
                                    .foregroundColor(.ffTextSecondary)
                                Text("Fat: \(Int(appState.userProfile.macroTargets.fatGrams))g")
                                    .foregroundColor(.ffTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        BluePulseButton(title: "Reset Onboarding") {
                            withAnimation {
                                appState.hasCompletedOnboarding = false
                            }
                        }
                    }
                    .padding()
                }
            }
            // .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }
    }
}
