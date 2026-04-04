import SwiftUI

struct DashboardView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        AnimatedRingView(
                            progress: 400.0 / Double(appState.userProfile.dailyCalorieTarget),
                            ringColor: .ffAccentBlue,
                            trackColor: .ffSurface,
                            lineWidth: 20,
                            size: 200
                        )
                            .padding()
                            .overlay(
                                VStack {
                                    Text("400 / \(appState.userProfile.dailyCalorieTarget)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("kcal eaten")
                                        .font(.caption)
                                        .foregroundColor(.ffTextSecondary)
                                }
                            )
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Next Workout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Generate a plan in the Workouts tab.")
                                    .foregroundColor(.ffTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
            // .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Dashboard")
        }
    }
}
