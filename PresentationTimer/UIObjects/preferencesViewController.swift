//
//  preferencesViewController.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 8/22/19.
//  Copyright © 2019 TLA Designs. All rights reserved.
//

import Cocoa

var backgroundColor = NSColor.brown.cgColor
class preferencesViewController: NSViewController {
    
    let nc = NotificationCenter.default
    @IBOutlet weak var backgroundColorPicker: NSColorWell!
    @IBOutlet weak var backgroundRGBRedTextField: NSTextField!
    @IBOutlet weak var backgroundRGBGreenTextField: NSTextField! 
    @IBOutlet weak var backgroundRGBBlueTextField: NSTextField!
    @IBOutlet weak var backgroundRGBAlphaTextField: NSTextField!
    @IBOutlet weak var fontColorPicker: NSColorWell!
    @IBOutlet weak var fontSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func colorFromTextField() {
        let red = CGFloat(Float(self.backgroundRGBRedTextField.intValue) / Float(255))
        let green = CGFloat(Float(self.backgroundRGBGreenTextField.intValue) / Float(255))
        let blue = CGFloat(Float(self.backgroundRGBBlueTextField.intValue) / Float(255))
        let alpha = CGFloat(1)
        let newColor = NSColor(cgColor: CGColor(red: red, green: green, blue: blue, alpha: alpha))
        self.backgroundColorPicker.color = newColor!
        backgroundColor = newColor!.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
    
    @IBAction func backgroundColorPickerAction(_ sender: Any) {
        self.backgroundRGBRedTextField.intValue = Int32(Float32(self.backgroundColorPicker.color.redComponent) * 255)
        self.backgroundRGBGreenTextField.intValue = Int32(Float32(self.backgroundColorPicker.color.greenComponent) * 255)
        self.backgroundRGBBlueTextField.intValue = Int32(Float32(self.backgroundColorPicker.color.blueComponent) * 255)
        backgroundColor = backgroundColorPicker.color.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
    
    @IBAction func backgroundRGBRedTextFieldAction(_ sender: Any) {
        colorFromTextField()
    }
    
    @IBAction func backgroundRGBGreenTextFieldAction(_ sender: Any) {
        colorFromTextField()
    }
    
    @IBAction func backgroundRGBBlueTextFieldAction(_ sender: Any) {
        colorFromTextField()
    }
    
    @IBAction func backgroundRGBAlphaTextFieldAction(_ sender: Any) {
        colorFromTextField()
    }
    
}
