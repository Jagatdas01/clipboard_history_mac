//
//  ContentView.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var hoveredItem: UUID?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Clipboard history list
            historyList
        }
        .background(Color(.windowBackgroundColor))
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: "doc.on.clipboard.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text("Clipboard History")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                clipboardManager.clearHistory()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .help("Clear all history")
        }
        .padding()
        .background(Color(.controlBackgroundColor))
    }
    
    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(clipboardManager.clipboardHistory.enumerated()), id: \.element.id) { index, item in
                    ClipboardItemRow(
                        item: item,
                        index: index,
                        isHovered: hoveredItem == item.id,
                        onCopy: { content in
                            clipboardManager.copyToClipboard(content)
                            // Close the window after copying
                            if let window = NSApp.keyWindow {
                                window.orderOut(nil)
                                // Notify delegate that window is closed
                                if let appDelegate = NSApp.delegate as? AppDelegate {
                                    appDelegate.windowDidClose()
                                }
                            }
                        },
                        onDelete: { 
                            if let originalIndex = clipboardManager.clipboardHistory.firstIndex(of: item) {
                                clipboardManager.deleteItem(at: originalIndex)
                            }
                        }
                    )
                    .onHover { isHovered in
                        hoveredItem = isHovered ? item.id : nil
                    }
                    
                    if index < clipboardManager.clipboardHistory.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .background(Color(.textBackgroundColor))
    }
}

struct ClipboardItemRow: View {
    let item: ClipboardItem
    let index: Int
    let isHovered: Bool
    let onCopy: (String) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Index number
            Text("\(index + 1)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 20, alignment: .trailing)
            
            // Content preview
            Text(item.content)
                .lineLimit(2)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Action buttons (show on hover)
            if isHovered {
                Button(action: { onCopy(item.content) }) {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .help("Copy to clipboard")
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .help("Delete item")
            }
        }
        .padding()
        .background(isHovered ? Color(.selectedControlColor) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            onCopy(item.content)
        }
    }
}

#Preview {
    ContentView(clipboardManager: ClipboardManager())
        .frame(width: 400, height: 500)
}
