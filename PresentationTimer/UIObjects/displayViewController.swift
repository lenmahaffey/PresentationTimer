//
//  displayViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewController: NSViewController {
    
    @IBOutlet weak var timerDisplayTextField: timerDisplayTextField!
    @IBOutlet weak var dateDisplayTextField: NSTextField!
    @IBOutlet weak var timeDisplayTextField: NSTextField!
    @objc dynamic var timerController = countdownTimerController
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer = Timer()
    var blinkTimerDisplayTextFieldTimer = Timer()
    var willShowBorder: Bool
    var willShowTimer: Bool
    var willShowClock: Bool
    var willBlinkTimer: Bool
    var willBlinkBorder: Bool
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
        self.timerDisplayTextField.backgroundColor = NSColor.red
    }
    
    override func viewDidAppear() {
        setTimerDisplayTextFieldSize()
        //timerDisplayTextField.backgroundColor = NSColor.red
    }
    
    func setTimerDisplayTextFieldSize() {
        print(timerDisplayTextField.frame.size.height)
        print(timeDisplayTextField.frame.size.width)
        let currentFont = timerDisplayTextField.attributedStringValue.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)
        let attributes = [NSAttributedString.Key.font: currentFont]
        let placeHolderAttributedString = NSAttributedString(string: "55H 55M 55S", attributes: attributes as [NSAttributedString.Key : Any])
        print(type(of: placeHolderAttributedString))
        print("placeHolder font: ", placeHolderAttributedString.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)!)
        print("placeHolder string: ", placeHolderAttributedString.string)
        print("placeHolder height: ", placeHolderAttributedString.size().height)
        print("placeHolder width: ", placeHolderAttributedString.size().width)
        print(timerDisplayTextField.frame)
        timerDisplayTextField.frame = NSRect(x: (self.view.frame.maxX / 2) - (placeHolderAttributedString.size().width / 2),
                            y: (self.view.frame.maxY / 2) - (placeHolderAttributedString.size().height / 2),
                            width: placeHolderAttributedString.size().width,
                            height: placeHolderAttributedString.size().height)
        print("??", timerDisplayTextField.frame)
        timerDisplayTextField.backgroundColor = NSColor.blue
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
            nc.post(name: Notification.Name.staticBorder, object: self)
        }
    }
    
    func blinkBorder() {
        guard timerController.timer.isOutOfTime == true else {
            //print("blinkBorder(): Time on the clock.  Can't Blink")
            return
        }
        guard blinkBorderTimer.isValid == false else {
            //print("blinkBorder(): blinker timer already running")
            return
        }
        guard willShowBorder == true else {
            //print("blinkBorder(): willShowBorder: ",willShowBorder," Can't Blink")
            return
        }
        //print("blinkBorder(): setting up blinking borderTimer")
        blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
        blinkBorderTimer.fire()
    }
    
    @objc private func showAndHideBorder() {
        guard willBlinkBorder == true else {
            //print("showAndHideBorder() willBlinkBorder: off. Can't Blink")
            return
        }
        guard willShowBorder == true else {
            //print("showAndHideBorder() willShowBorder: false.  Can't Blink")
            return
        }
        //print("showAndHideBorder() blink border")
        if self.view.layer?.borderWidth == 50 {
            self.view.layer?.borderWidth = 0
        } else if self.view.layer?.borderWidth == 0 {
            self.view.layer?.borderWidth = 50
        }
    }
    
    func staticBorder() {
        //print("staticBorder(): stop blinking border")
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
            //print("Time on the clock.  Can't Blink")
            return
        }
        guard blinkTimerDisplayTextFieldTimer.isValid == false else {
            //print("blinker timer already running")
            return
        }
        //print("setting up blinkingTimer for timerDisplayTextField")
        blinkTimerDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
        blinkBorderTimer.fire()
    }
    
    @objc private func showAndHideTimer() {
        guard willBlinkTimer == true else {
            //print("willBlinkTimer: off. Can't Blink")
            return
        }
        guard willShowTimer == true else {
            //print("willShowTimer: false.  Can't Blink")
            return
        }
        //print("blink timer")
        if self.timerDisplayTextField.isHidden == false {
           self.timerDisplayTextField.isHidden = true
        } else if self.timerDisplayTextField.isHidden == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    func staticTimer() {
        //print("stop blinking timer")
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
        nc.addObserver(self, selector: #selector(setTimerDisplayTextColorNotificationAction), name: Notification.Name.setTimerDisplayTextColor, object:nil)
        nc.addObserver(self, selector: #selector(setTimerDisplayFontNotificationAction), name: Notification.Name.setTimerDisplayFont, object:nil)
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
            //print("timer Already running")
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
        print(notification)
        self.willShowBorder = true
    }
    
    @objc private func setWillShowBorderOffNotificationAction(notification: Notification) {
        print(notification)
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
    
    @objc private func setTimerDisplayTextColorNotificationAction(notification: Notification) {
        timerDisplayTextField.textColor = fontColor
    }
    
    @objc private func setTimerDisplayFontNotificationAction(notification: Notification) {
        timerDisplayTextField.font = selectedFont
        setTimerDisplayTextFieldSize()
    }
}

