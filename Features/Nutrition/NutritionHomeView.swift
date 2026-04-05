import SwiftUI

struct NutritionHomeView: View {
    @Environment(AppState.self) private var appState
    @State private var loggedCalories = 0
    @State private var meals: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        GlassCard {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Log Food")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(loggedCalories) kcal")
                                        .foregroundColor(.ffAccentBlue)
                                }
                                
                                HStack {
                                    BluePulseButton(title: "Add Apple (95)") {
                                        loggedCalories += 95
                                        meals.append("Apple - 95 kcal")
                                    }
                                    BluePulseButton(title: "Add Chicken (250)") {
                                        loggedCalories += 250
                                        meals.append("Chicken Breast - 250 kcal")
                                    }
                                }
                            }
                        }
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Today's Log")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                if meals.isEmpty {
                                    Text("No meals logged yet.")
                                        .foregroundColor(.ffTextSecondary)
                                } else {
                                    ForEach(meals, id: \.self) { meal in
                                        Text("• \(meal)")
                                            .foregroundColor(.ffTextSecondary)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
            // .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Nutrition")
        }
    }
}
