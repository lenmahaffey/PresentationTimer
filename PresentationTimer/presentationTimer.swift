//
//  displayTimer.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 4/9/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

var countdownTimerController = presentationTimerController(timeLimit: 0, warningTime: 0)

extension Notification.Name {
    //Timer Actions
    static let startTimerCountingUp = Notification.Name("startTimerCountingUp")
    static let startTimerCountingDown = Notification.Name("startTimerCountingDown")
    static let timerStarted = Notification.Name("timerStarted")
    static let stopTimer = Notification.Name("stopTimer")
    static let timerStopped = Notification.Name("timerStopped")
    static let didResetTimer = Notification.Name("didResetTimer")
    static let resetTimer = Notification.Name("resetTimer")
    static let outOfTime = Notification.Name("outOfTime")
    static let showDateandTime = Notification.Name("showDateAndTime")
    //Timer Behaviors
    static let setCountUp = Notification.Name("setCountUp")
    static let setCountDown = Notification.Name("setCountDown")
    static let setContinueCountingOn = Notification.Name("setContinueCountingOn")
    static let setContinueCountingOff = Notification.Name("setContinueCountingOff")
    static let setUpTime = Notification.Name("setUpTime")
    //UI Actions
    static let warningOn = Notification.Name("warningOn")
    static let warningOff = Notification.Name("warningOff")
    static let showBorder = Notification.Name("showBorder")
    static let setWillShowBorderOn = Notification.Name("setWillShowBorderOn")
    static let setWillShowBorderOff = Notification.Name("setWillShowBorderOff")
    static let blinkBorder = Notification.Name("blinkBorder")
    static let setBlinkBorderOn = Notification.Name("setBlinkBorderOn")
    static let setBlinkBorderOff = Notification.Name("setBlinkBorderOff")
    static let staticBorder = Notification.Name("staticBorder")
    static let hideBorder = Notification.Name("hideBorder")
    static let setGreenBorder = Notification.Name("setGreenBorder")
    static let setYellowBorder = Notification.Name("setYellowBorder")
    static let setRedBorder = Notification.Name("setRedBorder")
    static let showTimer = Notification.Name("showTimer")
    static let hideTimer = Notification.Name("hideTimer")
    static let blinkTimer = Notification.Name("blinkTimer")
    static let setBlinkTimerOn = Notification.Name("setBlinkTimerOn")
    static let setBlinkTimerOff = Notification.Name("setBlinkTimerOff")
    static let staticTimer = Notification.Name("staticTimer")
    static let setBackgroundColor = Notification.Name("setBackgroundColor")
    static let showClock = Notification.Name("showClock")
    static let hideClock = Notification.Name("hideClock")
}

class presentationTimerController: NSObject {
    @objc dynamic var timer: presentationTimer
    let nc = NotificationCenter.default
    
    init (timeLimit: Int, warningTime: Int){
        self.timer = presentationTimer(secondsToCount: timeLimit, warningTime: warningTime)
        super.init()
        setUpNotifications()
    }
    
    @objc func setwillContinueCountingOn() {
        self.timer.willContinueCounting = true
    }
    
    @objc func setwillContinueCountingOff() {
        self.timer.willContinueCounting = false
    }
    
    @objc func setCountDown() {
        //print("willSetCountDown: currentTime: ", timer.currentTime.timeInSeconds, "totalTime: ", timer.totalTime.timeInSeconds)
        self.timer.currentTime.timeInSeconds = self.timer.totalTime.timeInSeconds
        //print("didSetCountDown: currentTime: ", timer.currentTime.timeInSeconds, "totalTime: ", timer.totalTime.timeInSeconds)
    }
    
    @objc func setCountUp() {
        //print("willSetCountDown: currentTime: ", timer.currentTime.timeInSeconds, "totalTime: ", timer.totalTime.timeInSeconds)
        self.timer.currentTime.timeInSeconds = 0
        //print("didSetCountDown: currentTime: ", timer.currentTime.timeInSeconds, "totalTime: ", timer.totalTime.timeInSeconds)
    }
    
    func setTime(timeLimit: time, warningTime: time) {
        self.timer.totalTime.timeInSeconds = timeLimit.timeInSeconds
        self.timer.currentTime.timeInSeconds = timeLimit.timeInSeconds
        self.timer.warningTime.timeInSeconds = warningTime.timeInSeconds
    }
    
