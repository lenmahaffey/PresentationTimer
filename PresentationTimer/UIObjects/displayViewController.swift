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
    @objc dynamic var countdownTimerController = presentationTimerController(timeLimit: 0, warningTime: 0)
    lazy var warningBorder = { () -> warningView in
        var warning = warningView(frame: self.view.frame)
        warning.isHidden = true
        self.view.addSubview(warning)
        return warning
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(showBorder), name: Notification.Name.warn, object:nil)
    }
    
    func countDown() {
        countdownTimerController.countDown()
    }
    
    func countUp() {
        countdownTimerController.countUp()
    }
    
    func stopTheClock() {
        if countdownTimerController.timer.isRunning == true {
            countdownTimerController.stopTheClock()
        }
    }
    
    func resetTheClock() {
        countdownTimerController.resetTheClock()
    }
    
    @objc func showBorder() {
        if self.warningBorder.isHidden == true {
            self.warningBorder.isHidden = false
            self.view.setNeedsDisplay(self.view.frame)
        }
    }
    
    func hideBorder() {
        if self.warningBorder.isHidden == false {
            self.warningBorder.isHidden = true
            self.view.setNeedsDisplay(self.view.frame)
        }
    }
}
