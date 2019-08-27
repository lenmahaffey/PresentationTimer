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
    var displayTimer: Bool = true
    var displayClock: Bool = false
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer = Timer()
    var blinkClockTimer = Timer()
    var blinkTimerDisplayTextFieldTimer = Timer()
    var currentDate: String {
        get {
            let date = DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none)
            return date
        }
    }
    var currentTime: String {
        get {
            let time = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            return time
        }
    }
    @IBOutlet weak var timerDisplayTextField: NSTextField!
    @IBOutlet weak var dateDisplayTextField: NSTextField!
    @IBOutlet weak var timeDisplayTextField: NSTextField!
    @objc dynamic var timerController = countdownTimerController
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    func commonInit() {
        nc.addObserver(self, selector: #selector(timerStartedNotificationAction), name: Notification.Name.timerStarted, object:nil)
        nc.addObserver(self, selector: #selector(warningOnNotificationAction), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(warningOffNotificationAction), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(outOfTimeNotificationAction), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(didResetTimerNotificationAction), name: Notification.Name.didResetTimer, object:nil)
        nc.addObserver(self, selector: #selector(showBorderNotificationAction), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderNotificationAction), name: Notification.Name.hideBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorderNotificationAction), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(staticBorderNotificationAction), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(showTimerNotificationAction), name: Notification.Name.showTimer, object:nil)
        nc.addObserver(self, selector: #selector(blinkTimerNotificationAction), name: Notification.Name.blinkTimer, object:nil)
        nc.addObserver(self, selector: #selector(staticTimerNotificationAction), name: Notification.Name.staticTimer, object:nil)
        nc.addObserver(self, selector: #selector(showDateAndTimeNotificationAction), name: Notification.Name.showDateandTime, object:nil)
        nc.addObserver(self, selector: #selector(setBackgroundColorNotificationAction), name: Notification.Name.setBackgroundColor, object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBorderRed()
    }
    
//Notification Actions
    @objc private func timerStartedNotificationAction() {
        self.setBorderGreen()
    }
    
    @objc private func warningOnNotificationAction() {
        self.setBorderYellow()
    }
    
    @objc private func warningOffNotificationAction() {
        self.setBorderGreen()
    }
    
    @objc private func outOfTimeNotificationAction() {
        self.setBorderRed()
    }
    
    @objc private func didResetTimerNotificationAction() {
        self.setBorderGreen()
    }
    
    @objc private func showBorderNotificationAction() {
        self.showBorder()
    }
    
    @objc private func hideBorderNotificationAction() {
        self.hideBorder()
    }
    
    @objc private func blinkBorderNotificationAction() {
        self.blinkBorder()
    }
    
    @objc private func staticBorderNotificationAction() {
        self.staticBorder()
    }
    
    @objc private func showTimerNotificationAction() {
        self.showTimer()
    }
    
    @objc private func blinkTimerNotificationAction() {
        self.blinkTimer()
    }
    
    @objc private func staticTimerNotificationAction() {
        self.staticTimer()
    }
    
    @objc private func showDateAndTimeNotificationAction() {
        showDateAndTime()
    }
    
    @objc private func setBackgroundColorNotificationAction() {
        self.view.layer?.backgroundColor = backgroundColor
    }
    
    @objc private func startClock() {
        self.clockDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setDateAndTime), userInfo: nil, repeats: true)
        self.clockDisplayTextFieldTimer.fire()
    }
    
    @objc private func setDateAndTime() {
        self.dateDisplayTextField.stringValue = currentDate
        self.timeDisplayTextField.stringValue = currentTime
        self.view.layer?.setNeedsDisplay()
    }
    
//class methods
    func setBorderGreen() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.green.cgColor
    }
    
    func setBorderYellow() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    func setBorderRed() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.red.cgColor
    }
    
    func showBorder() {
        self.view.layer?.borderWidth = 50
    }
    
    func hideBorder() {
        self.view.layer?.borderWidth = 0
    }

    func hideClock() {
        if displayClock == false {
            self.timerDisplayTextField.isHidden = true
        }
    }
    
    func blinkBorder() {
        if timerController.timer.isOutOfTime == true {
            blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
            blinkBorderTimer.fire()
        }
    }
    
    @objc private func showAndHideBorder() {
        if self.view.layer?.borderWidth == 50 {
            self.view.layer?.borderWidth = 0
        } else if self.view.layer?.borderWidth == 0 {
            self.view.layer?.borderWidth = 50
        }
    }
    
    func staticBorder() {
        blinkBorderTimer.invalidate()
        nc.post(name: Notification.Name.showBorder, object: self)
    }
    
    func showClock() {
        if displayClock == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    func showTimer() {
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
        blinkClockTimer.invalidate()
        blinkBorderTimer.invalidate()
    }
    
    func blinkTimer() {
        if timerController.timer.isOutOfTime == true {
            blinkClockTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
            blinkClockTimer.fire()
        }
    }
    
    @objc private func showAndHideTimer() {
        if self.timerDisplayTextField.isHidden == false {
           self.timerDisplayTextField.isHidden = true
        } else if self.timerDisplayTextField.isHidden == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    func staticTimer() {
        blinkClockTimer.invalidate()
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
    }
    
    func showDateAndTime() {
        self.startClock()
        setDateAndTime()
        self.timerDisplayTextField.isHidden = true
        self.dateDisplayTextField.isHidden = false
        self.timeDisplayTextField.isHidden = false
    }
    
    func setBackgroundColor() {
        self.view.layer?.backgroundColor = backgroundColor
    }
}