    func setTotalTime(timeLimit: time) {
        self.timer.totalTime.timeInSeconds = timeLimit.timeInSeconds
        self.timer.currentTime.timeInSeconds = timeLimit.timeInSeconds
    }
    
    func setWarningTime(warningTime: time) {
        self.timer.warningTime.timeInSeconds = warningTime.timeInSeconds
    }
    
    func changeCurrentTime(newTime: time) {
        let totalSecondsToChange = self.timer.totalTime.timeInSeconds - newTime.timeInSeconds
        self.timer.currentTime.timeInSeconds += totalSecondsToChange
    }
    
    func countDown() {
        self.timer.countDown()
    }
    
    func countUp() {
        self.timer.countUp()
    }
    
    func stopTheClock() {
        timer.stopTheClock()
        
    }
    
    func resetTheClock() {
        timer.resetTheClock()
    }
}

extension presentationTimerController {
    fileprivate func setUpNotifications() {
        nc.addObserver(self, selector: #selector(stopTimerNotificationAction), name: Notification.Name.stopTimer, object: nil)
        nc.addObserver(self, selector: #selector(resetTimerNotificationAction), name: Notification.Name.resetTimer, object: nil)
        nc.addObserver(self, selector: #selector(setContinueCountingOnNotificationAction), name: Notification.Name.setContinueCountingOn, object:nil)
        nc.addObserver(self, selector: #selector(setContinueCountingOffNotificationAction), name: Notification.Name.setContinueCountingOff, object:nil)
        nc.addObserver(self, selector: #selector(setCountUpNotificationAction), name: Notification.Name.setCountUp, object:nil)
        nc.addObserver(self, selector: #selector(setCountDownNotificationAction), name: Notification.Name.setCountDown, object:nil)
        nc.addObserver(self, selector: #selector(startTimerCountingUpNotificationAction), name: Notification.Name.startTimerCountingUp, object:nil)
        nc.addObserver(self, selector: #selector(startTimerCountingDownNotificationAction), name: Notification.Name.startTimerCountingDown, object:nil)
        
    }
    
    @objc private func stopTimerNotificationAction(notification: Notification) {
        self.stopTheClock()
    }
    
    @objc private func resetTimerNotificationAction(notification: Notification) {
        self.resetTheClock()
    }
    
    @objc private func setContinueCountingOnNotificationAction(notification: Notification) {
        setwillContinueCountingOn()
    }
    
    @objc private func setContinueCountingOffNotificationAction(notification: Notification) {
        setwillContinueCountingOff()
    }
    
    @objc private func setCountUpNotificationAction(notification: Notification) {
        self.setCountUp()
    }
    
    @objc private func setCountDownNotificationAction(notification: Notification) {
        self.setCountDown()
    }
    
    @objc private func startTimerCountingUpNotificationAction(notification: Notification) {
        self.countUp()
    }
    
    @objc private func startTimerCountingDownNotificationAction(notification: Notification) {
        self.countDown()
    }
}

class presentationTimer: NSObject {
    @objc dynamic var totalTime: time
    @objc dynamic var currentTime: time
    @objc dynamic var warningTime: time
    var isRunning: Bool{
        didSet {
            if isRunning == true {
                nc.post(name: Notification.Name.timerStarted, object: self)
            } else {
                nc.post(name: Notification.Name.timerStopped, object: self)
            }
        }
    }
    var isOutOfTime: Bool {
        didSet {
            if isOutOfTime == true {
                nc.post(name: Notification.Name.outOfTime, object: self)
            }
        }
    }
    var willContinueCounting: Bool
    var nc = NotificationCenter.default
    private var timer = Timer()
    
    init(secondsToCount: Int, warningTime: Int) {
        self.totalTime = time(timeToCountInSeconds: secondsToCount)
        self.currentTime = time(timeToCountInSeconds: secondsToCount)
        self.warningTime = time(timeToCountInSeconds: warningTime)
        self.isRunning = false
        self.isOutOfTime = false
        self.willContinueCounting = false
    }
    
    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int, warningTime: time) {
        self.totalTime = time(hours: Int(hoursToCount), minutes: Int(minutesToCount), seconds: Int(secondsToCount))
        self.currentTime = totalTime
        self.warningTime = warningTime
        self.isRunning = false
        self.isOutOfTime = false
        self.willContinueCounting = false
    }
    
    func setTime(totalTime: time, warningTime: time) {
        self.totalTime = totalTime
        self.warningTime = warningTime
    }
    
    func countDown() {
        guard isRunning == false else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(decreaseTimeByOneSecond), userInfo: nil, repeats: true)
        timer.fire()
        isRunning = true
    }
    
    func countUp() {
        guard isRunning == false else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(increaseTimeByOneSecond), userInfo: nil, repeats: true)
        timer.fire()
        isRunning = true
    }
    
    @objc func decreaseTimeByOneSecond() {
        //print("decrease one second")
        guard self.willContinueCounting == false else {
            //print("will continue counting")
            currentTime.timeInSeconds -= 1
            checkCountDownWarning()
            return
        }
        //print("will not continue counting")
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds -= 1
            checkCountDownWarning()
        }
    }
    
    @objc func increaseTimeByOneSecond() {
        //print("increase one second")
        guard self.willContinueCounting == false else {
            //print("will continue counting")
            currentTime.timeInSeconds += 1
            checkCountUpWarning()
            return
        }
        //print("will not continue counting")
        if currentTime.timeInSeconds < self.totalTime.timeInSeconds {
            currentTime.timeInSeconds += 1
            checkCountUpWarning()
        }
    }
    
    func checkCountDownWarning() {
        if currentTime.timeInSeconds == 0  {
            if self.isOutOfTime == false {
                self.isOutOfTime = true
                return
            }
        }
        if isOutOfTime == false {
            if currentTime.timeInSeconds <= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warningOn, object: self)
            }
            if currentTime.timeInSeconds > warningTime.timeInSeconds {
                nc.post(name:Notification.Name.warningOff, object: self)
            }
        }
    }
    
    func checkCountUpWarning() {
        if currentTime.timeInSeconds == totalTime.timeInSeconds  {
            if self.isOutOfTime == false {
                self.isOutOfTime = true
                return
            }
        }
        if isOutOfTime == false {
            if currentTime.timeInSeconds >= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warningOn, object: self)
            }
            if currentTime.timeInSeconds < warningTime.timeInSeconds {
                nc.post(name:Notification.Name.warningOff, object: self)
            }
        }
    }
    
