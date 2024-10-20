import SwiftUI
import Cocoa
import Vision

class ScreenProctoring: ObservableObject {
    @Published var isProctoring = false
    var timer: Timer?
    var userFeedback: UserFeedback?
    var currentTask: String = "" // Add this property

    func captureScreen() -> NSImage? {
        let displayId = CGMainDisplayID()
        let imageRef = CGDisplayCreateImage(displayId)
        
        if let imageRef = imageRef {
            return NSImage(cgImage: imageRef, size: NSSize.zero)
        }
        return nil
    }
    
    func recognizeText(from image: NSImage) {
        // Use self.currentTask instead of passing task as a parameter
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Failed to convert NSImage to CGImage")
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var recognizedTextArray = [String]()
            for observation in observations {
                let topCandidate = observation.topCandidates(1).first
                recognizedTextArray.append(topCandidate?.string ?? "")
            }
            
            // Join recognized text and compare with the task
            let joinedRecognizedText = recognizedTextArray.joined(separator: " ").lowercased()
            let taskWords = self.currentTask.lowercased().split(separator: " ")
            
            let isOnTask = taskWords.contains { word in joinedRecognizedText.contains(word) }
            
            if isOnTask {
                print("User is on task: \(self.currentTask)")
            } else {
                print("User is off task! Recognized: \(joinedRecognizedText)")
            }
            
            self.userFeedback?.provideFeedback(isOnTask: isOnTask, task: self.currentTask)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? requestHandler.perform([request])
    }
    
    func startScreenProctoring(task: String) {
        isProctoring = true
        self.currentTask = task // Set the current task
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if let screenshot = self.captureScreen() {
                self.recognizeText(from: screenshot) // No need to pass task
            }
        }
    }
    
    func updateTask(task: String) {
        self.currentTask = task
        print("ScreenProctoring updated to new task: \(task)")
    }
    
    func stopScreenProctoring() {
        isProctoring = false
        timer?.invalidate()
        timer = nil
    }
}
