import SwiftUI

struct ActiveWorkoutView: View {
    let plan: WorkoutPlan
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentBlockIndex = 0
    @State private var currentSet = 1
    @State private var isResting = false
    @State private var restSecondsRemaining = 0
    @State private var timer: Timer?

    var currentBlock: ExerciseBlock {
        plan.blocks[currentBlockIndex]
    }
    
    var body: some View {
        ZStack {
            Color.ffBackground.ignoresSafeArea()
            
            VStack {
                Text(currentBlock.exercise.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                
                Text(isResting ? "REST" : "SET \(currentSet) of \(currentBlock.sets)")
                    .font(.title2)
                    .foregroundColor(.ffAccentBlueBright)
                
                Spacer()
                
                if isResting {
                    Text("\(restSecondsRemaining)s")
                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                } else {
                    Text("\(currentBlock.reps) Reps")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if isResting {
                    BluePulseButton(title: "Skip Rest") {
                        finishRest()
                    }
                    .padding()
                } else {
                    BluePulseButton(title: "Log Set") {
                        startRest()
                    }
                    .padding()
                }
            }
        }
        // .navigationBarTitleDisplayMode(.inline)  // (Commented out for unified macOS compat)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startRest() {
        if currentSet >= currentBlock.sets {
            // Move to next exercise
            if currentBlockIndex < plan.blocks.count - 1 {
                currentBlockIndex += 1
                currentSet = 1
            } else {
                dismiss() // workout done!
            }
        } else {
            isResting = true
            restSecondsRemaining = currentBlock.restSeconds
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if restSecondsRemaining > 0 {
                    restSecondsRemaining -= 1
                } else {
                    finishRest()
                }
            }
        }
    }
    
    private func finishRest() {
        timer?.invalidate()
        isResting = false
        currentSet += 1
    }
}
