//
//  displayViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewController: NSViewController {
    
    @IBOutlet weak var timerDisplayText: NSTextField!
    @objc dynamic var countdownTimer = presentationTimer(secondsToCount: 34352)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func countDown() {
        countdownTimer.countDown()
    }
    
    func countUp() {
        countdownTimer.countUp()
    }
}
