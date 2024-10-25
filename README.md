# ***SAPPHIRE***
Sapphire keeps you on task by watching your screen and tracking your gaze. If you drift, it snaps you back with alerts. Built entirely in Swift with Apple’s Vision API, Sapphire runs locally—no data leaves your machine. Made at CalHacks 11.0 to keep you focused, distraction-free.

*Devpost link ->* https://devpost.com/software/sapphire-rj8f10



## **FEATURES**
- [x] Track the user’s screen content and compare it to a predefined task
- [x] Detect if the user is looking away from the screen using the camera.
- [x] Provide feedback through pop-ups and beeps when the user is distracted.

### **User Flow**
1) Opens/runs app
2) Text prompt where user can enter task(s)
3) Once user enters task, they can select which features to enable
4) User able to enable/disable featuers for app
5) Once features are picked app goes away
6) If user is "off task" user gets alerted through sound or screen dimming
7) User can go back to app to end task once they finish
8) Start new task

## TO RUN
### To Run

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/ezsinehan/calHacks2024-SAPPHIRE.git
   cd calHacks2024-SAPPHIRE
   ```

2. **Open in Xcode**  
   - Open `SAPPHIRE.xcodeproj` in Xcode.

3. **Run the App**  
   - Select a target device (Mac or Simulator) and press **Run** (or `Cmd+R`).
   - If issues, clean build(`Cmd+Shift+K`)

4. **Permissions**  
   - Allow any permissions that **SAPPHIRE** requests on the first run.
   - *If you modify the code, delete the app from your device and re-run it to re-allow permissions.*
