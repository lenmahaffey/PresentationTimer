//
//  displayView.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 5/24/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//  Sets up a view with a yellow border framing the window

import Cocoa

class warningView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        /*let warningBorder = NSBezierPath(rect: NSRect(origin: CGPoint(x: CGFloat(0), y: CGFloat(0)),
                                                      size: CGSize(width: (self.window?.frame.width)!,
                                                                   height: (self.window?.frame.height)!)))
        warningBorder.lineWidth = 45
        NSColor.systemYellow.setStroke()
        warningBorder.stroke()*/
    }

}
