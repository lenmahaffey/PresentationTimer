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
    @objc dynamic var displayWindowControl: displayWindowController? = nil
    @objc dynamic var timerController = countdownTimerController
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
    @IBOutlet weak var countUpRadioButton: NSButton!
    @IBOutlet weak var countDownRadioButton: NSButton!
    @IBOutlet weak var showDateRadioButton: NSButton!
    @IBOutlet weak var showBorderRadioButton: NSButton!
    @IBOutlet weak var blinkBorderRadioButton: NSButton!
    @IBOutlet weak var blinkClockRadioButton: NSButton!
    @IBOutlet weak var keepCountingRadioButton: NSButton!
    
    var willShowBorder: Bool
    
    required init?(coder: NSCoder) {
        self.willShowBorder = true
        super.init(coder: coder)
    }
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        self.willShowBorder = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        self.willShowBorder = true
        super.viewDidLoad()
        self.setUpNotifications()
        self.timerDisplay.isBordered = false
        self.timerDisplay.wantsLayer = true
        self.timerDisplay.layer?.borderColor = NSColor.red.cgColor
        self.timerDisplay.layer?.borderWidth = 10
        self.timerDisplay.layer?.cornerRadius = 10.0
        self.countDownRadioButton.state = .on
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.minSize = NSSize(width: 1000, height: 545)
    }
    
    override func viewDidAppear() {
        loadDisplayWindow()
        //view.window?.zoom(self)
    }
    
    func loadDisplayWindow() {
        let displayWindowControllerSceneID = "displayWindowController"
        self.displayWindowControl = (NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    @objc func setBorderGreen() {
        self.timerDisplay.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow() {
        self.timerDisplay.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed() {
        self.timerDisplay.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func showBorder() {
        self.timerDisplay.layer?.borderWidth = 10
    }
    
    @objc func hideBorder() {
        self.timerDisplay.layer?.borderWidth = 0
    }
    
    @objc func timerStopped() {
        self.startButton.title = "Start"
    }
    
    @objc func blinkBorder() {
        if self.willShowBorder == true {
            
        }
    }
    
    @objc func staticBorder() {
        self.showBorder()
    }
    
    @objc func blinkTimer() {

    }
    
    @objc func staticTimer() {

    }
    
    @IBAction func showBorderControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setWillShowBorderOn, object: self)
            nc.post(name: Notification.Name.showBorder, object: self)
            nc.post(name: Notification.Name.staticBorder, object: self)
        }
        if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setWillShowBorderOff, object: self)
            nc.post(name: Notification.Name.hideBorder, object: self)
            nc.post(name: Notification.Name.staticBorder, object: self)
        }
    }
    
    @IBAction func blinkBorderControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setBlinkBorderOn, object: self)
        } else if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setBlinkBorderOff, object: self)
            nc.post(name: Notification.Name.staticBorder, object: self)
        }
    }
    
    @IBAction func blinkTimerControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setBlinkTimerOn, object: self)
        } else if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setBlinkTimerOff, object: self)
            nc.post(name: Notification.Name.staticTimer, object: self)
        }
    }
    
    @IBAction func keepCountingControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setContinueCountingOn, object: self)
        } else if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setContinueCountingOff, object: self)
        }
    }
    
    @IBAction func timerFunctionSelector(_ sender: AnyObject) {
        if timerController.timer.isRunning {
            nc.post(name: Notification.Name.setContinueCountingOn, object: self)
            self.repeatButtonPress(self)
        }
        if countUpRadioButton.state == .on {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.showTimer, object: self)
            nc.post(name: Notification.Name.setCountUp, object: self)
        }
        if countDownRadioButton.state == .on {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.showTimer, object: self)
            nc.post(name: Notification.Name.setCountDown, object: self)
        }
        if showDateRadioButton.state == .on {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.staticTimer, object: self)
            nc.post(name: Notification.Name.showDateandTime, object: self)
        }
    }
    
    @IBAction func startButtonPress(_ sender: Any) {
        guard timerController.timer.isRunning == false else {
            nc.post(name: Notification.Name.stopTimer, object: self)
            self.startButton.title = "Start"
            return
        }
        if self.countUpRadioButton.state == .on {
            nc.post(name: Notification.Name.startTimerCountingUp, object: self)
            self.startButton.title = "Stop"
        } else if self.countDownRadioButton.state == .on {
           nc.post(name: Notification.Name.startTimerCountingDown, object: self)
            self.startButton.title = "Stop"
        }
    }
    
    @IBAction func repeatButtonPress(_ sender: Any) {
        if timerController.timer.isRunning == true {
            timerController.stopTheClock()
            self.startButton.title = "Start"
        }
        if self.countUpRadioButton.state == .on {
            nc.post(name: Notification.Name.setCountUp, object: self)
        } else if self.countDownRadioButton.state == .on {
            nc.post(name: Notification.Name.resetTimer, object: self)
        }
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
        } else if timerController.timer.isRunning == false {
            timerController.setTotalTime(timeLimit: totalTime)
            timerController.setWarningTime(warningTime: warningTime)
        }
    }
    
}

