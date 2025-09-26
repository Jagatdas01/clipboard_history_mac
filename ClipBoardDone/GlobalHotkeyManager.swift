//
//  GlobalHotkeyManager.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import AppKit
import Carbon

protocol GlobalHotkeyManagerDelegate: AnyObject {
    func hotkeyPressed()
}

class GlobalHotkeyManager {
    weak var delegate: GlobalHotkeyManagerDelegate?
    private var hotkeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private let hotkeyID = EventHotKeyID(signature: OSType("CLIP".fourCharCodeValue), id: 1)
    
    func registerHotkey() {
        // First unregister if already registered
        unregisterHotkey()
        
        // Register Cmd+Shift+V
        let keyCode = UInt32(9) // V key (kVK_ANSI_V)
        let modifiers = UInt32(cmdKey | shiftKey)
        
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotkeyID,
            GetApplicationEventTarget(),
            0,
            &hotkeyRef
        )
        
        if status != noErr {
            print("Failed to register hotkey with status: \(status)")
            return
        }
        
        print("Successfully registered global hotkey Cmd+Shift+V")
        
        // Install event handler
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        let userData = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        let eventHandlerCallback: EventHandlerProcPtr = { _, event, userData in
            guard let userData = userData else { return noErr }
            
            var hotkeyID = EventHotKeyID()
            let result = GetEventParameter(
                event,
                EventParamName(kEventParamDirectObject),
                EventParamType(typeEventHotKeyID),
                nil,
                MemoryLayout<EventHotKeyID>.size,
                nil,
                &hotkeyID
            )
            
            if result == noErr {
                let manager = Unmanaged<GlobalHotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                if hotkeyID.signature == manager.hotkeyID.signature && hotkeyID.id == manager.hotkeyID.id {
                    manager.handleHotkeyPressed()
                }
            }
            
            return noErr
        }
        
        let installStatus = InstallEventHandler(
            GetApplicationEventTarget(),
            eventHandlerCallback,
            1,
            &eventType,
            userData,
            &eventHandler
        )
        
        if installStatus != noErr {
            print("Failed to install event handler with status: \(installStatus)")
        } else {
            print("Successfully installed event handler")
        }
    }
    
    private func handleHotkeyPressed() {
        print("🎯 Hotkey event received in GlobalHotkeyManager")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.hotkeyPressed()
        }
    }
    
    func unregisterHotkey() {
        if let hotkeyRef = hotkeyRef {
            UnregisterEventHotKey(hotkeyRef)
            self.hotkeyRef = nil
        }
        
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
    
    deinit {
        unregisterHotkey()
    }
}

extension String {
    var fourCharCodeValue: FourCharCode {
        let chars = Array(utf8.prefix(4))
        return chars.enumerated().reduce(0) { result, pair in
            result | (FourCharCode(pair.element) << (24 - pair.offset * 8))
        }
    }
}