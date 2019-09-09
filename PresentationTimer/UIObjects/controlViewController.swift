//
//  ViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewController: NSViewController, NSTextViewDelegate {
    @objc dynamic var displayWindowControl: displayWindowController? = nil
    @objc dynamic var timerController = countdownTimerController
    @IBOutlet weak var timerDisplayTextFieldView: NSView!
    @IBOutlet weak var timerDisplayTextField: NSTextField!
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
    var clockDisplayTextFieldTimer = Timer()
    var blinkBorderTimer = Timer()
    var blinkTimerDisplayTextFieldTimer = Timer()
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
                nc.post(name: Notification.Name.blinkBorder, object: self)
            } else {
                nc.post(name: Notification.Name.staticBorder, object: self)
            }
        }
    }
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
        self.timerDisplayTextField.isBordered = false
        self.timerDisplayTextFieldView.wantsLayer = true
        self.setBorderGreen()
        self.timerDisplayTextFieldView.layer?.borderWidth = 10
        self.timerDisplayTextFieldView.layer?.cornerRadius = 10.0
        self.countDownRadioButton.state = .on
        self.showBorderRadioButton.state = .on
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.minSize = NSSize(width: 1000, height: 545)
    }
    
    override func viewDidAppear() {
        loadDisplayWindow()
        //view.window?.zoom(self)
        self.totalTimeHoursEntryField?.intValue = 0
        self.totalTimeMinutesEntryField?.intValue = 0
        self.totalTimeSecondsEntryField?.intValue = 5
        self.wrapUpTimeHoursEntryField?.intValue = 0
        self.wrapUpTimeMinutesEntryField?.intValue = 0
        self.wrapUpTimeSecondsEntryField?.intValue = 3
        self.setUpTime()
    }
    
    func loadDisplayWindow() {
        let displayWindowControllerSceneID = "displayWindowController"
        self.displayWindowControl = (NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    @objc func setBorderGreen() {
        self.timerDisplayTextFieldView.layer?.borderColor = NSColor.green.cgColor
    }
    
    @objc func setBorderYellow() {
        self.timerDisplayTextFieldView.layer?.borderColor = NSColor.yellow.cgColor
    }
    
    @objc func setBorderRed() {
        self.timerDisplayTextFieldView.layer?.borderColor = NSColor.red.cgColor
    }
    
    @objc func showBorder() {
        if willShowBorder == true {
            self.timerDisplayTextFieldView.layer?.borderWidth = 10
        }
        if willBlinkBorder == true {
            self.blinkBorder()
        }
    }
    
    @objc func hideBorder() {
        if willShowBorder == false {
            self.timerDisplayTextFieldView.layer?.borderWidth = 0
            nc.post(name: Notification.Name.staticBorder, object: self)
        }
    }
    
    @objc func timerStopped() {
        if timerController.timer.isOutOfTime == false {
            self.startButton.title = "Start"
        }
    }
    
    @objc func blinkBorder() {
        print("blinkBorder() start")
        guard timerController.timer.isOutOfTime == true else {
            print("blinkBorder(): Time on the clock.  Can't Blink")
            return
        }
        guard blinkBorderTimer.isValid == false else {
            print("blinkBorder(): blinker timer already running")
            return
        }
        guard willShowBorder == true else {
            print("blinkBorder(): willShowBorder: ",willShowBorder," Can't Blink")
            return
        }
        print("blinkBorder(): setting up blinking borderTimer")
        blinkBorderTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideBorder), userInfo: nil, repeats: true)
        blinkBorderTimer.fire()
    }
    
    @objc func showAndHideBorder() {
        guard willBlinkBorder == true else {
            print("showAndHideBorder() willBlinkBorder: off. Can't Blink")
            return
        }
        guard willShowBorder == true else {
            print("showAndHideBorder() willShowBorder: false.  Can't Blink")
            return
        }
        //print("showAndHideBorder() blink border")
        if self.timerDisplayTextFieldView.layer?.borderWidth == 10 {
            self.timerDisplayTextFieldView.layer?.borderWidth = 0
        } else if self.timerDisplayTextFieldView.layer?.borderWidth == 0 {
            self.timerDisplayTextFieldView.layer?.borderWidth = 10
        }
    }
    
    func staticBorder() {
        print("staticBorder(): stop blinking border")
        blinkBorderTimer.invalidate()
        if self.willShowBorder == true {
            self.showBorder()
        }
    }
    
    func showTimer() {
        self.timerDisplay.isHidden = false
        timerDisplay.textColor = NSColor.textBackgroundColor
        //self.dateDisplayTextField.isHidden = true
        //self.timeDisplayTextField.isHidden = true
        self.clockDisplayTextFieldTimer.invalidate()
        blinkTimerDisplayTextFieldTimer.invalidate()
    }
    
    @objc func blinkTimer() {
        print("blinkTimer() start")
        guard timerController.timer.isOutOfTime == true else {
            print("blinkTimer(): Time on the clock.  Can't Blink")
            return
        }
        guard blinkTimerDisplayTextFieldTimer.isValid == false else {
            print("blinkTimer(): blinker timer already running")
            return
        }
        print("blinkTimer(): setting up blinkingTimer for timerDisplayTextField")
        blinkTimerDisplayTextFieldTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showAndHideTimer), userInfo: nil, repeats: true)
        blinkTimerDisplayTextFieldTimer.fire()
    }
    
    @objc private func showAndHideTimer() {
        guard willBlinkTimer == true else {
            print("showAndHideTimer(): willBlinkTimer: off. Can't Blink")
            return
        }
        guard willShowTimer == true else {
            print("showAndHideTimer(): willShowTimer: false.  Can't Blink")
            return
        }
        print("blink timer")
        let currentTextColor = NSColor.textBackgroundColor
        if self.timerDisplay.textColor == currentTextColor{
            timerDisplay.textColor = NSColor.clear
        } else { timerDisplay.textColor = currentTextColor }
    }
    
    @objc func staticTimer() {
        print("staticTimer(): stop blinking timer")
        blinkTimerDisplayTextFieldTimer.invalidate()
        self.showTimer()
    }
    
    func disableUIControls() {
        self.totalTimeHoursEntryField?.isEditable = false
        self.totalTimeHoursEntryField?.isSelectable = false
        self.totalTimeMinutesEntryField?.isEditable = false
        self.totalTimeMinutesEntryField?.isSelectable = false
        self.totalTimeSecondsEntryField?.isEditable = false
        self.totalTimeSecondsEntryField?.isSelectable = false
        
        self.totalTimeIncreseHoursButton.isEnabled = false
        self.totalTimeIncreseMinutesButton.isEnabled = false
        self.totalTimeIncreaseSecondsButton.isEnabled = false
        self.totalTimeDecreaseHoursButton.isEnabled = false
        self.totalTimeDecreaseMinutesButton.isEnabled = false
        self.totalTimeDecreaseSecondsButton.isEnabled = false
        
        self.wrapUpTimeIncreaseHoursButton.isEnabled = false
        self.wrapUpTimeIncreaseMinutesButton.isEnabled = false
        self.wrapUpTimeIncreaseSecondsButton.isEnabled = false
        self.warpUpTimeDecreaseHoursButton.isEnabled = false
        self.wrapUpTimeDecreaseMinutesButton.isEnabled = false
        self.wrapUpTimeDecreaseSecondsButton.isEnabled = false
    }
    
    func enableUIControls() {
        self.totalTimeHoursEntryField?.isEditable = true
        self.totalTimeHoursEntryField?.isSelectable = true
        self.totalTimeMinutesEntryField?.isEditable = true
        self.totalTimeMinutesEntryField?.isSelectable = true
        self.totalTimeSecondsEntryField?.isEditable = true
        self.totalTimeSecondsEntryField?.isSelectable = true
        
        self.totalTimeIncreseHoursButton.isEnabled = true
        self.totalTimeIncreseMinutesButton.isEnabled = true
        self.totalTimeIncreaseSecondsButton.isEnabled = true
        self.totalTimeDecreaseHoursButton.isEnabled = true
        self.totalTimeDecreaseMinutesButton.isEnabled = true
        self.totalTimeDecreaseSecondsButton.isEnabled = true
        
        self.wrapUpTimeIncreaseHoursButton.isEnabled = true
        self.wrapUpTimeIncreaseMinutesButton.isEnabled = true
        self.wrapUpTimeIncreaseSecondsButton.isEnabled = true
        self.warpUpTimeDecreaseHoursButton.isEnabled = true
        self.wrapUpTimeDecreaseMinutesButton.isEnabled = true
        self.wrapUpTimeDecreaseSecondsButton.isEnabled = true
    }
    
    @IBAction func showBorderControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            self.willShowBorder = true
            nc.post(name: Notification.Name.setWillShowBorderOn, object: self)
            nc.post(name: Notification.Name.showBorder, object: self)
        }
        if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.setWillShowBorderOff, object: self)
            nc.post(name: Notification.Name.hideBorder, object: self)
        }
    }
    
    @IBAction func blinkBorderControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setBlinkBorderOn, object: self)
        }
        if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setBlinkBorderOff, object: self)
        }
    }
    
    @IBAction func blinkTimerControl(_ sender: Any) {
        if (sender as AnyObject).state == .on {
            nc.post(name: Notification.Name.setBlinkTimerOn, object: self)
        } else if (sender as AnyObject).state == .off {
            nc.post(name: Notification.Name.setBlinkTimerOff, object: self)
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
        if countUpRadioButton.state == .on {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.showTimer, object: self)
            nc.post(name: Notification.Name.resetTimer, object: self)
            nc.post(name: Notification.Name.setCountUp, object: self)
        }
        if countDownRadioButton.state == .on {
            nc.post(name: Notification.Name.staticBorder, object: self)
            nc.post(name: Notification.Name.showTimer, object: self)
            nc.post(name: Notification.Name.resetTimer, object: self)
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
            if keepCountingRadioButton.state == .off {
                repeatButtonPress(self)
            }
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
            nc.post(name: Notification.Name.stopTimer, object: self)
            self.startButton.title = "Start"
        }
        nc.post(name: Notification.Name.resetTimer, object: self)
        if self.countUpRadioButton.state == .on {
            nc.post(name: Notification.Name.setCountUp, object: self)
        }
        if self.countDownRadioButton.state == .on {
            nc.post(name: Notification.Name.setCountDown, object: self)
        }
    }
    
    @IBAction func totalTimeIncreaseHoursButtonPress(_ sender: Any) {
        self.totalTimeHoursEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func totalTimeIncreaseMinutesButtonPress(_ sender: Any) {
        self.totalTimeMinutesEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func totalTimeIncreaseSecondsButtonPress(_ sender: Any) {
        self.totalTimeSecondsEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func totalTimeDecreaseHoursButtonPress(_ sender: Any) {
        if totalTimeHoursEntryField!.intValue >= Int32(1) {
            totalTimeHoursEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @IBAction func totalTimeDecreaseMinutesButtonPress(_ sender: Any) {
        if totalTimeMinutesEntryField!.intValue >= Int32(1) {
            totalTimeMinutesEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @IBAction func totalTimeDecreaseSecondsButtonPress(_ sender: Any) {
        if timerController.timer.totalTime.seconds >= Int32(1) {
            totalTimeSecondsEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @IBAction func wrapUpTimeIncreaseHoursButtonPress(_ sender: Any) {
        self.wrapUpTimeHoursEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func wrapUpTimeIncreaseMinutesButtonPress(_ sender: Any) {
        self.wrapUpTimeMinutesEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func wrapUpTimeIncreaseSecondsButtonPress(_ sender: Any) {
        self.wrapUpTimeSecondsEntryField?.intValue += 1
        self.setUpTime()
    }
    
    @IBAction func wrapUpTimeDecreaseHoursButtonPress(_ sender: Any) {
        if wrapUpTimeHoursEntryField!.intValue >= Int32(1) {
            wrapUpTimeHoursEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @IBAction func wrapUpTimeDecreaseMinutesButtonPress(_ sender: Any) {
        if wrapUpTimeMinutesEntryField!.intValue >= Int32(1) {
            wrapUpTimeMinutesEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @IBAction func wrapUpTimeDecreaseSecondsButtonPress(_ sender: Any) {
        if wrapUpTimeSecondsEntryField!.intValue >= Int32(1) {
            wrapUpTimeSecondsEntryField?.intValue -= 1
            self.setUpTime()
        }
    }
    
    @objc func setUpTime() {
        let totalHours = self.totalTimeHoursEntryField?.intValue ?? 0
        let totalMinutes = self.totalTimeMinutesEntryField?.intValue ?? 0
        let totalSeconds = self.totalTimeSecondsEntryField?.intValue ?? 0
        let wrapUpHours = self.wrapUpTimeHoursEntryField?.intValue ?? 0
        let wrapUpMinutes = self.wrapUpTimeMinutesEntryField?.intValue ?? 0
        let wrapUpSeconds = self.wrapUpTimeSecondsEntryField?.intValue ?? 0
        let newTotalTime = time(hours: Int(totalHours), minutes: Int(totalMinutes), seconds: Int(totalSeconds))
        let newWrapUpTime = time(hours: Int(wrapUpHours), minutes: Int(wrapUpMinutes), seconds: Int(wrapUpSeconds))
        self.totalTimeHoursEntryField?.intValue = Int32(newTotalTime.hours)
        self.totalTimeMinutesEntryField?.intValue = Int32(newTotalTime.minutes)
        self.totalTimeSecondsEntryField?.intValue = Int32(newTotalTime.seconds)
        self.wrapUpTimeHoursEntryField?.intValue = Int32(newWrapUpTime.hours)
        self.wrapUpTimeMinutesEntryField?.intValue = Int32(newWrapUpTime.minutes)
        self.wrapUpTimeSecondsEntryField?.intValue = Int32(newWrapUpTime.seconds)
        
        timerController.setTotalTime(timeLimit: newTotalTime)
        timerController.setWarningTime(warningTime: newWrapUpTime)
        
        guard timerController.timer.isRunning == true else {
            if self.countUpRadioButton.state == .on {
                nc.post(name: Notification.Name.setCountUp, object: self)
            } else if self.countDownRadioButton.state == .on {
                nc.post(name: Notification.Name.setCountDown, object: self)
            }
            return
        }
        if self.countDownRadioButton.state == .on {
            timerController.timer.currentTime = newTotalTime
            timerController.timer.currentTime = newTotalTime
        }
    }
}

extension controlViewController {
    fileprivate func setUpNotifications() {nc.addObserver(self, selector: #selector(setUpTime), name: NSText.didEndEditingNotification, object: nil)
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
        nc.addObserver(self, selector: #selector(setBlinkBorderOnNotificationAction), name: Notification.Name.setBlinkBorderOn, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkBorderOffNotificationAction), name: Notification.Name.setBlinkBorderOff, object:nil)
        nc.addObserver(self, selector: #selector(blinkBorderNotificationAction), name: Notification.Name.blinkBorder, object:nil)
        nc.addObserver(self, selector: #selector(staticBorderNotificationAction), name: Notification.Name.staticBorder, object:nil)
        nc.addObserver(self, selector: #selector(showTimerNotificationAction), name: Notification.Name.showTimer, object:nil)
        nc.addObserver(self, selector: #selector(blinkTimerNotificationAction), name: Notification.Name.blinkTimer, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkTimerOnNotificationAction), name: Notification.Name.setBlinkTimerOn, object:nil)
        nc.addObserver(self, selector: #selector(setBlinkTimerOffNotificationAction), name: Notification.Name.setBlinkTimerOff, object:nil)
        nc.addObserver(self, selector: #selector(staticTimerNotificationAction), name: Notification.Name.staticTimer, object:nil)
        nc.addObserver(self, selector: #selector(showDateAndTimeNotificationAction), name: Notification.Name.showDateandTime, object:nil)
        nc.addObserver(self, selector: #selector(setBackgroundColorNotificationAction), name: Notification.Name.setBackgroundColor, object:nil)
    }
    
    @objc private func timerStartedNotificationAction(notification:Notification) {
        if timerController.timer.isOutOfTime == false {
            self.setBorderGreen()
        }
    }
    
    @objc private func warningOnNotificationAction(notification:Notification) {
        self.setBorderYellow()
    }
    
    @objc private func warningOffNotificationAction(notification:Notification) {
        if timerController.timer.isOutOfTime == false {
            self.setBorderGreen()
        }
    }
    
    @objc private func outOfTimeNotificationAction(notification:Notification) {
        //The border will be set to red every time the outOfTime Notification is received
        self.setBorderRed()
        //The timers for the blinking UI elements will only be started when one is not already running
        guard blinkBorderTimer.isValid == false else {
            print("timer Already running")
            return
        }
        if willShowBorder == true && willBlinkBorder == true && timerController.timer.isOutOfTime == true {
            self.blinkBorder()
        }
        if willShowTimer == true && willBlinkTimer == true && timerController.timer.isOutOfTime == true {
            self.blinkTimer()
        }
    }
    
    @objc private func timerStoppedNotificationAction(notification:Notification) {
        self.timerStopped()
    }
    
    @objc private func didResetTimerNotificationAction(notification:Notification) {
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
    
    @objc private func showBorderNotificationAction(notification:Notification) {
        self.showBorder()
    }
    
    @objc private func hideBorderNotificationAction(notification:Notification) {
        self.hideBorder()
    }
    
    @objc private func setBlinkBorderOnNotificationAction(notification:Notification) {
        self.willBlinkBorder = true
    }
    
    @objc private func setBlinkBorderOffNotificationAction(notification:Notification) {
        self.willBlinkBorder = false
    }
    
    @objc private func blinkBorderNotificationAction(notification:Notification) {
        self.blinkBorder()
    }
    
    @objc private func staticBorderNotificationAction(notification:Notification) {
        self.staticBorder()
    }
    
    @objc private func showTimerNotificationAction(notification:Notification) {

    }
    
    @objc private func blinkTimerNotificationAction(notification:Notification) {
        self.blinkTimer()
    }
    
    @objc private func setBlinkTimerOnNotificationAction(notification:Notification) {
        self.willBlinkTimer = true
    }
    
    @objc private func setBlinkTimerOffNotificationAction(notification:Notification) {
        self.willBlinkTimer = false
    }
    
    @objc private func staticTimerNotificationAction(notification:Notification) {
        self.staticTimer()
    }
    
    @objc private func showDateAndTimeNotificationAction(notification:Notification) {
        
    }
    
    @objc private func setBackgroundColorNotificationAction(notification:Notification) {
        
    }
}
