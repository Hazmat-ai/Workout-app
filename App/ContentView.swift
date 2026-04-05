import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        if !appState.hasCompletedOnboarding {
            WelcomeView()
        } else {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                WorkoutHomeView()
                    .tabItem {
                        Label("Workout", systemImage: "figure.run")
                    }
                NutritionHomeView()
                    .tabItem {
                        Label("Nutrition", systemImage: "fork.knife")
                    }
                ProgressView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
            .tint(Color(hex: "#00C3FF"))
        }
    }
}

// #Preview {
//     ContentView()
//         .environment(AppState())
// }
