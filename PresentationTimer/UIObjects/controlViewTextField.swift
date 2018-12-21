//
//  textFieldFormatter.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 7/15/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewTextField: NSTextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        formatter = controlViewTextFieldFormatter()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
}

class controlViewTextFieldFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
        guard let obj = obj else {
            return String.init()
        }
        if obj as? Int != nil {
            let numFormatter = NumberFormatter()
            numFormatter.minimumIntegerDigits = 2
            return numFormatter.string(from: obj as! NSNumber)
        } else { return String.init() }
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        if partialString.count > 2 {
            return false
        }
        return Int(partialString) != nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = Int(string) as AnyObject
        return true
    }
    
}
