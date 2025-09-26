# ClipBoard Done - macOS Clipboard History App

A native macOS clipboard history app that monitors your clipboard and provides easy access to previously copied items through a menu bar interface and global keyboard shortcuts.

## Features

- 🔄 **Automatic Clipboard Monitoring**: Automatically detects and stores clipboard changes
- ⌨️ **Global Keyboard Shortcut**: Press `Cmd+Shift+V` to quickly access clipboard history
- 📋 **Menu Bar Integration**: Clean menu bar interface that doesn't clutter your dock
- 🔍 **Search Functionality**: Quickly find specific clipboard items with built-in search
- 🗑️ **Easy Management**: Delete individual items or clear entire history
- 💾 **History Limit**: Keeps the last 50 clipboard items to optimize performance
- ⏱️ **Timestamps**: Shows when each item was copied with relative time display

## Installation & Setup

1. **Build the App**: Open the project in Xcode and build for macOS
2. **Grant Permissions**: 
   - The app will request accessibility permissions on first launch
   - Go to System Preferences > Security & Privacy > Privacy > Accessibility
   - Add and enable your built app

3. **Launch**: The app will appear in your menu bar with a clipboard icon

## Usage

### Accessing Clipboard History
- **Menu Bar**: Click the clipboard icon in your menu bar
- **Global Shortcut**: Press `Cmd+Shift+V` anywhere on your system

### Using the Interface
- **Copy Item**: Click on any item in the list to copy it to your clipboard
- **Search**: Type in the search box to filter clipboard items
- **Delete**: Hover over items to see the delete button
- **Clear All**: Click the trash icon in the header to clear all history

### Keyboard Navigation
- Use arrow keys to navigate through items
- Press Enter to copy the selected item
- Press Escape to close the menu

## Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MenuBarExtra**: Native menu bar integration (macOS 13+)
- **NSPasteboard**: System clipboard monitoring
- **Carbon Events**: Global hotkey registration
- **Timer-based Monitoring**: Efficient clipboard change detection

### Privacy & Security
- All clipboard data stays local on your machine
- No network connections or data transmission
- Respects system privacy settings
- Requires explicit accessibility permissions

### Performance
- Lightweight background monitoring
- Efficient memory usage with history limits
- Optimized UI updates with ObservableObject pattern

## System Requirements

- macOS 13.0 or later (for MenuBarExtra support)
- Xcode 14.0 or later (for building)

## Permissions Required

- **Accessibility**: For global keyboard shortcuts and system-wide clipboard monitoring
- **Apple Events**: For hotkey registration (automatically handled)

## Customization

You can modify the following in the code:

- **History Limit**: Change the limit in `ClipboardManager.swift` (currently 50 items)
- **Monitoring Interval**: Adjust the timer interval in `ClipboardManager.swift` (currently 0.5 seconds)
- **Global Shortcut**: Modify the key combination in `GlobalHotkeyManager.swift` (currently Cmd+Shift+V)
- **Window Size**: Adjust dimensions in `ClipBoardDoneApp.swift` (currently 400x500)

## Troubleshooting

### Global Shortcut Not Working
1. Check if accessibility permissions are granted
2. Restart the app after granting permissions
3. Ensure no other apps are using the same shortcut

### Clipboard Not Updating
1. Verify the app is running (check menu bar)
2. Grant accessibility permissions if prompted
3. Check Activity Monitor to ensure the app process is active

### App Not Appearing in Menu Bar
1. Ensure the app is built for the correct macOS version
2. Check that LSUIElement is set to true in Info.plist
3. Restart the app or log out/log in

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve the app.

## License

This project is open source. Please check the license file for details.