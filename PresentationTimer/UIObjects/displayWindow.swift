//
//  displayViewWindow.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//
// Sets up a window with a black background that ignores mouse events
import Cocoa


class displayWindow: NSWindow {
    
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
    
    let background: NSColor = NSColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.backgroundColor = background
        self.ignoresMouseEvents = true;
    }
    
    convenience init(contentViewController: NSViewController) {
        self.init(contentViewController: contentViewController)
        self.backgroundColor = background
        self.ignoresMouseEvents = true;
    }
    
    convenience init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool, screen: NSScreen?) {
        self.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag, screen: screen)
        self.backgroundColor = background
        self.ignoresMouseEvents = true;
    }
}
