import SwiftUI

struct WelcomeView: View {
    @Environment(AppState.self) private var appState
    @State private var navigateToSetup = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    Text("FitForge")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.ffAccentBlue, .ffAccentBlueBright], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    Text("Forge your best self.")
                        .font(.title3)
                        .foregroundColor(.ffTextSecondary)
                    
                    Spacer()
                    
                    BluePulseButton(title: "Get Started") {
                        navigateToSetup = true
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $navigateToSetup) {
                ProfileSetupView()
            }
        }
    }
}
