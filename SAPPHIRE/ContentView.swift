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

struct ToggleButtonView: View {
    @Binding var isScreenProctoringEnabled: Bool
    @Binding var isGazeTrackingEnabled: Bool

    var body: some View {
        VStack(spacing: 15) {
            Text("How Should We Keep You On Task?")
                .font(.title2)

            Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                .toggleStyle(CircularToggleStyle())

            Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                .toggleStyle(CircularToggleStyle())
        }
    }
}

struct ContentView: View {
    @State private var task: String = ""
    @State private var isTaskSelected: Bool = false
    @State private var isTaskStarted: Bool = false
    @State private var isScreenProctoringEnabled: Bool = false
    @State private var isGazeTrackingEnabled: Bool = false

    @ObservedObject var screenProctoring = ScreenProctoring()
    @ObservedObject var userFeedback = UserFeedback()


    var body: some View {
        VStack {
            Text(userFeedback.feedbackMessage)
                .font(.title)
                .padding()
                .foregroundColor(userFeedback.feedbackColor)
            
            if !isTaskSelected {
                Text("Enter your task")
                    .font(.title)
                    .padding()

                TextField("Enter your task here", text: $task)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    isTaskSelected = true
                }) {
                    Text("Next")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal,10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
            }.buttonStyle(PlainButtonStyle())
            } else {
                Text("How Should We Keep You On Task?")
                    .font(.title2)
                    .padding()

                // Shnoz changed buttons to toggle
                HStack{
                    Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                        .toggleStyle(CircularToggleStyle())
                        .onChange(of: isScreenProctoringEnabled) {
                            if isScreenProctoringEnabled {
                                screenProctoring.userFeedback = userFeedback
                                screenProctoring.startScreenProctoring(task: task)
                                
                            } else {
                                screenProctoring.stopScreenProctoring()
                            }
                        }
                    Text("Proctor My Screen")
                        .font(.headline)
                        .foregroundColor(isScreenProctoringEnabled ? .green : .gray)
                }

                // shnoz changed to toggle
                HStack{
                    Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                        .toggleStyle(CircularToggleStyle())
                    Text("Track My Gaze")
                        .font(.headline)
                        .foregroundColor(isGazeTrackingEnabled ? .green : .gray)
                }
                if isScreenProctoringEnabled || isGazeTrackingEnabled {
                                    Button(action: {
                                        isTaskStarted = true
                                        print(task)
                                    }) {
                                        Text("Start Task")
                                            .font(.headline)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal,10)
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
                                        .padding(.horizontal,10)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 3)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
