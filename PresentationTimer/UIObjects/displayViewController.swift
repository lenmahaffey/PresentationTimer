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
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockStarted, object:nil)
        nc.addObserver(self, selector: #selector(setBorderYellow), name: Notification.Name.warningOn, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.warningOff, object:nil)
        nc.addObserver(self, selector: #selector(setBorderRed), name: Notification.Name.outOfTime, object:nil)
        nc.addObserver(self, selector: #selector(setBorderGreen), name: Notification.Name.clockReset, object:nil)
        nc.addObserver(self, selector: #selector(showBorder), name: Notification.Name.showBorder, object:nil)
        nc.addObserver(self, selector: #selector(hideBorder), name: Notification.Name.hideBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorder), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(staticBorder), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(blinkTimer), name: Notification.Name.blinkClock, object:nil)
        nc.addObserver(self, selector: #selector(staticTimer), name: Notification.Name.staticTimer, object:nil)
        nc.addObserver(self, selector: #selector(showDateAndTime), name: Notification.Name.showDateandTime, object:nil)
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
        self.dateDisplayTextField.stringValue = currentDate
        self.timeDisplayTextField.stringValue = currentTime
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
        if displayClock == false {
            self.timerDisplayTextField.isHidden = true
        }
    }
    
    @objc func showClock() {
        if displayClock == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    @objc func blinkBorder() {
        if timerController.timer.isOutOfTime == true {
            blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
            blinkBorderTimer.fire()
        }
    }
    
    @objc func showAndHideBorder() {
        if self.view.layer?.borderWidth == 50 {
            self.view.layer?.borderWidth = 0
        } else if self.view.layer?.borderWidth == 0 {
            self.view.layer?.borderWidth = 50
        }
    }
    
    @objc func staticBorder() {
        blinkBorderTimer.invalidate()
        nc.post(name: Notification.Name.showBorder, object: self)
    }
    
    @objc func blinkTimer() {
        if timerController.timer.isOutOfTime == true {
            blinkClockTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
            blinkClockTimer.fire()
        }
    }
    
    @objc func showAndHideTimer() {
        if self.timerDisplayTextField.isHidden == false {
           self.timerDisplayTextField.isHidden = true
        } else if self.timerDisplayTextField.isHidden == true {
            self.timerDisplayTextField.isHidden = false
        }
    }
    
    @objc func staticTimer() {
        blinkClockTimer.invalidate()
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
    }
    
    @objc func showDateAndTime() {
        self.startClock()
        setDateAndTime()
        self.timerDisplayTextField.isHidden = true
        self.dateDisplayTextField.isHidden = false
        self.timeDisplayTextField.isHidden = false
    }
    
    @objc func showTimer() {
        self.timerDisplayTextField.isHidden = false
        self.dateDisplayTextField.isHidden = true
        self.timeDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
        blinkClockTimer.invalidate()
        blinkBorderTimer.invalidate()
    }
}
