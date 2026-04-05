import SwiftUI

struct ProfileSetupView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var state = appState
        
        ZStack {
            Color.ffBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Your Profile")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 15) {
                        TextField("Name", text: $state.userProfile.name)
                            .textFieldStyle(.roundedBorder)
                        
                        Stepper("Age: \(state.userProfile.age)", value: $state.userProfile.age, in: 10...100)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Weight (kg):")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("70.0", value: $state.userProfile.weightKg, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                        }
                        
                        HStack {
                            Text("Height (cm):")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("175.0", value: $state.userProfile.heightCm, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                        }
                    }
                }
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Picker("Fitness Level", selection: $state.userProfile.fitnessLevel) {
                            Text("Beginner").tag(UserProfile.FitnessLevel.beginner)
                            Text("Intermediate").tag(UserProfile.FitnessLevel.intermediate)
                            Text("Advanced").tag(UserProfile.FitnessLevel.advanced)
                        }
                        .colorInvert()
                        
                        Picker("Goal", selection: $state.userProfile.goal) {
                            Text("Fat Loss").tag(UserProfile.FitnessGoal.fatLoss)
                            Text("Muscle Gain").tag(UserProfile.FitnessGoal.muscleGain)
                            Text("Endurance").tag(UserProfile.FitnessGoal.endurance)
                            Text("Maintain").tag(UserProfile.FitnessGoal.maintain)
                        }
                        .colorInvert()
                    }
                }
                
                Spacer()
                
                BluePulseButton(title: "Complete") {
                    finishOnboarding()
                }
            }
            .padding()
        }
    }
    
    private func finishOnboarding() {
        Task {
            let service = NutritionService()
            let tdee = await service.calculateTDEE(profile: appState.userProfile)
            let macros = await service.calculateMacroTargets(tdee: tdee, goal: appState.userProfile.goal)
            
            await MainActor.run {
                appState.userProfile.dailyCalorieTarget = tdee
                appState.userProfile.macroTargets = macros
                withAnimation {
                    appState.hasCompletedOnboarding = true
                }
            }
        }
    }
}
