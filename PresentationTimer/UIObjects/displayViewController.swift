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
    @IBOutlet weak var timerDisplayText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(showGreenBorder), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(showYellowBorder), name: Notification.Name.warn, object:nil)
        nc.addObserver(self, selector: #selector(showRedBorder), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(hideBorder), name: Notification.Name.clockReset, object:nil)
    }
    
    @objc func showGreenBorder() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func showYellowBorder() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func showRedBorder() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func hideBorder() {
        self.view.layer?.borderWidth = 0
        self.view.layer?.borderColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    }
}
