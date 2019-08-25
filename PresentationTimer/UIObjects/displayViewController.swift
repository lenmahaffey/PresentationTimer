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
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer1 = Timer()
    var blinkBorderTimer2 = Timer()
    var blinkClockTimer1 = Timer()
    var blinkClockTimer2 = Timer()
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
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockReset, object:nil)
        nc.addObserver(self, selector: #selector(showBorder), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorder), name: Notification.Name.hideBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorder), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(staticBorder), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkClock), name: Notification.Name.blinkClock, object:nil)
        nc.addObserver(self, selector: #selector(staticClock), name: Notification.Name.staticClock, object:nil)
        nc.addObserver(self, selector: #selector(showDate), name: Notification.Name.showDate, object:nil)
        nc.addObserver(self, selector: #selector(showTimer), name: Notification.Name.showTimer, object:nil)
        nc.addObserver(self, selector: #selector(setBackgroundColor), name: Notification.Name.setBackgroundColor, object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBorderRed()
    }
    
    @objc func startClock() {
        self.clockDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setDateAndTime), userInfo: nil, repeats: true)
        self.clockDisplayTextFieldTimer.fire()
    }
    
    @objc func setDateAndTime() {
        self.dateDisplayTextField.stringValue = currentTime
        self.view.layer?.setNeedsDisplay()
    }
    
    @objc func setBackgroundColor() {
        self.view.layer?.backgroundColor = backgroundColor
    }
    
    @objc func setBorderGreen() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed() {
        self.view.layer?.borderWidth = 50
        self.view.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func hideBorder() {
        self.view.layer?.borderWidth = 0
    }
    
    @objc func showBorder() {
        self.view.layer?.borderWidth = 50
    }

    @objc func hideClock() {
        self.timerDisplayTextField.isHidden = true
    }
    
    @objc func showClock() {
        self.timerDisplayTextField.isHidden = false
    }
    
    @objc func blinkBorder() {
        blinkBorderTimer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideBorder), userInfo: nil, repeats: true)
        blinkBorderTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showBorder), userInfo: nil, repeats: true)
        blinkBorderTimer1.fire()
        blinkBorderTimer2.fire()
    }
    
    @objc func staticBorder() {
        blinkBorderTimer1.invalidate()
        blinkBorderTimer2.invalidate()
        nc.post(name: Notification.Name.showBorder, object: self)
    }
    
    @objc func blinkClock() {
        blinkClockTimer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideClock), userInfo: nil, repeats: true)
        blinkClockTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showClock), userInfo: nil, repeats: true)
        blinkClockTimer1.fire()
        blinkClockTimer2.fire()
    }
    
    @objc func staticClock() {
        blinkClockTimer1.invalidate()
        blinkClockTimer2.invalidate()
        self.timerDisplayTextField.isHidden = false
    }
    
    @objc func showDate() {
        self.startClock()
        setDateAndTime()
        self.timerDisplayTextField.isHidden = true
        self.dateDisplayTextField.isHidden = false
    }
    
    @objc func showTimer() {
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
    }
}
