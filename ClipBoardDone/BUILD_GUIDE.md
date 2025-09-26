# Build & Deployment Guide for ClipBoard Done

## 📋 Prerequisites

Before building, ensure you have:
- Xcode 14.0 or later installed
- macOS 13.0+ (for MenuBarExtra support)
- Valid Apple Developer account (for code signing)

## 🔨 Building the App

### Step 1: Open in Xcode
1. Navigate to your project folder: `/Users/KXD387/Documents/Code/Clipboard/ClipBoardDone/`
2. Look for `ClipBoardDone.xcodeproj` or create one if it doesn't exist
3. Double-click to open in Xcode

### Step 2: Configure Project Settings
In Xcode, configure these settings:

**Target Settings:**
- **Deployment Target**: macOS 13.0
- **Bundle Identifier**: `com.yourname.clipboarddone` (use your own identifier)
- **Team**: Select your Apple Developer Team
- **Code Signing**: Automatic or Manual

**Capabilities:**
- Enable "App Sandbox" = NO (or configure for clipboard access)
- Enable "Hardened Runtime"

### Step 3: Add Files to Xcode Project
Ensure all these files are in your Xcode project:
- ✅ ClipBoardDoneApp.swift
- ✅ ContentView.swift  
- ✅ ClipboardManager.swift
- ✅ GlobalHotkeyManager.swift
- ✅ AppState.swift
- ✅ Assets.xcassets (with app icons)
- ✅ Info.plist
- ✅ ClipBoardDone.entitlements

### Step 4: Build Configuration
1. Select your target in Xcode
2. Choose "Any Mac" or your specific Mac
3. Build Configuration: **Release** (for final build)

### Step 5: Build the App
**Option A - Archive Build (Recommended for Distribution):**
```
Product → Archive
```

**Option B - Direct Build:**
```
Product → Build (⌘B)
```

## 📦 Creating Distribution Build

### For Personal Use:
1. **Archive the App**: `Product → Archive`
2. **Export App**: Choose "Export as macOS App"
3. **Select Distribution**: Choose "Copy App"
4. **Save Location**: Choose where to save (e.g., Desktop)

### For App Store:
1. **Archive**: `Product → Archive`
2. **Distribute**: Choose "App Store Connect"
3. Follow the submission process

### For Direct Distribution:
1. **Archive**: `Product → Archive`
2. **Export**: Choose "Developer ID"
3. **Notarize**: Submit for notarization (required for Gatekeeper)

## 🚀 Installing & Running

### Method 1: Direct Run from Xcode
1. Press ⌘R to run
2. App appears in menu bar
3. Grant permissions when prompted

### Method 2: Install Built App
1. Locate the built `.app` file
2. Copy to `/Applications/` folder
3. Double-click to launch

## ⚙️ Post-Installation Setup

### Required Permissions:
The app will request these permissions on first launch:

1. **Accessibility Permission**:
   - System Preferences → Security & Privacy → Privacy → Accessibility
   - Add "ClipBoard Done" and enable it
   - **Required for**: Global hotkey (⌘⇧V) to work

2. **Full Disk Access** (if needed):
   - System Preferences → Security & Privacy → Privacy → Full Disk Access
   - Add "ClipBoard Done" if clipboard monitoring doesn't work

### Launch at Startup (Optional):
1. System Preferences → Users & Groups → Login Items
2. Add "ClipBoard Done" to launch automatically

## 🎯 Using the App

### Basic Usage:
1. **Menu Bar Access**: Click clipboard icon in menu bar
2. **Global Hotkey**: Press `⌘⇧V` anywhere to open clipboard history
3. **Copy Items**: Click any item to copy it to clipboard
4. **Delete Items**: Hover over items and click trash icon
5. **Clear All**: Click trash icon in header

### Features:
- ✅ Automatic clipboard monitoring
- ✅ Stores last 50 copied items
- ✅ Global keyboard shortcut (⌘⇧V)
- ✅ Search and browse history
- ✅ Menu bar integration
- ✅ No dock icon (menu bar only)

## 🔧 Troubleshooting

### App Won't Launch:
- Check macOS version (requires 13.0+)
- Verify code signing
- Check Gatekeeper settings

### Global Hotkey Not Working:
- Grant Accessibility permissions
- Restart app after granting permissions
- Check for conflicting hotkeys

### Clipboard Not Updating:
- Grant necessary permissions
- Check if app is running (menu bar icon)
- Restart the app

### Build Errors:
- Update Xcode to latest version
- Clean build folder: `Product → Clean Build Folder`
- Reset derived data: `Xcode → Preferences → Locations → Derived Data`

## 📝 Terminal Commands for Advanced Users

### Build from Command Line:
```bash
cd /Users/KXD387/Documents/Code/Clipboard/ClipBoardDone/
xcodebuild -project ClipBoardDone.xcodeproj -scheme ClipBoardDone -configuration Release build
```

### Create Archive:
```bash
xcodebuild -project ClipBoardDone.xcodeproj -scheme ClipBoardDone -configuration Release archive -archivePath ./build/ClipBoardDone.xcarchive
```

### Export App:
```bash
xcodebuild -exportArchive -archivePath ./build/ClipBoardDone.xcarchive -exportPath ./build/ -exportOptionsPlist ExportOptions.plist
```

## 🎉 Success!

Once built and installed:
1. Look for clipboard icon in menu bar
2. Copy some text to test
3. Press `⌘⇧V` to see clipboard history
4. Enjoy your new clipboard manager!

## 📧 Support

If you encounter issues:
1. Check console logs in Console.app
2. Verify all permissions are granted
3. Ensure macOS version compatibility
4. Try rebuilding with clean build folder