import SwiftUI

struct WorkoutHomeView: View {
    @Environment(AppState.self) private var appState
    @State private var plan: WorkoutPlan?
    @State private var isGenerating = false
    @State private var navigateToActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        GlassCard {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Generate Plan")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Let AI build your workout")
                                        .font(.subheadline)
                                        .foregroundColor(.ffTextSecondary)
                                }
                                Spacer()
                                Image(systemName: "wand.and.stars")
                                    .font(.title)
                                    .foregroundColor(.ffAccentBlueBright)
                            }
                        }
                        .onTapGesture {
                            generateWorkout()
                        }
                        
                        if isGenerating {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.ffAccentBlue)
                        } else if let plan = plan {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(plan.name)
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                    Text("\(plan.totalEstimatedCalories) kcal • \(plan.blocks.count) Exercises")
                                        .foregroundColor(.ffTextSecondary)
                                    
                                    ForEach(plan.blocks) { block in
                                        HStack {
                                            Text(block.exercise.name)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("\(block.sets)x\(block.reps)")
                                                .foregroundColor(.ffAccentBlue)
                                        }
                                        .font(.subheadline)
                                    }
                                    
                                    BluePulseButton(title: "Start Workout") {
                                        navigateToActive = true
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Workouts")
            .navigationDestination(isPresented: $navigateToActive) {
                if let plan = plan {
                    ActiveWorkoutView(plan: plan)
                }
            }
        }
    }
    
    private func generateWorkout() {
        isGenerating = true
        Task {
            let service = WorkoutGeneratorService()
            do {
                let generated = try await service.generatePlan(
                    fitnessLevel: appState.userProfile.fitnessLevel,
                    goal: appState.userProfile.goal,
                    availableEquipment: [.bodyweight, .dumbbells],
                    targetDurationMinutes: 45,
                    focusMuscleGroups: [.chest, .back, .quads, .core]
                )
                await MainActor.run {
                    self.plan = generated
                    self.isGenerating = false
                }
            } catch {
                await MainActor.run { self.isGenerating = false }
            }
        }
    }
}