    func stopTheClock() {
        guard isRunning == true else {
            return
        }
        timer.invalidate()
        isRunning = false
    }
    
    func resetTheClock() {
        if isRunning == true {
            stopTheClock()
            self.isOutOfTime = false
        }
        self.isOutOfTime = false
        nc.post(name: Notification.Name.didResetTimer, object: self)
    }
}

class time: NSObject, NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return Swift.type(of:self).init(timeToCountInSeconds: self.timeInSeconds)
    }
    
    @objc dynamic var timeInSeconds: Int {
        willSet {
            self.willChangeValue(forKey: "timeInSeconds")
            self.willChangeValue(forKey: "hours")
            self.willChangeValue(forKey: "minutes")
            self.willChangeValue(forKey: "seconds")
            self.willChangeValue(forKey: "totalTimeAsString")
        }
        didSet {
            self.didChangeValue(forKey: "timeInSeconds")
            self.didChangeValue(forKey: "hours")
            self.didChangeValue(forKey: "minutes")
            self.didChangeValue(forKey: "seconds")
            self.didChangeValue(forKey: "totalTimeAsString")
        }
    }
    @objc dynamic var hours: Int {
        get {
            return abs(timeInSeconds / 3600)
        }
    }
    
    @objc dynamic var minutes: Int {
        get {
            let totalMinutes = timeInSeconds / 60
            if totalMinutes > 59 {
                return totalMinutes % 60
            }
            return abs(totalMinutes)
        }
    }
    
    @objc dynamic var seconds: Int {
        get {
            if timeInSeconds > 59 {
                return timeInSeconds % 60
            }
            return abs(timeInSeconds)
        }
    }
    
    @objc dynamic var totalTimeAsString: String {
        get {
            return String(hours) + "h " + String(minutes) + "m " + String(seconds) + "s"
        }
    }
    
    required init(timeToCountInSeconds: Int) {
        self.timeInSeconds = timeToCountInSeconds
    }
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.timeInSeconds = (Int(hours) * 3600) + (Int(minutes) * 60) + (Int(seconds))
    }
}
