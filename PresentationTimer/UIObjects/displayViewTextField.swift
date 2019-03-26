//
//  displayViewTextField.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 3/24/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewTextField: NSTextField {

    @objc dynamic var timerController = countdownTimerController
    @objc dynamic var timerValue = Int(0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.drawsBackground = true
        //self.stringValue = "0h 0m 0s"
        self.isBordered = true
        self.backgroundColor = NSColor.red
        self.font = NSFont.systemFont(ofSize: 200)
        self.alignment = NSTextAlignment.center
        self.textColor = NSColor.red
    }
}
