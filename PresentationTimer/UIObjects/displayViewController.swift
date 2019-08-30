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
    var willShowBorder: Bool {
        didSet {
            if willShowBorder == true {
                nc.post(name: Notification.Name.showBorder, object: self)
            } else {
                nc.post(name: Notification.Name.hideBorder, object: self)
            }
        }
    }
    var willShowTimer: Bool {
        didSet {
            if willShowTimer == true {
                nc.post(name: Notification.Name.showTimer, object: self)
            } else {
                nc.post(name: Notification.Name.hideTimer, object: self)
            }
        }
    }
    
    var willShowClock: Bool {
        didSet {
            if willShowClock == true {
                nc.post(name: Notification.Name.showClock, object: self)
            } else {
                nc.post(name: Notification.Name.hideClock, object: self)
            }
        }
    }
    
    var willBlinkTimer: Bool {
        didSet  {
            if willBlinkTimer == true {
                nc.post(name: Notification.Name.blinkTimer, object: self)
            } else {
                nc.post(name: Notification.Name.staticTimer, object: self)
            }
        }
    }
    
    var willBlinkBorder: Bool {
        didSet {
            if willBlinkBorder == true {
                print("will blink border")
                nc.post(name: Notification.Name.blinkBorder, object: self)
            } else {
                print("will not blink border")
                nc.post(name: Notification.Name.staticBorder, object: self)
            }
        }
    }
    
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer = Timer()
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
        willShowBorder = true
        willBlinkTimer = false
        willBlinkBorder = false
        willShowTimer = true
        willShowClock = false
        blinkBorderTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
        super.init(coder: coder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        willShowBorder = true
        willBlinkTimer = false
        willBlinkBorder = false
        willShowTimer = true
        willShowClock = false
        blinkBorderTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    func commonInit() {
        self.setUpNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBorderGreen()
    }

    func setBorderGreen() {
        if willShowBorder == true {
            self.view.layer?.borderWidth = 50
            self.view.layer?.borderColor = NSColor.green.cgColor
        }
    }
    
    func setBorderYellow() {
        if willShowBorder == true {
            self.view.layer?.borderWidth = 50
            self.view.layer?.borderColor = NSColor.yellow.cgColor
        }
    }
    
    func setBorderRed() {
        if willShowBorder == true {
            self.view.layer?.borderWidth = 50
            self.view.layer?.borderColor = NSColor.red.cgColor
        }
    }
    
    func showBorder() {
        if willShowBorder == true {
            self.view.layer?.borderWidth = 50
        }
    }
    
    func hideBorder() {
        self.view.layer?.borderWidth = 0
    }
    
    func blinkBorder() {
        if willBlinkBorder == true && willShowBorder == true && timerController.timer.isOutOfTime == true {
            if !blinkBorderTimer.isValid {
                blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
                blinkBorderTimer.fire()
            }
        }
    }
    
    @objc private func showAndHideBorder() {
        guard willShowBorder == true else {
            
            return
        }
        if self.view.layer?.borderWidth == 50 {
            self.view.layer?.borderWidth = 0
        } else if self.view.layer?.borderWidth == 0 {
            self.view.layer?.borderWidth = 50
        }
    }
    
    func staticBorder() {
        blinkBorderTimer.invalidate()
    }
    
    func showTimer() {
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
        blinkBorderTimer.invalidate()
    }
    
    func blinkTimer() {
        if willShowTimer == true && willBlinkTimer == true && timerController.timer.isOutOfTime == true {
            blinkTimerDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
            blinkTimerDisplayTextFieldTimer.fire()
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
        blinkTimerDisplayTextFieldTimer.invalidate()
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
    
    @objc private func startClock() {
        self.clockDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setDateAndTime), userInfo: nil, repeats: true)
        self.clockDisplayTextFieldTimer.fire()
    }
    
    @objc private func setDateAndTime() {
        self.dateDisplayTextField.stringValue = currentDate
        self.timeDisplayTextField.stringValue = currentTime
    }
}