extension controlViewController {
    fileprivate func setUpNotifications() {
        nc.addObserver(self, selector: #selector(setUpTime), name: NSText.didEndEditingNotification, object: nil)
        nc.addObserver(self, selector: #selector(timerStartedNotificationAction), name: Notification.Name.timerStarted, object:nil)
        nc.addObserver(self, selector: #selector(warningOnNotificationAction), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(warningOffNotificationAction), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(outOfTimeNotificationAction), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(timerStoppedNotificationAction), name: Notification.Name.timerStopped, object: nil)
        nc.addObserver(self, selector: #selector(didResetTimerNotificationAction), name: Notification.Name.didResetTimer, object:nil)
        nc.addObserver(self, selector: #selector(setWillShowBorderOnNotificationAction), name: Notification.Name.setWillShowBorderOn, object:nil)
        nc.addObserver(self, selector: #selector(setWillShowBorderOffNotificationAction), name: Notification.Name.setWillShowBorderOff, object:nil)
        nc.addObserver(self, selector: #selector(showBorderNotificationAction), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderNotificationAction), name: Notification.Name.hideBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorder), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(staticBorder), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkTimer), name: Notification.Name.blinkTimer, object:nil)
        nc.addObserver(self, selector: #selector(staticTimer), name: Notification.Name.staticTimer, object:nil)
    }
    
    @objc private func timerStartedNotificationAction (notification:Notification) {
        self.setBorderGreen()
    }
    
    @objc private func warningOnNotificationAction (notification:Notification) {
        self.setBorderYellow()
    }
    
    @objc private func warningOffNotificationAction (notification:Notification) {
        self.setBorderGreen()
    }
    
    @objc private func outOfTimeNotificationAction (notification:Notification) {
        self.setBorderRed()
    }
    
    @objc private func timerStoppedNotificationAction (notification:Notification) {
        self.timerStopped()
    }
    
    @objc private func didResetTimerNotificationAction (notification:Notification) {
        self.setBorderGreen()
    }
    
    @objc private func setWillShowBorderOnNotificationAction(notification: Notification) {
        self.willShowBorder = true
    }
    
    @objc private func setWillShowBorderOffNotificationAction(notification: Notification) {
        self.willShowBorder = false
    }
    
    @objc private func showBorderNotificationAction (notification:Notification) {
        self.showBorder()
    }
    
    @objc private func hideBorderNotificationAction (notification:Notification) {
        self.hideBorder()
    }
    
    @objc private func blinkBorderNotificationAction (notification:Notification) {
        self.blinkBorder()
    }
    
    @objc private func staticBorderNotificationAction (notification:Notification) {
        self.staticBorder()
    }
    
    @objc private func blinkTimerNotificationAction (notification:Notification) {
        self.blinkTimer()
    }
    
    @objc private func staticTimerNotificationAction (notification:Notification) {
        self.staticTimer()
    }
}
