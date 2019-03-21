//
//  controlView.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 4/1/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlView: NSView {

    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            if (self.window?.styleMask.contains(NSWindow.StyleMask.fullScreen))!  {
                self.window?.toggleFullScreen(self)
            }
        }
    }
}
