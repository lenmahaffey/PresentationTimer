//
//  preferencesViewController.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 8/22/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

var backgroundColor = NSColor.black.cgColor
class preferencesViewController: NSViewController {
    
    //let nc = NotificationCenter.default
    @IBOutlet weak var backgroundColorPicker: NSColorWell!
    @IBOutlet weak var fontColorPicker: NSColorWell!
    @IBOutlet weak var fontSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorPicker.color = NSColor.black
        getFonts()
        // Do view setup here.
    }
    
    func getFonts() {
        let fontManager = NSFontManager.shared
        fontSelector.removeAllItems()
        fontSelector.addItems(withTitles: fontManager.availableFontFamilies)
        for menuItem in fontSelector.itemArray {
            let currentFont = NSFont.init(name: menuItem.title, size: 13)
            menuItem.attributedTitle = NSAttributedString(string: menuItem.title, attributes: [NSAttributedString.Key.font: currentFont as Any])
        }
    }
    
    @IBAction func backgroundColorPickerAction(_ sender: Any) {
        backgroundColor = backgroundColorPicker.color.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
}
