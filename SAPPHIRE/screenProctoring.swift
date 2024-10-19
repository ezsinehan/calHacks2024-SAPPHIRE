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
    
    func captureScreen() -> NSImage? {
        let displayId = CGMainDisplayID() //display id of main screen
        let imageRef = CGDisplayCreateImage(displayId) //capturing screen as image ref
        
        if let imageRef = imageRef {
            return NSImage(cgImage: imageRef, size: NSSize.zero) // conver image ref to NSImage
        }
        return nil
    }
    
    func recognizeText(from image: NSImage) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string}
            print(recognizedText)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? requestHandler.perform([request])
    }
    
    func startScreenProctoring() {
        isProctoring = true
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            if let screenshot = self.captureScreen() {
                self.recognizeText(from: screenshot)
            }
        }
    }
    
    func stopScreenProctoring() {
        isProctoring = false
        timer?.invalidate()
        timer = nil
    }
}
