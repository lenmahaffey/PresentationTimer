//
//  displayViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewController: NSViewController {
    
    let nc = NotificationCenter.default
    @objc dynamic var timerController = countdownTimerController
    weak var timerDisplayText: NSTextField!
    lazy var warningBorderView = { () -> NSView in
        var warning = NSView(frame: self.view.frame)
        warning.isHidden = false
        return warning
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.clockReset, object:nil)
        nc.addObserver(self, selector: #selector(showBorderView), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.hideBorder, object:nil)
    }
    
    override func viewWillAppear() {
        if !warningBorderView.isDescendant(of: self.view) {
            self.view.addSubview(warningBorderView)
        }
    }
    
    @objc func setBorderGreen() {
        self.warningBorderView.layer?.borderWidth = 50
        self.warningBorderView.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow() {
        self.warningBorderView.layer?.borderWidth = 50
        self.warningBorderView.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed() {
        self.warningBorderView.layer?.borderWidth = 50
        self.warningBorderView.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func hideBorderView() {
        self.warningBorderView.isHidden = true
    }
    
    @objc func showBorderView() {
        self.warningBorderView.isHidden = false
    }
}
