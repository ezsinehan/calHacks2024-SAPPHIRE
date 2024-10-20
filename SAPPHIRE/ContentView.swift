import SwiftUI

// Circular Toggle style
struct CircularToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Circle()
                .fill(configuration.isOn ? Color.green : Color.gray)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

struct FinishTaskView: View {
    @Binding var isTaskStarted: Bool
    @Binding var isGazeTrackingEnabled: Bool
    @Binding var isScreenProctoringEnabled: Bool
    @Binding var isTaskCompleted: Bool
    @Binding var isTaskSelected: Bool
    @Binding var task: String
    @ObservedObject var screenProctoring: ScreenProctoring // We need this to stop screen proctoring
    @ObservedObject var userFeedback: UserFeedback
    @ObservedObject var GazeTracker: GazeTracker

    var body: some View {
        VStack {
            Text(task)
                .font(.title2)
            Text(userFeedback.feedbackMessage)
                .font(.title)
                .padding()
                .foregroundColor(userFeedback.feedbackColor)
            Button(action: {
                // Stop screen proctoring and gaze tracking if enabled
                if isScreenProctoringEnabled {
                    screenProctoring.stopScreenProctoring()
                    print("stopping screen proctoring")
                }

                if isGazeTrackingEnabled {
                    GazeTracker.stopGazeTracking()
                    print("stopping gaze tracking")
                }
                isScreenProctoringEnabled = false
                isGazeTrackingEnabled = false

                // Reset the task-related states to go back to the task entry page
                isTaskStarted = false
                isTaskSelected = false
                task = ""
                print("Task finished!")
            }) {
                Text("Finish Task")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the screen
    }
}

struct ContentView: View {
    @State private var task: String = "" // The task being input by the user
    @State private var isTaskSelected: Bool = false
    @State private var isTaskStarted: Bool = false
    @State private var isScreenProctoringEnabled: Bool = false
    @State private var isGazeTrackingEnabled: Bool = false
    @State private var isWorkFlowEnabled: Bool = false
    @State private var isTaskCompleted: Bool = false
    @State private var showWorkFlowView: Bool = false // Toggle workflow view
    @State private var showTaskControlView: Bool = false // Toggle task control view

    @State private var tasks: [String] = [] // List of tasks
    @State private var currentTaskIndex: Int = 0 // Index of the current task

    @ObservedObject var screenProctoring = ScreenProctoring()
    @ObservedObject var userFeedback = UserFeedback()
    @State private var gazeTracker = GazeTracker()

    var body: some View {
        if showTaskControlView {
            // Show TaskControlView when the task has started, and pass the tasks and current task index
            TaskControlView(
                tasks: $tasks,
                currentTaskIndex: $currentTaskIndex,
                onPause: {
                    // Add your logic for pausing the task
                    print("Task paused")
                },
                onComplete: {
                    // Handle completion
                    currentTaskIndex += 1
                    if currentTaskIndex >= tasks.count {
                        // All tasks completed
                        isTaskStarted = false
                        showTaskControlView = false
                        isTaskSelected = false
                        task = "" // Reset task
                        tasks = [] // Reset tasks
                        currentTaskIndex = 0
                        print("All tasks completed")

                        // Stop screen proctoring and gaze tracking if enabled
                        if isScreenProctoringEnabled {
                            screenProctoring.stopScreenProctoring()
                            print("stopping screen proctoring")
                        }
                        if isGazeTrackingEnabled {
                            gazeTracker.stopGazeTracking()
                            print("stopping gaze tracking")
                        }
                        // Do not reset isScreenProctoringEnabled and isGazeTrackingEnabled
                        // isScreenProctoringEnabled = false
                        // isGazeTrackingEnabled = false
                    } else {
                        // Update screen proctoring with the new task
                        if isScreenProctoringEnabled {
                            screenProctoring.updateTask(task: tasks[currentTaskIndex])
                        }
                        // Update gaze tracking if needed
                        if isGazeTrackingEnabled {
                            gazeTracker.toggleGazeTracking(true) // Ensure gaze tracking is running
                        }
                    }
                },
                onViewTasks: {
                    // Add logic to view the task list
                    showTaskControlView = false
                    showWorkFlowView = true
                    print("Viewing tasks")
                }
            )
        } else if showWorkFlowView {
            // Show the WorkFlowView when workflow is enabled
            WorkFlowView(onComplete: {
                // Handle workflow completion
                showTaskControlView = true // Show task control after starting the workflow
                // Start screen proctoring and/or gaze tracking with the first task
                startProctoringAndGazeTracking()
            }, tasks: $tasks)
        } else if isTaskStarted {
            // Show FinishTaskView if the task has started
            FinishTaskView(
                isTaskStarted: $isTaskStarted,
                isGazeTrackingEnabled: $isGazeTrackingEnabled,
                isScreenProctoringEnabled: $isScreenProctoringEnabled,
                isTaskCompleted: $isTaskCompleted,
                isTaskSelected: $isTaskSelected,
                task: $task,
                screenProctoring: screenProctoring,
                userFeedback: userFeedback,
                GazeTracker: gazeTracker
            )
        } else {
            // Main screen before task starts
            VStack {
                if !isTaskSelected {
                    Text("What would you like to do?")
                        .font(.title2.bold())
                        .padding()
                    TextField("Enter your task here", text: $task)
                        .frame(width: 450)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        isTaskSelected = true
                    }) {
                        Text("Next")
                            .font(.headline)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(5)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("How Should We Keep You On Task?")
                        .font(.title2)
                        .padding()
                }

                if isTaskSelected {
                    HStack {
                        Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                            .toggleStyle(CircularToggleStyle())
                        Text("Proctor My Screen")
                            .font(.headline)
                            .foregroundColor(isScreenProctoringEnabled ? .green : .gray)
                    }
                    .padding(5)

                    HStack {
                        Toggle("Enable Workflow", isOn: $isWorkFlowEnabled)
                            .toggleStyle(CircularToggleStyle())
                        Text("Enable Workflow")
                            .font(.headline)
                            .foregroundColor(isWorkFlowEnabled ? .green : .gray)
                    }

                    HStack {
                        Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                            .toggleStyle(CircularToggleStyle())
                        Text("Track My Gaze")
                            .font(.headline)
                            .foregroundColor(isGazeTrackingEnabled ? .green : .gray)
                    }

                    if isScreenProctoringEnabled || isGazeTrackingEnabled || isWorkFlowEnabled {
                        Button(action: {
                            // Initialize tasks
                            if isWorkFlowEnabled {
                                // If tasks is empty, initialize with the current task
                                if tasks.isEmpty {
                                    tasks = [task]
                                }
                                currentTaskIndex = 0
                                showWorkFlowView = true
                            } else {
                                tasks = [task]
                                currentTaskIndex = 0
                                showTaskControlView = true
                                // Start screen proctoring and gaze tracking with the single task
                                startProctoringAndGazeTracking()
                            }

                            isTaskStarted = true
                        }) {
                            Text("Start Task")
                                .font(.headline)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }

                    Button(action: {
                        isTaskSelected = false
                        isScreenProctoringEnabled = false
                        isGazeTrackingEnabled = false
                        task = ""
                    }) {
                        Text("Change Task")
                            .font(.headline)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // Helper function to start screen proctoring and gaze tracking
    func startProctoringAndGazeTracking() {
        if isScreenProctoringEnabled {
            screenProctoring.userFeedback = userFeedback
            screenProctoring.startScreenProctoring(task: tasks[currentTaskIndex])
        }
        if isGazeTrackingEnabled {
            gazeTracker.toggleGazeTracking(true)
        }
    }
}
