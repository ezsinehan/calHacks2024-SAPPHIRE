//
//  screenProctoring.swift
//  SAPPHIRE
//
//  Created by EZ on 10/18/24.
//

import SwiftUI
import Cocoa
import Vision


class ScreenProctoring: ObservableObject {
    @Published var isProctoring = false
    var timer: Timer?
    
    var userFeedback: UserFeedback?
    
    func captureScreen() -> NSImage? {
        let displayId = CGMainDisplayID() //display id of main screen
        let imageRef = CGDisplayCreateImage(displayId) //capturing screen as image ref
        
        if let imageRef = imageRef {
            return NSImage(cgImage: imageRef, size: NSSize.zero) // conver image ref to NSImage
        }
        return nil
    }
    
    func recognizeText(from image: NSImage, task: String) {
        // Convert NSImage to CGImage
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
            
            // Example: Join recognized text and compare with the task
            let joinedRecognizedText = recognizedTextArray.joined(separator: " ").lowercased()
            let taskWords = task.lowercased().split(separator: " ")
            
            let isOnTask = taskWords.contains { word in joinedRecognizedText.contains(word)}
            
            
            if isOnTask {
                print("User is on task: \(task)")
            } else {
                print("User is off task! Recognized: \(joinedRecognizedText)")
            }
            
            self.userFeedback?.provideFeedback(isOnTask: isOnTask, task: task)
            
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? requestHandler.perform([request])
    }
    
    func startScreenProctoring(task: String) {
        isProctoring = true
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if let screenshot = self.captureScreen() {
                self.recognizeText(from: screenshot, task: task)
            }
        }
    }
    
    func stopScreenProctoring() {
        isProctoring = false
        timer?.invalidate()
        timer = nil
    }
}
