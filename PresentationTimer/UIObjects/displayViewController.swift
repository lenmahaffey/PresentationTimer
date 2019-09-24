//
//  displayViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewController: NSViewController {
    
    @IBOutlet weak var timerDisplayTextField: NSTextField!
    @IBOutlet weak var dateDisplayTextField: NSTextField!
    @IBOutlet weak var timeDisplayTextField: NSTextField!
    @objc dynamic var timerController = countdownTimerController
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer = Timer()
    var blinkTimerDisplayTextFieldTimer = Timer()
    var willShowBorder: Bool {
        didSet {
            if willShowBorder == true {
                self.showBorder()
            } else {
                self.hideBorder()
            }
        }
    }
    var willShowTimer: Bool {
        didSet {
            if willShowTimer == true {
                self.showTimer()
            } else {
                self.hideBorder()
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
                self.blinkTimer()
            } else {
                self.staticTimer()
            }
        }
    }
    var willBlinkBorder: Bool{
        didSet {
            if willBlinkBorder == true {
                self.blinkBorder()
            } else {
                self.staticBorder()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        willShowBorder = true
        willBlinkTimer = false
        willBlinkBorder = false
        willShowTimer = true
        willShowClock = false
        blinkBorderTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
        super.init(coder: coder)
        self.setUpNotifications()
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
        self.setUpNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBorderGreen()
        self.showBorder()
    }
    
    override func viewDidAppear() {
        timerDisplayTextField.backgroundColor = NSColor.red
    }
    
    func setTimerDisplayTextFieldSize() {
        timerDisplayTextField.frame.size = getSizeForTextDrawing(stringToSize: self.timerDisplayTextField.attributedStringValue)
    }
    
    func getSizeForTextDrawing(stringToSize: NSAttributedString) -> NSSize {
        let currentFont = stringToSize.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)
        let attributes = [NSAttributedString.Key.font: currentFont]
        let placeHolderAttributedString = NSAttributedString(string: "55H 55M 55S", attributes: attributes as [NSAttributedString.Key : Any])
        return placeHolderAttributedString.size()
    }
    
    func setBorderGreen() {
        self.view.layer?.borderColor = NSColor.green.cgColor
    }
    
    func setBorderYellow() {
        self.view.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    func setBorderRed() {
        self.view.layer?.borderColor = NSColor.red.cgColor
    }

    func showBorder() {
        if willShowBorder == true {
            self.view.layer?.borderWidth = 50
        }
        if willBlinkBorder == true {
            self.blinkBorder()
        }
    }
    
    func hideBorder() {
        if willShowBorder == false {
            self.view.layer?.borderWidth = 0
            self.staticBorder()
        }
    }
    
    func blinkBorder() {
        guard timerController.timer.isOutOfTime == true else {
            return
        }
        guard blinkBorderTimer.isValid == false else {
            return
        }
        guard willShowBorder == true else {
            return
        }
        blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
        blinkBorderTimer.fire()
    }
    
    @objc private func showAndHideBorder() {
        guard willBlinkBorder == true else {
            return
        }
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
        if self.willShowBorder == true {
            self.showBorder()
        }
    }
    
    func showTimer() {
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
    }
    
    func blinkTimer() {
        guard timerController.timer.isOutOfTime == true else {
            return
        }
        guard blinkTimerDisplayTextFieldTimer.isValid == false else {
            return
        }
        blinkTimerDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
        blinkBorderTimer.fire()
    }
    
    @objc private func showAndHideTimer() {
        guard willBlinkTimer == true else {
            return
        }
        guard willShowTimer == true else {
            return
        }
        if self.timerDisplayTextField.isHidden == false {
           self.timerDisplayTextField.isHidden = true
        } else if self.timerDisplayTextField.isHidden == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    func staticTimer() {
        blinkTimerDisplayTextFieldTimer.invalidate()
        self.showTimer()
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
    
    func setFontColor() {
        self.timerDisplayTextField.textColor = fontColor
    }
    
    @objc private func startClock() {
        self.clockDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setDateAndTime), userInfo: nil, repeats: true)
        self.clockDisplayTextFieldTimer.fire()
    }
    
    @objc private func setDateAndTime() {
        self.dateDisplayTextField.stringValue = time(timeToCountInSeconds: 0).currentDate
        self.timeDisplayTextField.stringValue =  time(timeToCountInSeconds: 0).currentTime
    }
}

extension displayViewController {
    fileprivate func setUpNotifications () {
        nc.addObserver(self, selector: #selector(timerStartedNotificationAction), name: Notification.Name.timerStarted, object:nil)
        nc.addObserver(self, selector: #selector(warningOnNotificationAction), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(warningOffNotificationAction), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(outOfTimeNotificationAction), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(timerStoppedNotificationAction), name: Notification.Name.timerStopped, object:nil)
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
        nc.addObserver(self, selector: #selector(setFontColorNotificationAction), name: Notification.Name.setFontColor, object:nil)
        nc.addObserver(self, selector: #selector(setFontNotificationAction), name: Notification.Name.setFont, object:nil)
    }
    
    @objc private func timerStartedNotificationAction(notification: Notification) {
        if timerController.timer.isOutOfTime == false {
            self.setBorderGreen()
        }
    }
    
    @objc private func warningOnNotificationAction(notification: Notification) {
        self.setBorderYellow()
    }
    
    @objc private func warningOffNotificationAction(notification: Notification) {
        if timerController.timer.isOutOfTime == false {
            self.setBorderGreen()
        }
    }
    
    @objc private func outOfTimeNotificationAction(notification: Notification) {
        //The border will be set to red every time the outOfTime Notification is received
        self.setBorderRed()
        //The timers for the blinking UI elements will only be started when one is not already running
        guard blinkBorderTimer.isValid == false else {
            return
        }
        if willShowBorder == true && willBlinkBorder == true && timerController.timer.isOutOfTime == true {
            self.blinkBorder()
        }
        if willShowTimer == true && willBlinkTimer == true && timerController.timer.isOutOfTime == true {
            self.blinkTimer()
        }
    }
    
    @objc private func timerStoppedNotificationAction(notification: Notification) {
        self.staticTimer()
        self.staticBorder()
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
        print(notification)
        self.showBorder()
    }
    
    @objc private func hideBorderNotificationAction(notification: Notification) {
        print(notification)
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
    
    @objc private func setFontColorNotificationAction(notification: Notification) {
        timerDisplayTextField.textColor = fontColor
    }
    
    @objc private func setFontNotificationAction(notification: Notification) {
        timerDisplayTextField.font = NSFont.bestFittingFont(for: timerDisplayTextField.stringValue, in: timerDisplayTextField.frame, fontDescriptor: currentSelectedFont.fontDescriptor)
    }
}

