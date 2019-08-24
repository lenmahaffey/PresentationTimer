//
//  preferencesView.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 8/22/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

@IBDesignable
class preferencesView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("preferencesWindow.xib", owner: self, topLevelObjects: nil)
    }
}
