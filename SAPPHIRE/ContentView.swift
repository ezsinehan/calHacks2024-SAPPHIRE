//
//  ContentView.swift
//  SAPPHIRE
//
//  Created by EZ on 10/18/24.
//

import SwiftUI

//Shnoz circle Toggle style
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
    @ObservedObject var userFeedback = UserFeedback()
    

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
            }.buttonStyle(PlainButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the screen
        //.background(Color.black) // Change background color if needed
    }
}

struct ContentView: View {
    @State private var task: String = ""
    @State private var isTaskSelected: Bool = false
    @State private var isTaskStarted: Bool = false
    @State private var isScreenProctoringEnabled: Bool = false
    @State private var isGazeTrackingEnabled: Bool = false
    @State private var isTaskCompleted: Bool = false
    
    @ObservedObject var screenProctoring = ScreenProctoring()
    @ObservedObject var userFeedback = UserFeedback()
  
    let gazeTracker = GazeTracker()

    
    var body: some View {
        // Check if task is started or not to simulate navigation
        if isTaskStarted {
            FinishTaskView(isTaskStarted: $isTaskStarted,
                           isGazeTrackingEnabled: $isGazeTrackingEnabled,
                           isScreenProctoringEnabled: $isScreenProctoringEnabled,
                           isTaskCompleted: $isTaskCompleted,
                           isTaskSelected: $isTaskSelected,
                           task: $task,
                           screenProctoring: screenProctoring) // Pass screenProctoring to stop it
        } else {
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
                    }.buttonStyle(PlainButtonStyle())
                } else {
                    Text("How Should We Keep You On Task?")
                        .font(.title2)
                        .padding()
                    
                }
                
                
                if isTaskSelected{
                    HStack {
                        Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                            .toggleStyle(CircularToggleStyle())
                            .onChange(of: isScreenProctoringEnabled) {
                                
                            }
                        Text("Proctor My Screen")
                            .font(.headline)
                            .foregroundColor(isScreenProctoringEnabled ? .green : .gray)
                    }
                    
                    .padding(5)
                    
//                    if isScreenProctoringEnabled || isGazeTrackingEnabled {
//                        
//                    }
                    
                    // Shnoz changed to toggle
                    HStack{
                        Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                            .toggleStyle(CircularToggleStyle())
                            .onChange(of: isGazeTrackingEnabled){
                                
                                gazeTracker.toggleGazeTracking(isGazeTrackingEnabled) //Shnoz made turned camera on and off on toggle
                                
                            }
                        Text("Track My Gaze")
                            .font(.headline)
                            .foregroundColor(isGazeTrackingEnabled ? .green : .gray)
                    }
                    if isScreenProctoringEnabled || isGazeTrackingEnabled {
                        Button(action: {
                            isTaskStarted = true
                            if isScreenProctoringEnabled {
                                screenProctoring.userFeedback = userFeedback
                                screenProctoring.startScreenProctoring(task: task)
                            } else {
                                screenProctoring.stopScreenProctoring()
                            }
                            print(task)
                        }) {
                            Text("Start Task")
                                .font(.headline)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }.buttonStyle(PlainButtonStyle())
                       
                }
                    // Back button to go back to task input screen
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
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

