import SwiftUI

struct BluePulseButton: View {
    let title: String
    let action: () -> Void
    @State private var isPulsing = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.ffAccentBlue, .ffAccentBlueBright],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(
                    color: Color.ffAccentBlue.opacity(isPulsing ? 0.7 : 0.3),
                    radius: isPulsing ? 20 : 8
                )
                .scaleEffect(isPulsing ? 1.02 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .sensoryFeedback(.impact, trigger: isPulsing)
    }
}
