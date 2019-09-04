//
//  timerDisplayTextField.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 9/1/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

class timerDisplayTextField: NSTextField, NSTextFieldDelegate{

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //self.backgroundColor = NSColor.red
    }
    
    func setTimerDisplayTextFieldSize() {
        print(self.frame.size.height)
        print(self.frame.size.width)
        let currentFont = self.attributedStringValue.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)
        let attributes = [NSAttributedString.Key.font: currentFont]
        let placeHolderAttributedString = NSAttributedString(string: " 00H 00M 00S ", attributes: attributes as [NSAttributedString.Key : Any])
        print(type(of: placeHolderAttributedString))
        print("placeHolder string: ", placeHolderAttributedString.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)!)
        print("placeHolder string: ", placeHolderAttributedString.string)
        print("placeHolder height: ", placeHolderAttributedString.size().height)
        print("placeHolder width: ", placeHolderAttributedString.size().width)
        print(self.frame)
        self.frame = NSRect(x: 0,
                            y: 0,
                            width: placeHolderAttributedString.size().width,
                            height: placeHolderAttributedString.size().height)
        print(self.frame)
    }
}
