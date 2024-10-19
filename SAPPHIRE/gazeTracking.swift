import SwiftUI
import AVFoundation
import Vision
import Cocoa

class GazeTracker: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
        let captureSession = AVCaptureSession()
        var videoInput: AVCaptureDeviceInput?
        var videoOutput: AVCaptureVideoDataOutput?
    @Published var isTrackingEnabled: Bool = false {
        didSet {
            toggleGazeTracking(isTrackingEnabled)
        }
    }

    override init() {
        super.init()
    }
    
    // Function to toggle gaze tracking on/off
    func toggleGazeTracking(_ enable: Bool) {
        if enable {
            requestCameraPermission { granted in
                if granted {
                    self.startGazeTracking()
                } else {
                    self.showAlert(message: "Camera access is required to enable gaze tracking.")
                    DispatchQueue.main.async {
                        self.isTrackingEnabled = false // Reset toggle if permission denied
                    }
                }
            }
        } else {
            stopGazeTracking()
        }
    }

    // Request camera permission
        func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    // Start gaze tracking
        func startGazeTracking() {
        guard !captureSession.isRunning else { return }

        setupCameraSession()
        captureSession.startRunning()
        DispatchQueue.main.async {
            self.isTrackingEnabled = true // Ensure the toggle reflects the state
        }
        print("Gaze tracking started")
    }

    // Stop gaze tracking
        func stopGazeTracking() {
        guard captureSession.isRunning else { return }

        // Stop the capture session
        captureSession.stopRunning()

        // Remove inputs and outputs to release resources
        if let input = videoInput {
            captureSession.removeInput(input)
        }
        if let output = videoOutput {
            captureSession.removeOutput(output)
        }

        videoInput = nil
        videoOutput = nil

        DispatchQueue.main.async {
            self.isTrackingEnabled = false // Ensure the toggle reflects the state
        }
        print("Gaze tracking stopped and camera session reset")
    }

    // Set up the camera for live video capture
        func setupCameraSession() {
        captureSession.sessionPreset = .high

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(message: "No camera available")
            return
        }

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showAlert(message: "Error accessing camera: \(error.localizedDescription)")
            return
        }

        // Add video input to the capture session
        if let videoInput = videoInput, captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showAlert(message: "Couldn't add camera input.")
            return
        }

        // Set up video output
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            showAlert(message: "Couldn't add camera output.")
            return
        }
    }

    // Capture frames from the camera
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        detectFaceLandmarks(in: pixelBuffer)
    }

    // Use Vision framework to detect face landmarks (eyes and nose)
        func detectFaceLandmarks(in pixelBuffer: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { (request, error) in
            guard let observations = request.results as? [VNFaceObservation] else { return }
            
            var eyesDetected = false
            var noseDetected = false

            for faceObservation in observations {
                if let landmarks = faceObservation.landmarks {
                    // Check for eyes
                    if landmarks.leftEye != nil && landmarks.rightEye != nil {
                        eyesDetected = true
                    }

                    // Check for nose
                    if landmarks.nose != nil {
                        noseDetected = true
                    }
                }
            }

            // Print results
            if eyesDetected {
                print("Eyes detected!")
            } else {
                print("Eyes not detected")
            }

            if noseDetected {
                print("Nose detected!")
            } else {
                print("Nose not detected")
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([faceDetectionRequest])
        } catch {
            print("Error performing face detection: \(error)")
        }
    }

    // Show an alert with the given message
        func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = message
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}

