//
//  Task.swift
//  SAPPHIRE
//
//  Created by Avash Adhikari on 10/18/24.
//


/*
 this is the data model for a task
 every task has a name, data, start time, end time, a dictionary of the times off task,
 task duration, and task status
 */
import Foundation
import SwiftData

@Model
final class Task{
    
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
        var status: TaskStatus
        
    
    init(name: String,
         date: Date,
         startTime: Date? = nil,
         endTime: Date? = nil,
         timesOffTask: [Int: String] = [:],
         taskDuration: TimeInterval? = nil
        ) {
        
        self.name = name
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.timesOffTask = timesOffTask
        self.taskDuration = taskDuration
        self.status = .notStarted
    }
    
    
    func startTask() {
        self.status = .inProgress
        self.startTime = Date()
    }
    
    func endTask() {
        self.status = .completed
        self.endTime = Date()
        
        if let start = self.startTime, let end = self.endTime {
            let duration = end.timeIntervalSince(start)
            self.taskDuration = duration
        }
    }
}
