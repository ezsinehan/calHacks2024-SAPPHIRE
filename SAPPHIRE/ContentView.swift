//
//  ContentView.swift
//  SAPPHIRE
//
//  Created by EZ on 10/18/24.
//
import SwiftUI


struct ContentView: View {
    @State private var task: String=""
    @State private var isTaskSelected: Bool = false
    @State private var isScreenProctoringEnabled: Bool = false
    @State private var isGazeTrackingEnabled: Bool = false
    
    @ObservedObject var screenProctoring = ScreenProctoring()
    
    var body: some View {
        VStack {
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
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
        } else {
            Text("How Should We Keep You On Task?")
                .font(.title2)
                .padding()
            
            VStack {
                Button(action: {
                    isScreenProctoringEnabled.toggle()
                    if isScreenProctoringEnabled {
                        screenProctoring.startScreenProctoring()
                    } else {
                        screenProctoring.stopScreenProctoring()
                    }
                }) {
                    Text("Proctor My Screen")
                        .padding()
                        .background(isScreenProctoringEnabled ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isGazeTrackingEnabled.toggle()
                }) {
                    Text("Track my Gaze")
                        .padding()
                        .background(isGazeTrackingEnabled ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            if isScreenProctoringEnabled || isGazeTrackingEnabled {
                if isScreenProctoringEnabled {
                    Text("Screen Proctoring On.")
                        .font(.headline)
                }
                
                if isGazeTrackingEnabled {
                    Text("Gaze Tracking On.")
                        .font(.headline)
                }
                
                Button(action: {
                    // TBD
                }) {
                    Text("Start Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        }
        .padding()
    }
}
