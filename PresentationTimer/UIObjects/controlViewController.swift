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
    @IBOutlet weak var totalTimeIncreseHoursButton: NSButton!
    @IBOutlet weak var totalTimeIncreseMinutesButton: NSButton!
    @IBOutlet weak var totalTimeIncreaseSecondsButton: NSButton!
    @IBOutlet weak var totalTimeDecreaseHoursButton: NSButton!
    @IBOutlet weak var totalTimeDecreaseMinutesButton: NSButton!
    @IBOutlet weak var totalTimeDecreaseSecondsButton: NSButton!
    @IBOutlet weak var wrapUpTimeIncreaseHoursButton: NSButton!
    @IBOutlet weak var wrapUpTimeIncreaseMinutesButton: NSButton!
    @IBOutlet weak var wrapUpTimeIncreaseSecondsButton: NSButton!
    @IBOutlet weak var warpUpTimeDecreaseHoursButton: NSButton!
    @IBOutlet weak var wrapUpTimeDecreaseMinutesButton: NSButton!
    @IBOutlet weak var wrapUpTimeDecreaseSecondsButton: NSButton!
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
        nc.addObserver(self, selector: #selector(setUpTime), name: NSText.didEndEditingNotification, object: nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(showBorder), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorder), name: Notification.Name.hideBorder, object:nil)
        self.timerDisplay.isBordered = false
        self.timerDisplay.wantsLayer = true
        self.timerDisplay.layer?.borderColor = NSColor.red.cgColor
        self.timerDisplay.layer?.borderWidth = 10
        self.timerDisplay.layer?.cornerRadius = 10.0
    }
    
    override func viewDidAppear() {
        loadDisplayWindow()
        view.window?.zoom(self)
    }
    
    @objc func setBorderGreen(notification: Notification) {
        self.timerDisplay.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow(notification: Notification) {
        self.timerDisplay.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed(notification: Notification) {
        self.timerDisplay.layer?.borderColor = NSColor.red.cgColor
    }
    
    func loadDisplayWindow() {
        let displayWindowControllerSceneID = "displayWindowController"
        self.displayWindowControl = (NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    @IBAction func showBorderControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.showBorder, object: self)
        }
        if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.hideBorder, object: self)
        }
    }
 
    @objc func showBorder() {
        self.timerDisplay.layer?.borderWidth = 10
    }
    
    @objc func hideBorder() {
        self.timerDisplay.layer?.borderWidth = 0
    }
    
    @IBAction func totalTimeIncreaseHoursButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 1, minutes: 0, seconds: 0)
        timerController.timer.totalTime.timeInSeconds += newTime.timeInSeconds
        timerController.timer.currentTime.timeInSeconds += newTime.timeInSeconds
        self.totalTimeHoursEntryField?.stringValue = String(timerController.timer.totalTime.hours)
    }
    
    @IBAction func totalTimeIncreaseMinutesButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 1, seconds: 0)
        timerController.timer.totalTime.timeInSeconds += newTime.timeInSeconds
        timerController.timer.currentTime.timeInSeconds += newTime.timeInSeconds
        self.totalTimeHoursEntryField?.stringValue = String(timerController.timer.totalTime.hours)
        self.totalTimeMinutesEntryField?.stringValue = String(timerController.timer.totalTime.minutes)
    }
    
    @IBAction func totalTimeIncreaseSecondsButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 0, seconds: 1)
        timerController.timer.totalTime.timeInSeconds += newTime.timeInSeconds
        timerController.timer.currentTime.timeInSeconds += newTime.timeInSeconds
        self.totalTimeMinutesEntryField?.stringValue = String(timerController.timer.totalTime.minutes)
        self.totalTimeSecondsEntryField?.stringValue = String(timerController.timer.totalTime.seconds)
    }
    
    @IBAction func totalTimeDecreaseHoursButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 1, minutes: 0, seconds: 0)
        if timerController.timer.totalTime.hours >= newTime.hours {
            timerController.timer.totalTime.timeInSeconds -= newTime.timeInSeconds
            if timerController.timer.currentTime.timeInSeconds >= newTime.timeInSeconds {
                timerController.timer.currentTime.timeInSeconds -= newTime.timeInSeconds
            }
            if totalTimeHoursEntryField?.intValue != 0 {
                totalTimeHoursEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func totalTimeDecreaseMinutesButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 1, seconds: 0)
        if timerController.timer.totalTime.minutes >= newTime.minutes {
            timerController.timer.totalTime.timeInSeconds -= newTime.timeInSeconds
            if timerController.timer.currentTime.timeInSeconds >= newTime.timeInSeconds {
                timerController.timer.currentTime.timeInSeconds -= newTime.timeInSeconds
            }
            if totalTimeMinutesEntryField?.intValue != 0 {
                totalTimeMinutesEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func totalTimeDecreaseSecondsButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 0, seconds: 1)
        if timerController.timer.totalTime.seconds >= newTime.seconds {
            timerController.timer.totalTime.timeInSeconds -= newTime.timeInSeconds
            if timerController.timer.currentTime.timeInSeconds >= newTime.timeInSeconds {
                timerController.timer.currentTime.timeInSeconds -= newTime.timeInSeconds
            }
            if totalTimeSecondsEntryField?.intValue != 0 {
                totalTimeSecondsEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func wrapUpTimeIncreaseHoursButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 1, minutes: 0, seconds: 0)
        timerController.timer.warningTime.timeInSeconds += newTime.timeInSeconds
        self.wrapUpTimeHoursEntryField?.intValue = Int32(timerController.timer.warningTime.hours)
    }
    
    @IBAction func wrapUpTimeIncreaseMinutesButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 1, seconds: 0)
        timerController.timer.warningTime.timeInSeconds += newTime.timeInSeconds
        self.wrapUpTimeMinutesEntryField?.intValue = Int32(timerController.timer.warningTime.minutes)
    }
    
    @IBAction func wrapUpTimeIncreaseSecondsButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 0, seconds: 1)
        timerController.timer.warningTime.timeInSeconds += newTime.timeInSeconds
        self.wrapUpTimeSecondsEntryField?.intValue = Int32(timerController.timer.warningTime.seconds)
    }
    
    @IBAction func wrapUpTimeDecreaseHoursButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 1, minutes: 0, seconds: 0)
        if timerController.timer.warningTime.timeInSeconds != 0 {
            timerController.timer.warningTime.timeInSeconds -= newTime.timeInSeconds
            if wrapUpTimeHoursEntryField?.intValue != 0 {
                wrapUpTimeHoursEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func wrapUpTimeDecreaseMinutesButtonPress(_ sender: Any) {
       let newTime =  time.init(hours: 0, minutes: 1, seconds: 0)
        if timerController.timer.warningTime.timeInSeconds > newTime.timeInSeconds {
            timerController.timer.warningTime.timeInSeconds -= newTime.timeInSeconds
            if wrapUpTimeMinutesEntryField?.intValue != 0 {
                wrapUpTimeMinutesEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func wrapUpTimeDecreaseSecondsButtonPress(_ sender: Any) {
        let newTime = time.init(hours: 0, minutes: 0, seconds: 1)
        if timerController.timer.warningTime.timeInSeconds > newTime.timeInSeconds {
            timerController.timer.warningTime.timeInSeconds -= newTime.timeInSeconds
            if wrapUpTimeSecondsEntryField?.intValue != 0 {
                wrapUpTimeSecondsEntryField?.intValue -= 1
            }
        }
    }
    
    @IBAction func startButtonPress(_ sender: Any) {
        timerController.countDown()
        //self.totalTimeHoursEntryField?.isEditable = false
        //self.totalTimeMinutesEntryField?.isEditable = false
        //self.totalTimeSecondsEntryField?.isEditable = false
    }
    
    @IBAction func stopButtonPress(_ sender: Any) {
        timerController.stopTheClock()
        //self.totalTimeHoursEntryField?.isEditable = true
        //self.totalTimeMinutesEntryField?.isEditable = true
        //self.totalTimeSecondsEntryField?.isEditable = true
    }
    
    @IBAction func repeatButtonPress(_ sender: Any) {
        timerController.resetTheClock()
    }
    
    @objc func setUpTime(notification: Notification) {
        let totalHours = self.totalTimeHoursEntryField?.intValue ?? 0
        let totalMinutes = self.totalTimeMinutesEntryField?.intValue ?? 0
        let totalSeconds = self.totalTimeSecondsEntryField?.intValue ?? 0
        let wrapUpHours = self.wrapUpTimeHoursEntryField?.intValue ?? 0
        let wrapUpMinutes = self.wrapUpTimeMinutesEntryField?.intValue ?? 0
        let wrapUpSeconds = self.wrapUpTimeSecondsEntryField?.intValue ?? 0
        
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
        
        if Int(wrapUpMinutes) > 59 {
            let newMinutes = Int(wrapUpMinutes) - 60
            let newHours = Int(wrapUpHours) + 1
            self.wrapUpTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            self.wrapUpTimeHoursEntryField?.stringValue = String(describing: newHours)
            setUpTime(notification: notification)
        }
        
        if Int(wrapUpSeconds) > 59 {
            let newSeconds = Int(wrapUpSeconds) - 60
            let newMinutes = Int(wrapUpMinutes) + 1
            self.wrapUpTimeSecondsEntryField?.stringValue = String(describing: newSeconds)
            self.wrapUpTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            setUpTime(notification: notification)
        }
        
        let totalTime = time(hours: Int(self.totalTimeHoursEntryField?.intValue ?? 0),
                             minutes: Int(self.totalTimeMinutesEntryField?.intValue ?? 0),
                             seconds: Int(self.totalTimeSecondsEntryField?.intValue ?? 0))
        
        let warningTime = time(hours: Int(self.wrapUpTimeHoursEntryField?.intValue ?? 0),
                               minutes: Int(self.wrapUpTimeMinutesEntryField?.intValue ?? 0),
                               seconds: Int(self.wrapUpTimeSecondsEntryField?.intValue ?? 0))
        
        if timerController.timer.isRunning == true {
            timerController.setWarningTime(warningTime: warningTime)
        }
        
        if timerController.timer.isRunning == false {
            timerController.setTotalTime(timeLimit: totalTime)
            timerController.setWarningTime(warningTime: warningTime)
        }
    }
    
}

