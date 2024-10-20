import SwiftUI

struct WorkFlowView: View {
    var onComplete: () -> Void // Callback when workflow is complete
    @Binding var tasks: [String]  // List of tasks

    @State private var newTask: String = ""  // New task input
    @State private var editMode: Bool = false // Whether we are editing a task
    @State private var taskToEditIndex: Int? = nil // Index of the task being edited

    var body: some View {
        VStack(spacing: 15) {
            Text("Workflow To-Do List")
                .font(.title2.bold())
                .padding(.top)

            // Task input field and add button
            HStack {
                TextField("Enter a new task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical)
                    .frame(width: 320)  // Slightly wider

                Button(action: {
                    if !newTask.isEmpty {
                        if editMode, let index = taskToEditIndex {
                            tasks[index] = newTask  // Update the task being edited
                            editMode = false
                            taskToEditIndex = nil
                        } else {
                            tasks.append(newTask)  // Append new task
                        }
                        newTask = ""  // Clear the input field
                    }
                }) {
                    Text(editMode ? "Update" : "Add")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(editMode ? Color.orange : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // List of tasks with delete and edit buttons and drag & drop
            List {
                ForEach(Array(tasks.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Text(task)
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            // Edit the selected task
                            newTask = task
                            editMode = true
                            taskToEditIndex = index
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.orange)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing)

                        Button(action: {
                            // Delete the selected task
                            tasks.remove(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .onMove(perform: moveTask) // Enable drag and drop
            }
            .frame(width: 320, height: 300)
            .cornerRadius(10)

            // Complete workflow button
            Button(action: {
                // Simulate workflow completion
                onComplete()
            }) {
                Text("Start Task")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .frame(width: 370) // Increase total width slightly
    }

    // Function to reorder tasks when dragging
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}
