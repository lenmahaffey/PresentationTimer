//
//  displayWindowController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayWindowController: NSWindowController, NSWindowDelegate {
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        self.window?.close()
    }
    
    func showWindowOnExtendedDesktop() {
        if NSScreen.screens.count > 1 {
            self.window?.setFrame(NSScreen.screens[1].frame, display: true)
            if (self.window?.styleMask.contains(NSWindow.StyleMask.fullScreen))!  {
            } else {
                self.window?.toggleFullScreen(self)
            }
            self.showWindow(self)
        }
    }
}
