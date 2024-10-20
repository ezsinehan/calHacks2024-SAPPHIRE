***SAPPHIRE***



# MVP -> Mac app to improve user productivity
- [x] Track the user’s screen content and compare it to a predefined task
- [x] Detect if the user is looking away from the screen using the camera.
- [x] Provide feedback through pop-ups and beeps when the user is distracted.

# User Flow
1) Opens/runs app
2) Text prompt where user can enter task(s)
3) Once user enters task, they can select which features to enable
4) User able to enable/disable featuers for app
5) Once features are picked app goes away
6) If user is "off task" user gets alerted through sound or screen dimming
7) User can go back to app to end task once they finish
8) Start new task

# Tech Stack ->
Language - Swift
UI/Frontend - SwiftUI
Data - SwiftData


# Collaboration 
- [ ] With collaboration having clear documentation is good practice
- [ ] **Documentation**
    - [ ] **Architecture**
        - [ ] Screen tracking
        - [ ] Gaze tracking
        - [ ] Notifications
    - [ ] **How to Run Project?**
        - [ ] Environment
        - [ ] Dependencies
        - [ ] How to Build/Run?
    - [ ] **Contributing Guidelines**
        - [ ] Coding standards
        - [ ] Feature branches
        - [ ] How to submit changes via pull requests

# Milestones
- [ ] Task Input Interface: Build the interface where users can input tasks and define what they need to focus on.
- [ ] Screen Monitoring: Set up the functionality to track and compare the screen with the task.
- [ ] Camera Monitoring: Implement camera-based monitoring to detect if the user is looking at the screen.
- [ ] User Feedback Mechanism: Develop the pop-up and beep notifications based on the results of the screen and camera tracking.

# Documentation
## Important Information for Devs 
***CAUTION*** The Google Al SDK for Swift is recommended for prototyping only. If you plan to enable billing, we strongly recommend that you use a backend SDK to access the Google Al Gemini API. You risk potentially exposing your API key to malicious actors if you embed your API key directly in your Swift app or fetch it remotely at runtime.
## Data Models:
### Task 
Task will be used to model a task that a user can do. Task has the following properties:
 - name: string
 - date: date
 - startTime: date
 - endTime: date
 - timesOffTask: dictionary where key is 1 based index of the number of times user has been off task. key is string for now but it will be the reason they are off task
 - taskDuration: TimeInterval
 - status: value from the enum TaskStatus in the Task.swift file

#### Methods:
 - Creating a new task:
 `let newTask = Task(name: "someName")`

## Application architecture
### Screen tracking
### Gaze tracking
### Notifications

## How to run project
### Environment
### Dependencies
 - SwiftData
### How to build/run?

## Contributing Guidelines:
### Coding Standards
 - Camel case variable/function names:
     - exampleFunctionName; exampleVariable
 - Descriptive variable names
 - Small commits
 - New branch for every feature 

### Branching Standards
#### 1. Main branch (main): 
* This branch should only contain stable, working code, Production-Ready Code. You’ll merge feature branches into main once those features are fully developed and tested.
#### 2. Feature Branches
* Create separate branches for each core feature. Each branch focuses on developing one part of the project:

    1. Task Tracker(**ex. featureTaskTracker**)
    2. Screen Tracking Branch(**featureScreenProctoring**)
    3. Camera Monitoring Branch(**featureGazeTracking**)
    4. User Feedback Branch(**branch name**)
    5. ~~Data Model Branch(**dataModelling)~~
    6. etc

# TASKS:
### Sinehan:
- [x] Setting up Git Repo *(10/8 535PM - 622PM)*
- [x] Starting featureTaskTracker *(626PM - 815PM)*
- [x] Setup Task Split *(815PM - 1033)*
- [x] Working on featureScreenProctoring ~~(1045 - )~~
- [x] Work on locating whether user is on task(SIMPLE)
- [x] Work on basic user feedback
- [ ] Attach screen reader to AI API
- [ ] Option for native notification alerts
- [ ] Option for super annoying
- [ ] 
---
### Avash:
 - [x] User Flow *(10/8 5:40 - 5:53)*
 - [x] Basic Wireframing *(10/8 5:54 - 6)*
 - [x] Data Modelling *(10/8 6:26 - 8:12)
 - [x] ~~Gaze tracking *(10/8 10:47 - )~~
 - [x] Create ui/ux branch
 - [x] Fix task input ui
 - [x] give user ability to return back to task input
 - [x] give user ability to complete task
 - [x] Shrink task bar width on first screen
 - [x] Add more space between "change task button" and rest of screen
 - [x] Make "start task" activate when clicked 
 - [x] Make camera stop on finish task
 - [ ] Only corresponding feedback
 - [ ] make task list
 - [ ] enter to add new task on first screen
 - [ ] 
---
### Neil:
10/18
- [x] Fix Buttons (11:15 PM - )
- [x] put gaze/proctor button to toggle (12 AM - 3:27 AM)
- [x] ~~Add back button from second screen to first screen (11:15 PM - )~~ 
- [ ] ~~Separate code into files (11:24 - )~~

10/19 AM
- [x] Create branch
- [x] Gaze tracking 
    - [x] First gain access to camera permissions
    - [ ] ~~Return web cameraimage~~
    - [x] Returns Eyes Detected, and Nose Detected
    - [x] Returns Eyes Not Detected, and Nose Not Detected 
    - [x] Toggle Camera on and off
    - [x] Prints detection every 5 seconds

10/19 PM
- [x] Fix gaze Tracker to be more accurate
    - [x] change from checking current state every 5 seconds -> if looking away for 5 seconds then send alert (10:17 PM - 3:07 AM) 
    - [x] specifically, looking to the left or right should be off task (9:30 PM -10:17 PM)
    - [ ] 


### Avash:
- [x] gaze tracking should only work when start task is clicked
- [x] implement user feedback for gaze tracking

         


# Wireframe:
![Screenshot 2024-10-18 at 6.15.42 PM](https://hackmd.io/_uploads/S1i__Kee1e.png)

# Future
 - [ ] task list
 - [ ] quick shortcut to end task, start new task
 - [ ] settings where you can enable disable settings mid session
 - [ ] personal stats:
     - sessions completed, avg time per task, # of times off task! 


Hang Risk
/Users/avashadhikari/Projects/SAPPHIRE/SAPPHIRE/gazeTracking.swift:205 [Internal] Thread running at User-interactive quality-of-service class waiting on a lower QoS thread running at Default quality-of-service class. Investigate ways to avoid priority inversions
