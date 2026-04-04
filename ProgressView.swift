import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.ffBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        GlassCard {
                            VStack(alignment: .leading) {
                                Text("Weight History")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Add log entries to view chart")
                                    .foregroundColor(.ffTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress")
// .navigationBarTitleDisplayMode(.inline)
        }
    }
}
