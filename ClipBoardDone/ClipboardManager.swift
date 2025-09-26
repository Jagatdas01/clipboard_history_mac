//
//  ClipboardManager.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import AppKit
import SwiftUI
import Combine

class ClipboardManager: ObservableObject {
    static let shared = ClipboardManager()
    
    @Published var clipboardHistory: [ClipboardItem] = []
    private var lastChangeCount: Int = 0
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        lastChangeCount = NSPasteboard.general.changeCount
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkForClipboardChanges()
        }
    }
    
    private func checkForClipboardChanges() {
        let pasteboard = NSPasteboard.general
        
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            
            if let string = pasteboard.string(forType: .string), !string.isEmpty {
                addToHistory(string)
            }
        }
    }
    
    private func addToHistory(_ content: String) {
        DispatchQueue.main.async {
            // Remove duplicate if exists
            self.clipboardHistory.removeAll { $0.content == content }
            
            // Add new item at the beginning
            let newItem = ClipboardItem(content: content, timestamp: Date())
            self.clipboardHistory.insert(newItem, at: 0)
            
            // Keep only last 50 items
            if self.clipboardHistory.count > 50 {
                self.clipboardHistory.removeLast(self.clipboardHistory.count - 50)
            }
        }
    }
    
    func copyToClipboard(_ content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }
    
    func deleteItem(at index: Int) {
        guard index < clipboardHistory.count else { return }
        clipboardHistory.remove(at: index)
    }
    
    func clearHistory() {
        clipboardHistory.removeAll()
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let timestamp: Date
    
    static func == (lhs: ClipboardItem, rhs: ClipboardItem) -> Bool {
        return lhs.content == rhs.content
    }
}