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
    @IBOutlet weak var fontFamilySelector: NSPopUpButton!
    @IBOutlet weak var fontTypeSelector: NSPopUpButton!
    @IBOutlet weak var fontSizeSelector: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorWell.color = NSColor.black
        fontColorWell.color = NSColor.white
        getFonts()
    }
    
    func getFonts() {
        fontFamilySelector.removeAllItems()
        fontTypeSelector.removeAllItems()
        fontFamilySelector.addItems(withTitles: fontManager.availableFontFamilies)
        for menuItem in fontFamilySelector.itemArray {
            let currentFont = NSFont.init(name: menuItem.title, size: 13)
            menuItem.attributedTitle = NSAttributedString(string: menuItem.title, attributes: [NSAttributedString.Key.font: currentFont as Any])
        }
    }
    
    @IBAction func fontFamilySelectorAction(_ sender: Any) {
        let selectedFont = NSFont(name:fontFamilySelector.selectedItem!.title, size: currentFontSize)!
        //Setup family members
        let availableFontFamilyMembers = fontManager.availableMembers(ofFontFamily: (selectedFont.familyName!))
        var familyMembersAsString = [String]()
        for familyMember in availableFontFamilyMembers! {
            print(familyMember)
            let currentFamilyMemberName = (familyMember[0] as? String)!
            familyMembersAsString.append(currentFamilyMemberName)
        }
        fontTypeSelector.removeAllItems()
        fontTypeSelector.addItems(withTitles: familyMembersAsString)
        for menuItem in fontTypeSelector.itemArray {
            print(menuItem)
            let currentFont = NSFont.init(name: menuItem.title, size: 13)
            print(currentFont?.displayName)
            menuItem.attributedTitle = NSAttributedString(string: menuItem.title, attributes: [NSAttributedString.Key.font: currentFont as Any])
        }
        currentSelectedFont =  NSFont(name:fontFamilySelector.selectedItem!.title, size: currentFontSize)!
        nc.post(name: Notification.Name.setTimerDisplayFont, object: self)
    }
    
    @IBAction func fontTypeSelectorAction(_ sender: Any) {
        currentSelectedFont =  NSFont(name:fontTypeSelector.selectedItem!.title, size: currentFontSize)!
        nc.post(name: Notification.Name.setTimerDisplayFont, object: self)
    }
    
    @IBAction func fontColorPickerAction(_ sender: Any) {
        fontColor = NSColor(cgColor: fontColorWell.color.cgColor)!
        nc.post(name: Notification.Name.setTimerDisplayTextColor, object: self)
        
    }
    
    @IBAction func backgroundColorPickerAction(_ sender: Any) {
        backgroundColor = backgroundColorWell.color.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
    
}
