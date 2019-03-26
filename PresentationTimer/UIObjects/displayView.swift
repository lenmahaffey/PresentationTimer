//
//  displayView.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 3/24/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

class displayView: NSView {

    @objc dynamic var timerDisplayText: displayViewTextField?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.timerDisplayText = displayViewTextField(frame: NSRect(x: 0, y: (frameRect.height / 2 - 100), width: frameRect.width, height: 200))
        self.addSubview(timerDisplayText!)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
}
