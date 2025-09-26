//
//  ClipBoardDoneApp.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import SwiftUI
import AppKit
import Carbon
import Combine

@main
struct ClipBoardDoneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { Settings { EmptyView() } }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    // Strong reference so SwiftUI label bindings never lose this instance
    static var shared: AppDelegate?
    private let hotkeyManager = GlobalHotkeyManager()
    private var clipboardWindow: NSWindow?
    fileprivate var isWindowVisible = false // exposed for MenuBarExtra label
    private var statusItem: NSStatusItem?
    var isWindowCurrentlyVisible: Bool { isWindowVisible }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 ClipBoard Done app starting...")
        
        // Check if another instance is already running
        let runningApps = NSWorkspace.shared.runningApplications
        let currentApp = Bundle.main.bundleIdentifier
        let instances = runningApps.filter { $0.bundleIdentifier == currentApp }
        
        print("🔍 App instances check:")
        print("  - Current bundle ID: \(currentApp ?? "unknown")")
        print("  - Running instances: \(instances.count)")
        for (index, app) in instances.enumerated() {
            print("  - Instance \(index + 1): PID \(app.processIdentifier), launched: \(app.launchDate ?? Date())")
        }
        
        // NOTE: Removed automatic termination on multiple instances to avoid accidental self-termination
        if instances.count > 1 { print("ℹ️ Multiple instances detected (no auto-terminate)") }
        
        // Configure as accessory (still shows MenuBarExtra); if you want Dock + menu bar, change to .regular
        NSApp.setActivationPolicy(.accessory)
        print("✅ Activation policy set (.accessory)")

        // Register static reference
        AppDelegate.shared = self

        setupStatusItem()
        
        // Register global hotkey (Cmd+Shift+V)
        hotkeyManager.delegate = self
        hotkeyManager.registerHotkey()
        
        print("✅ App launched - MenuBarExtra should be visible (diamond.fill)")
    }
    // MARK: - Status Item Setup
    private func setupStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem = item
        guard let button = item.button else { return }
        if #available(macOS 11.0, *) {
            if let img = NSImage(systemSymbolName: "diamond.fill", accessibilityDescription: "Clipboard History") {
                img.isTemplate = true
                button.image = img
                button.imagePosition = .imageOnly
            } else { button.title = "◆" }
        } else {
            button.title = "◆"
        }
        button.toolTip = "Clipboard History"
        // Build menu
        let menu = NSMenu()
        let toggleItem = NSMenuItem(title: "Show Clipboard", action: #selector(toggleWindowFromMenu), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        let clearItem = NSMenuItem(title: "Clear History", action: #selector(clearClipboardHistory), keyEquivalent: "")
        clearItem.target = self
        menu.addItem(clearItem)
        menu.addItem(NSMenuItem.separator())
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        item.menu = menu
        updateMenuTitle()
        print("✅ Status item (diamond) installed")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        hotkeyManager.unregisterHotkey()
    }
    
    // Status item methods
    

    
    // Not used anymore (MenuBarExtra handles menu); kept for possible future direct triggers
    @objc private func statusItemClicked() { toggleWindow() }
    
    @objc private func toggleWindow() {
        if isWindowVisible {
            hideWindow()
        } else {
            showWindow()
        }
    }
    
    private func showWindow() {
        print("📂 Showing clipboard window (current state: isWindowVisible=\(isWindowVisible))")
        
        // If window is already visible, just bring it to front
        if isWindowVisible && clipboardWindow != nil {
            clipboardWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create window if it doesn't exist or was destroyed
        if clipboardWindow == nil {
            createClipboardWindow()
        }
        
        guard let window = clipboardWindow else { 
            print("❌ Failed to create clipboard window")
            return 
        }
        
        // Position near top center of primary screen (MenuBarExtra doesn't expose button frame directly)
        if let screen = NSScreen.main {
            let sf = screen.visibleFrame
            let windowFrame = NSRect(
                x: sf.midX - 200,
                y: sf.maxY - 520 - 8, // below menu bar
                width: 400,
                height: 500
            )
            window.setFrame(windowFrame, display: true)
        }
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        isWindowVisible = true
        
        // Update menu
    updateMenuTitle()
        
        print("✅ Clipboard window shown successfully")
    }
    
    private func hideWindow() {
        print("📁 Hiding clipboard window (current state: isWindowVisible=\(isWindowVisible))")
        
        guard isWindowVisible else {
            print("ℹ️ Window is already hidden")
            return
        }
        
        clipboardWindow?.orderOut(nil)
        isWindowVisible = false
    updateMenuTitle()
        
        print("✅ Clipboard window hidden successfully")
    }
    
    private func createClipboardWindow() {
        let contentView = ContentView(clipboardManager: ClipboardManager.shared)
        
        clipboardWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 500),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        clipboardWindow?.contentView = NSHostingView(rootView: contentView)
        clipboardWindow?.title = "Clipboard History"
        clipboardWindow?.level = .floating
        clipboardWindow?.delegate = self
        
        // Handle window close
        clipboardWindow?.standardWindowButton(.closeButton)?.target = self
        clipboardWindow?.standardWindowButton(.closeButton)?.action = #selector(handleWindowClose)
    }
    
    @objc private func handleWindowClose() {
        isWindowVisible = false
    updateMenuTitle()
    }
    
    private func updateMenuTitle() {
        if let menu = statusItem?.menu, let first = menu.items.first {
            first.title = isWindowVisible ? "Hide Clipboard" : "Show Clipboard"
        }
    }

    @objc private func clearClipboardHistory() {
        print("🧹 Clearing clipboard history (\(ClipboardManager.shared.clipboardHistory.count) items)...")
        ClipboardManager.shared.clearHistory()
    }
    
    @objc func quitApp() { print("👋 Quitting app"); NSApp.terminate(nil) }
    
    // Public method for external components to call
    @objc func toggleWindowFromMenu() {
        print("🖱️ Menu item clicked")
        toggleWindow()
    }
    
    // Public method for ContentView to notify when window should close
    func windowDidClose() {
        isWindowVisible = false
        updateMenuTitle()
    }
}

// (Removed legacy status item controller & watchdog to ensure single icon.)

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        isWindowVisible = false
        updateMenuTitle()
    }
}

extension AppDelegate: GlobalHotkeyManagerDelegate {
    func hotkeyPressed() {
        print("🔥 Global hotkey ⌘⇧V pressed! (current state: isWindowVisible=\(isWindowVisible))")
        
        // Ensure we're on the main thread and process only one hotkey at a time
        DispatchQueue.main.async {
            self.toggleWindow()
        }
    }
}


