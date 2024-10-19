//
//  Task.swift
//  SAPPHIRE
//
//  Created by Avash Adhikari on 10/18/24.
//

import Foundation
import SwiftData

@Model
final class Task {
    
    // Enum for task status
    enum TaskStatus: String {
        case notStarted
        case inProgress
        case completed
    }
    
    var name: String
    var date: Date
    var startTime: Date?
    var endTime: Date?
    var timesOffTask: [Int: String] = [:]
    var taskDuration: TimeInterval?
    
    // Change the `status` to store as a String
    var statusRawValue: String

    // Computed property to access TaskStatus enum
    var status: TaskStatus {
        get {
            return TaskStatus(rawValue: statusRawValue) ?? .notStarted
        }
        set {
            statusRawValue = newValue.rawValue
        }
    }
    
    // Initializer
    init(name: String,
         startTime: Date? = nil,
         endTime: Date? = nil,
         timesOffTask: [Int: String] = [:],
         taskDuration: TimeInterval? = nil,
         status: TaskStatus = .notStarted) {
        
        self.name = name
        self.date = Date()
        self.startTime = startTime
        self.endTime = endTime
        self.timesOffTask = timesOffTask
        self.taskDuration = taskDuration
        self.statusRawValue = status.rawValue // Store as string
    }
    
    // Start the task
    func startTask() {
        self.status = .inProgress
        self.startTime = Date()
    }
    
    // End the task and calculate duration
    func endTask() {
        self.status = .completed
        self.endTime = Date()
        
        if let start = self.startTime, let end = self.endTime {
            self.taskDuration = end.timeIntervalSince(start)
        }
    }
}
