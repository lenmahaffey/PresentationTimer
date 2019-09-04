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
    let fontPanel = NSFontPanel.shared
    
    @IBOutlet weak var backgroundColorPicker: NSColorWell!
    @IBOutlet weak var fontColorPicker: NSColorWell!
    @IBOutlet weak var fontSelector: NSPopUpButton!
    @IBOutlet weak var fontTypeSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorPicker.color = NSColor.black
        fontColorPicker.color = NSColor.white
        getFonts()
    }
    
    func getFonts() {
        fontSelector.removeAllItems()
        fontTypeSelector.removeAllItems()
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
    
    @IBAction func fontColorPickerAction(_ sender: Any) {
        fontColor = NSColor(cgColor: fontColorPicker.color.cgColor)!
        nc.post(name: Notification.Name.setTimerDisplayTextColor, object: self)
        
    }
    
    @IBAction func fontPickerAction(_ sender: Any) {
        selectedFont =  NSFont(name:fontSelector.selectedItem!.title, size: selectedFontSize)!
        nc.post(name: Notification.Name.setTimerDisplayFont, object: self)
        let availableFontFamilyMembers = fontManager.availableMembers(ofFontFamily: selectedFont.familyName!)
        var familyMembersAsString = [String]()
        for familyMember in availableFontFamilyMembers! {
            let currentFamilyMemberName = (familyMember[1] as? String)!
            familyMembersAsString.append(currentFamilyMemberName)
        }
        fontTypeSelector.addItems(withTitles: familyMembersAsString)
    }
    
    @IBAction func fontTypeSelectorAction(_ sender: Any) {

    }
    
    @IBAction func fontPanelButtonAction(_ sender: Any) {

    }

}
