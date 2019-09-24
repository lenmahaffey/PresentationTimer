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
            
            let fontDescriptor = NSFontDescriptor(name: menuItem.title, size: 13)
            let menuItemRect = CGRect(x: 0, y: 0, width: (menuItem.attributedTitle?.size().width)!, height: (menuItem.attributedTitle?.size().height)!)
            let bestFont = NSFont.bestFittingFont(for: menuItem.title, in: menuItemRect, fontDescriptor: fontDescriptor)
            //print("...", bestFont.description)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: bestFont,
            ]
            let newAttributedTitle = NSMutableAttributedString(string: menuItem.title, attributes: attributes)
            menuItem.attributedTitle = newAttributedTitle
        }
    }
    
    @IBAction func fontFamilySelectorAction(_ sender: Any) {
        let selectedFont = NSFont(name:fontFamilySelector.selectedItem!.title, size: currentFontSize)!
        //Setup family members
        let availableFontFamilyMembers = fontManager.availableMembers(ofFontFamily: (selectedFont.familyName!))
        var familyMembersAsString = [String]()
        for familyMember in availableFontFamilyMembers! {
            let currentFamilyMemberName = (familyMember[0] as? String)!
            familyMembersAsString.append(currentFamilyMemberName)
        }
        fontTypeSelector.removeAllItems()
        fontTypeSelector.addItems(withTitles: familyMembersAsString)
        for menuItem in fontTypeSelector.itemArray {
            let currentFont = NSFont.init(name: menuItem.title, size: 13)
            menuItem.attributedTitle = NSAttributedString(string: menuItem.title, attributes: [NSAttributedString.Key.font: currentFont as Any])
        }
        currentSelectedFont =  NSFont(name:fontFamilySelector.selectedItem!.title, size: currentFontSize)!
        nc.post(name: Notification.Name.setFont, object: self)
        
    }
    
    @IBAction func fontTypeSelectorAction(_ sender: Any) {
        currentSelectedFont =  NSFont(name:fontTypeSelector.selectedItem!.title, size: currentFontSize)!
        nc.post(name: Notification.Name.setFont, object: self)
    }
    
    @IBAction func fontColorPickerAction(_ sender: Any) {
        fontColor = NSColor(cgColor: fontColorWell.color.cgColor)!
        nc.post(name: Notification.Name.setFontColor, object: self)
        
    }
    
    @IBAction func backgroundColorPickerAction(_ sender: Any) {
        backgroundColor = backgroundColorWell.color.cgColor
        nc.post(name: Notification.Name.setBackgroundColor, object: self)
    }
    
}

extension NSFont {
    
    /**
     Will return the best font conforming to the descriptor which will fit in the provided bounds.
     */
    static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: NSFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
        let constrainingDimension = min(bounds.width, bounds.height)
        let properBounds = CGRect(origin: .zero, size: bounds.size)
        var attributes = additionalAttributes ?? [:]
        
        let infiniteBounds = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        var bestFontSize: CGFloat = constrainingDimension
        
        for fontSize in stride(from: bestFontSize, through: 0, by: -1) {
            let newFont = NSFont(descriptor: fontDescriptor, size: fontSize)
            attributes[.font] = newFont
            
            let currentFrame = text.boundingRect(with: infiniteBounds, options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics], attributes: attributes, context: nil)
            
            if properBounds.contains(currentFrame) {
                bestFontSize = fontSize
                break
            }
        }
        return bestFontSize
    }
    
    static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor:  NSFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> NSFont {
        let bestSize = bestFittingFontSize(for: text, in: bounds, fontDescriptor: fontDescriptor, additionalAttributes: additionalAttributes)
        return NSFont(descriptor: fontDescriptor, size: bestSize)!
    }
}
