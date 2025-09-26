//
//  IconGenerator.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import SwiftUI
import AppKit

struct ClipboardIconView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // White background
            RoundedRectangle(cornerRadius: size * 0.18)
                .fill(Color.white)
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.18)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // Simple clipboard icon
            ZStack {
                // Main clipboard background (light gray)
                RoundedRectangle(cornerRadius: size * 0.06)
                    .fill(Color.gray.opacity(0.15))
                    .stroke(Color.black.opacity(0.4), lineWidth: size * 0.01)
                    .frame(width: size * 0.65, height: size * 0.75)
                
                // Clip at top (dark gray)
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color.gray.opacity(0.8))
                    .stroke(Color.black.opacity(0.5), lineWidth: size * 0.008)
                    .frame(width: size * 0.28, height: size * 0.08)
                    .offset(y: -size * 0.34)
                
                // Paper content
                VStack(spacing: size * 0.05) {
                    // Title line (blue)
                    Rectangle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: size * 0.35, height: size * 0.025)
                    
                    // Content lines (gray)
                    VStack(spacing: size * 0.03) {
                        Rectangle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: size * 0.4, height: size * 0.015)
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: size * 0.32, height: size * 0.015)
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: size * 0.38, height: size * 0.015)
                    }
                }
                .offset(y: size * 0.05)
            }
        }
    }
}

class IconGenerator {
    static func generateIcon(size: CGFloat) -> NSImage? {
        let view = ClipboardIconView(size: size)
        
        // Create bitmap with exact pixel dimensions
        guard let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size),
            pixelsHigh: Int(size),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            print("❌ Failed to create bitmap representation")
            return nil
        }
        
        // Create graphics context
        let context = NSGraphicsContext(bitmapImageRep: bitmapRep)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        
        // Create hosting view and render
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        hostingView.wantsLayer = true
        
        // Force layout and draw
        hostingView.layoutSubtreeIfNeeded()
        hostingView.draw(hostingView.bounds)
        
        NSGraphicsContext.restoreGraphicsState()
        
        // Create final image with exact size
        let image = NSImage(size: CGSize(width: size, height: size))
        image.addRepresentation(bitmapRep)
        
        return image
    }
    
    static func saveCorrectSizedIcons() {
        let sizes: [CGFloat] = [16, 32, 64, 128, 256, 512, 1024]
        
        // Use Documents folder
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Could not access Documents folder")
            return
        }
        
        let saveURL = documentsURL.appendingPathComponent("ClipboardIcons_Fixed")
        
        print("🎨 Starting CORRECT SIZE icon generation...")
        print("📁 Save path: \(saveURL.path)")
        
        // Create the directory
        do {
            try FileManager.default.createDirectory(at: saveURL, withIntermediateDirectories: true, attributes: nil)
            print("✅ Directory created")
        } catch {
            print("❌ Failed to create directory: \(error)")
            return
        }
        
        for size in sizes {
            print("⏳ Generating EXACT \(Int(size))x\(Int(size)) icon...")
            
            if let image = generateIcon(size: size) {
                let filename = "clipboard_icon_\(Int(size))x\(Int(size)).png"
                let url = saveURL.appendingPathComponent(filename)
                
                if let tiffData = image.tiffRepresentation,
                   let bitmapRep = NSBitmapImageRep(data: tiffData) {
                    
                    print("📏 Generated size: \(bitmapRep.pixelsWide)x\(bitmapRep.pixelsHigh) (should be \(Int(size))x\(Int(size)))")
                    
                    if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
                        do {
                            try pngData.write(to: url)
                            print("✅ Saved: \(filename)")
                        } catch {
                            print("❌ Failed to save: \(error)")
                        }
                    }
                }
            } else {
                print("❌ Failed to generate image for size \(size)")
            }
        }
        
        print("🎉 CORRECT SIZE icons generated!")
        DispatchQueue.main.async {
            NSWorkspace.shared.open(saveURL)
        }
    }
}