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
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.clockReset, object:nil)
        nc.addObserver(self, selector: #selector(showBorderView), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.hideBorder, object:nil)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.clockReset, object:nil)
        nc.addObserver(self, selector: #selector(showBorderView), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderView), name: Notification.Name.hideBorder, object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBorderRed()
    }
    
    @objc func setBorderGreen() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func hideBorderView() {
        self.view.layer?.borderWidth = 0
    }
    
    @objc func showBorderView() {
        self.view.layer?.borderWidth = 50
    }
}
