//
//  AppState.swift
//  ClipBoardDone
//
//  Created by Jagat Das on 25/09/25.
//

import SwiftUI
import AppKit
import Combine

class AppState: ObservableObject {
    @Published var isMenuBarVisible = false
    
    static let shared = AppState()
    
    private init() {}
    
    func showMenuBar() {
        isMenuBarVisible = true
    }
    
    func hideMenuBar() {
        isMenuBarVisible = false
        NSApp.hide(nil)
    }
    
    func toggleMenuBar() {
        if isMenuBarVisible {
            hideMenuBar()
        } else {
            showMenuBar()
        }
    }
}