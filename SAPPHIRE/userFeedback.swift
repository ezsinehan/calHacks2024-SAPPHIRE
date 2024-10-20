import SwiftUI
import AppKit

class UserFeedback: ObservableObject {
    @Published var feedbackMessage: String = "Waiting for task..."
    @Published var feedbackColor: Color = Color.gray
    
    func provideFeedback(isOnTask: Bool, task: String) {
        DispatchQueue.main.async {
            if isOnTask {
                self.feedbackMessage = "User is on Task :)"
                self.feedbackColor = Color.green
            } else {
                self.feedbackMessage = "User is off task :("
                self.feedbackColor = Color.red
                self.playAlertSound(isOnTask: false)
                self.showAlert(isOnTask: false)
            }
        }
    }

    func provideGazeFeedback(isOnTask: Bool) {
        DispatchQueue.main.async {
            if isOnTask {
                self.feedbackMessage = "User is on Task :)"
                self.feedbackColor = Color.green
                self.playAlertSound(isOnTask: true)
                self.showAlert(isOnTask: true)
            } else {
                self.feedbackMessage = "User is distracted :("
                self.feedbackColor = Color.red
                self.playAlertSound(isOnTask: false)
                self.showAlert(isOnTask: false)
            }
        }
    }
    
    func playAlertSound(isOnTask: Bool) {
        DispatchQueue.main.async {
            let soundName = isOnTask ? "Glass" : "Submarine"
            if let sound = NSSound(named: NSSound.Name(soundName)) {
                sound.play()
            } else {
                print("Failed to load sound")
            }
        }
    }
    
    func showAlert(isOnTask: Bool) {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            let alert = NSAlert()

            if isOnTask {
                alert.messageText = "You're on task!"
                alert.informativeText = "Great job, keep it up!"
            } else {
                alert.messageText = "You're distracted!"
                alert.informativeText = "Please focus on screen"
            }

            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