extension displayViewController {
    fileprivate func setUpNotifications () {
        nc.addObserver(self, selector: #selector(timerStartedNotificationAction), name: Notification.Name.timerStarted, object:nil)
        nc.addObserver(self, selector: #selector(warningOnNotificationAction), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(warningOffNotificationAction), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(outOfTimeNotificationAction), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(didResetTimerNotificationAction), name: Notification.Name.didResetTimer, object:nil)
        nc.addObserver(self, selector: #selector(setWillShowBorderOnNotificationAction), name: Notification.Name.setWillShowBorderOn, object:nil)
        nc.addObserver(self, selector: #selector(setWillShowBorderOffNotificationAction), name: Notification.Name.setWillShowBorderOff, object:nil)
        nc.addObserver(self, selector: #selector(showBorderNotificationAction), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorderNotificationAction), name: Notification.Name.hideBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorderNotificationAction), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkBorderOnNotificationAction), name: Notification.Name.setBlinkBorderOn, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkBorderOffNotificationAction), name: Notification.Name.setBlinkBorderOff, object:nil)
        nc.addObserver(self, selector: #selector(staticBorderNotificationAction), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(showTimerNotificationAction), name: Notification.Name.showTimer, object:nil)
        nc.addObserver(self, selector: #selector(blinkTimerNotificationAction), name: Notification.Name.blinkTimer, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkTimerOnNotificationAction), name: Notification.Name.setBlinkTimerOn, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkTimerOffNotificationAction), name: Notification.Name.setBlinkTimerOff, object:nil)
        nc.addObserver(self, selector: #selector(staticTimerNotificationAction), name: Notification.Name.staticTimer, object:nil)
        nc.addObserver(self, selector: #selector(showDateAndTimeNotificationAction), name: Notification.Name.showDateandTime, object:nil)
        nc.addObserver(self, selector: #selector(setBackgroundColorNotificationAction), name: Notification.Name.setBackgroundColor, object:nil)
    }
    
    @objc private func timerStartedNotificationAction(notification: Notification) {
        self.setBorderGreen()
    }
    
    @objc private func warningOnNotificationAction(notification: Notification) {
        self.setBorderYellow()
    }
    
    @objc private func warningOffNotificationAction(notification: Notification) {
        self.setBorderGreen()
    }
    
    @objc private func outOfTimeNotificationAction(notification: Notification) {
        if blinkBorderTimer.isValid{
            return
        }
        if willShowBorder  == true {
            self.setBorderRed()
        }
        if willBlinkTimer == true {
            self.blinkTimer()
        }
        if willBlinkBorder == true {
            self.blinkBorder()
        }
    }
    
    @objc private func didResetTimerNotificationAction(notification: Notification) {
        self.staticTimer()
        self.staticBorder()
        self.setBorderGreen()
    }
    
    @objc private func setWillShowBorderOnNotificationAction(notification: Notification) {
        self.willShowBorder = true
    }
    
    @objc private func setWillShowBorderOffNotificationAction(notification: Notification) {
        self.willShowBorder = false
    }
    
    @objc private func showBorderNotificationAction(notification: Notification) {
        self.showBorder()
    }
    
    @objc private func hideBorderNotificationAction(notification: Notification) {
        self.hideBorder()
    }
    
    @objc private func blinkBorderNotificationAction(notification: Notification) {
        self.blinkBorder()
    }
    
    @objc private func setBlinkBorderOnNotificationAction(notification: Notification) {
        willBlinkBorder = true
    }
    
    @objc private func setBlinkBorderOffNotificationAction(notification: Notification) {
        self.willBlinkBorder = false
    }
    
    @objc private func staticBorderNotificationAction(notification: Notification) {
        self.staticBorder()
    }
    
    @objc private func showTimerNotificationAction(notification: Notification) {
        self.showTimer()
    }
    
    @objc private func blinkTimerNotificationAction(notification: Notification) {
        self.blinkTimer()
    }
    
    @objc private func setBlinkTimerOnNotificationAction(notification: Notification) {
        self.willBlinkTimer = true
    }
    
    @objc private func setBlinkTimerOffNotificationAction(notification: Notification) {
        self.willBlinkTimer = false
    }
    
    @objc private func staticTimerNotificationAction(notification: Notification) {
        self.staticTimer()
    }
    
    @objc private func showDateAndTimeNotificationAction(notification: Notification) {
        showDateAndTime()
    }
    
    @objc private func setBackgroundColorNotificationAction(notification: Notification) {
        self.view.layer?.backgroundColor = backgroundColor
    }
}

