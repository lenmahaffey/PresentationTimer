//
//  ViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewController: NSViewController, NSTextViewDelegate {
    
    let nc = NotificationCenter.default
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var repeatButton: NSButton!
    @IBOutlet weak var totalTimeHoursEntryField: controlViewTextField?
    @IBOutlet weak var totalTimeMinutesEntryField: controlViewTextField?
    @IBOutlet weak var totalTimeSecondsEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeHoursEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeMinutesEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeSecondsEntryField: controlViewTextField?
    @objc dynamic var displayWindowControl: displayWindowController? = nil
    @objc dynamic var timerController = countdownTimerController

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpTime), name: NSText.didEndEditingNotification, object: nil)
    }
    
    override func viewDidAppear() {
        loadDisplayWindow()
    }
    
    func loadDisplayWindow() {
        let displayWindowControllerSceneID = "displayWindowController"
        self.displayWindowControl = (NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    @IBAction func showBorder(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.showBorder, object: self)
        } else {
            nc.post(name: Notification.Name.hideBorder, object: self)
        }
    }
    
    @IBAction func startButtonPress(_ sender: Any) {
        timerController.countDown()
    }
    
    @IBAction func stopButtonPress(_ sender: Any) {
        timerController.stopTheClock()
    }
    
    @IBAction func repeatButtonPress(_ sender: Any) {
        timerController.resetTheClock()
    }
    
    @objc func setUpTime(notification: Notification) {
        let totalHours = self.totalTimeHoursEntryField?.intValue ?? 0
        let totalMinutes = self.totalTimeMinutesEntryField?.intValue ?? 0
        let totalSeconds = self.totalTimeSecondsEntryField?.intValue ?? 0
        self.totalTimeHoursEntryField?.placeholderString = ""
        self.totalTimeMinutesEntryField?.placeholderString = ""
        self.totalTimeSecondsEntryField?.placeholderString = ""
        if Int(totalSeconds) > 59 {
            let newSeconds = Int(totalSeconds) - 60
            let newMinutes = Int(totalMinutes) + 1
            self.totalTimeSecondsEntryField?.stringValue = String(describing: newSeconds)
            self.totalTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            setUpTime(notification: notification)
        }
        if Int(totalMinutes) > 59 {
            let newMinutes = Int(totalMinutes) - 60
            let newHours = Int(totalHours) + 1
            self.totalTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            self.totalTimeHoursEntryField?.stringValue = String(describing: newHours)
            setUpTime(notification: notification)
        }
        let timerTotal = time(hours: (Int(self.totalTimeHoursEntryField?.intValue ?? 0)),
                              minutes: (Int(self.totalTimeMinutesEntryField?.intValue ?? 0)),
                              seconds: (Int(self.totalTimeSecondsEntryField?.intValue ?? 0)))
        
        let warningTotal = time(hours: (Int(self.wrapUpTimeHoursEntryField?.intValue ?? 0)),
                                minutes: (Int(self.wrapUpTimeMinutesEntryField?.intValue ?? 0)),
                                seconds: (Int(self.wrapUpTimeSecondsEntryField?.intValue ?? 0)))
        if timerController.timer.isRunning == false {
            timerController.setTime(timeLimit: timerTotal, warningTime: warningTotal)
        }
        if timerController.timer.isRunning == true {
            timerController.timer.warningTime.timeInSeconds = warningTotal.timeInSeconds
        }
    }
    
}

