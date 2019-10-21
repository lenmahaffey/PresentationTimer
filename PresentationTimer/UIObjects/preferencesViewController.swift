//
//  preferencesViewController.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 8/22/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

class preferencesViewController: NSViewController {
    
    let fontManager = NSFontManager.shared
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    @IBOutlet weak var fontColorWell: NSColorWell!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorWell.color = NSColor.black
        fontColorWell.color = NSColor.white
    }

    @IBAction func fontColorWellAction(_ sender: Any) {
        fontColor = NSColor(cgColor: fontColorWell.color.cgColor)!
        nc.post(name: Notification.Name.setFontColor, object: self)
    }
    
    @IBAction func backgroundColorWellAction(_ sender: Any) {
        backgroundColor = backgroundColorWell.color.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
}
