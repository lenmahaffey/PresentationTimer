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
        NotificationCenter.default.addObserver( self, selector: #selector(monitorDidChange), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        //If only one screen then close the displayWindow
        if NSScreen.screens.count == 1 {
            self.window?.close()
        }
        //If more than one screen is detected then show the displayWindow
        if NSScreen.screens.count > 1 {
            self.showWindowOnExtendedDesktop()
        }
    }
    
    @objc func monitorDidChange(notification: NSNotification) {
        //print("Monitor did Change")
        if NSScreen.screens.count == 1 {
            self.window!.close()
        }
        if NSScreen.screens.count > 1 {
            self.showWindowOnExtendedDesktop()
        }
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        self.window?.close()
    }

    //Function called when a change to screens is observed by notification
    //closes displayWindow if only one screen, shows displayWindow if more than one
    func showWindowOnExtendedDesktop() {
        if NSScreen.screens.count > 1 {
            //print("showWindowOnExtendedDesktop: Showing window")
            self.window?.setFrame(NSScreen.screens[1].frame, display: true)
            if (self.window?.styleMask.contains(NSWindow.StyleMask.fullScreen))!  {
            } else {
                self.window?.toggleFullScreen(self)
            }
            self.showWindow(self)
        }
    }
}
