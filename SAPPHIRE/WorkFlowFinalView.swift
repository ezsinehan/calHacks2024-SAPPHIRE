import SwiftUI

struct TaskControlView: View {
    @Binding var tasks: [String]
    @Binding var currentTaskIndex: Int
    var onPause: () -> Void
    var onComplete: () -> Void
    var onViewTasks: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Display the current task
            if currentTaskIndex < tasks.count {
                Text("Current Task: \(tasks[currentTaskIndex])")
                    .font(.title)
                    .padding()
            } else {
                Text("No more tasks")
                    .font(.title)
                    .padding()
            }
            
            // Control buttons
            Button(action: {
                onPause()
            }) {
                Text("Pause Task")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Button(action: {
                onComplete() // Complete the current task
            }) {
                Text("Complete Task")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Button(action: {
                onViewTasks()
            }) {
                Text("View Tasks")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }
}
