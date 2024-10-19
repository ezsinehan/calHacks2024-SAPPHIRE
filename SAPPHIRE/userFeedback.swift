//
//  userFeedback.swift
//  SAPPHIRE
//
//  Created by EZ on 10/19/24.
//

import SwiftUI
import AppKit

class UserFeedback: ObservableObject {
    @Published var feedbackMessage: String = "Waiting for task..."
    @Published var feedbackColor: Color = Color.gray
    
    
    func provideFeedback(isOnTask: Bool, task: String) {
        if isOnTask {
            feedbackMessage = "User is on Task :)"
            feedbackColor = Color.green
//            playAlertSound(isOnTask: true)
//            showAlert(isOnTask: true)
        } else {
            feedbackMessage = "User is off task :("
            feedbackColor = Color.red
            playAlertSound(isOnTask: false)
            showAlert(isOnTask: false)
        }
    }
    
    func playAlertSound(isOnTask: Bool) {
        let soundName = isOnTask ? "Glass" : "Submarine"
        
        if let sound = NSSound(named: NSSound.Name(soundName)) {
            sound.play()
        } else {
            print("Failed to load sound")
        }
    }
    
    func showAlert(isOnTask: Bool) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        
        if isOnTask {
            alert.messageText = "You're on task!"
            alert.informativeText = "Great job, keep it up!"
        } else {
            alert.messageText = "You're off task!"
            alert.informativeText = "Please redirect on the task at hand"
        }
        
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
