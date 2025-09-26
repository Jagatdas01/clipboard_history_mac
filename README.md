# ClipBoardDone

Lightweight macOS clipboard history utility (single menu bar diamond icon + global hotkey) written in Swift (SwiftUI + AppKit interop).

<div align="center">
  <img src="clip Exports/clip-macOS-Default-1024x1024@1x.png" alt="ClipBoardDone Icon" width="120" height="120" />
  <br/>
  <sub>Application Icon</sub>
</div>

## ✨ Features
| Area | Description |
|------|-------------|
| Clipboard Monitoring | Polls the system pasteboard every 0.5s and stores newest unique plain‑text entries (max 50) |
| Global Hotkey | `⌘⇧V` toggles the floating history window anywhere |
| Menu Bar | Single diamond icon with menu actions: Show/Hide, Clear History, Quit |
| Re‑use | Click an item to copy it again (it jumps to the top) |
| De‑duplication | New copy removes earlier duplicate before inserting at top |
| Manual Management | Delete individual rows (via UI) or Clear All from menu |

## 🗂 Project Layout
```
ClipBoardDoneApp.swift   # App entry, NSStatusItem, window management
ClipboardManager.swift   # Clipboard polling & history logic
ContentView.swift        # SwiftUI list UI for history
GlobalHotkeyManager.swift# Carbon-based global hotkey (⌘⇧V)
```

## 🖼 App Icon
The icon above is stored at `assets/clip.png`. Replace with a higher resolution variant anytime (keep the same path) and GitHub will update automatically.

## 🚀 Build & Run
1. Open the folder in Xcode.
2. Build & Run (Debug is fine).
3. A diamond icon (or ◆ fallback) appears in the menu bar.
4. Press `⌘⇧V` to toggle the history window.

## 🔑 Permissions
For reliable global hotkey & pasteboard access you may need to grant Accessibility permission:
System Settings → Privacy & Security → Accessibility → + (add the built app) → enable.

## 🧰 Usage
Menu (diamond icon):
- Show / Hide Clipboard
- Clear History (clears only in‑memory list, not current system clipboard)
- Quit

Window:
- Shows most recent first (top = latest)
- Click to copy
- Items beyond 50 drop off automatically

## ⚙️ Configuration Points
File `ClipboardManager.swift`:
- History cap: change `if self.clipboardHistory.count > 50 { ... }`
- Poll interval: adjust `Timer.scheduledTimer(... interval: 0.5 ...)`

File `GlobalHotkeyManager.swift`:
- Modify key codes / modifiers for a different global shortcut.

File `ClipBoardDoneApp.swift`:
- Window size / position logic inside `showWindow()`.
- Menu structure inside `setupStatusItem()`.

## 🧹 Clearing History
Use Menu Bar → Clear History. This empties the UI list immediately. (Does not blank the system clipboard; last copied content remains available to other apps.)

## 🧪 Troubleshooting
| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| No diamond icon | Old build or multiple instances | Kill extras: `pkill -f ClipBoardDone` then relaunch |
| Hotkey inactive | No accessibility permission / shortcut conflict | Grant permission, check other tools (Raycast, Alfred, etc.) |
| Some copies missing | Non‑text (images, files) not yet supported | Add future support for UTIs beyond public.utf8-plain-text |
| History resets on relaunch | No persistence implemented | Add disk persistence (see Roadmap) |

## 🔒 Privacy
All clipboard text stays local in memory; nothing is written to disk or sent over network.

## 🛣 Roadmap (Ideas)
- Disk persistence (load previous session)
- Search/filter bar
- Pin / favorite clips
- Image & rich text support
- Exclusion rules (length / regex / secret detection)
- Export / import history

## 🛠 Contributing
Open to suggestions and lightweight PRs. Keep changes focused and small.

## 📄 License
Add a LICENSE file (MIT recommended) before distributing externally.

---
Need another enhancement (persistence, search, pinning)? Open an issue or request it.
