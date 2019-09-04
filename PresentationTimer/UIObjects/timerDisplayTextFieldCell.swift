//
//  timerDisplayTextFieldCell.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 9/1/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

class timerDisplayTextFieldCell: NSTextFieldCell {

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleFrame = super.titleRect(forBounds: rect)
        let currentFont = self.attributedStringValue.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)
        let attributes = [NSAttributedString.Key.font: currentFont]
        let placeHolderAttributedString = NSAttributedString(string: " 00H 00M 00S ", attributes: attributes as [NSAttributedString.Key : Any])
        let titleSize = placeHolderAttributedString.size()
        titleFrame.origin.y = rect.origin.y + (rect.size.height - titleSize.height) / 2.0
        print(titleFrame.debugDescription)
        return titleFrame
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        let titleRect = self.titleRect(forBounds: cellFrame)
        self.attributedStringValue.draw(in: titleRect)
    }
}
