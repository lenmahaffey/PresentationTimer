//
//  displayTimer.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 4/9/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

var countdownTimerController = presentationTimerController(timeLimit: 10, warningTime: 5)

extension Notification.Name {
    static let startCountingUp = Notification.Name("startCountingDown")
    static let startCountingDown = Notification.Name("startCountingDown")
    static let timerStarted = Notification.Name("timerStarted")
    static let stopTimer = Notification.Name("stopTimer")
    static let timerStopped = Notification.Name("timerStopped")
    static let resetTimer = Notification.Name("resetTimer")
    static let timerReset = Notification.Name("timerReset")
    static let warningOn = Notification.Name("warningOn")
    static let warningOff = Notification.Name("warningOff")
    static let outOfTime = Notification.Name("outOfTime")
    static let showBorder = Notification.Name("showBorder")
    static let hideBorder = Notification.Name("hideBorder")
    static let setGreenBorder = Notification.Name("setGreenBorder")
    static let setYellowBorder = Notification.Name("setYellowBorder")
    static let setRedBorder = Notification.Name("setRedBorder")
    static let setCountUp = Notification.Name("setCountUp")
    static let setCountDown = Notification.Name("setCountDown")
    static let stopCounting = Notification.Name("stopCounting")
    static let continueCounting = Notification.Name("continueCounting")
    static let showDate = Notification.Name("showDate")
    static let showTimer = Notification.Name("showTimer")
    static let blinkBorder = Notification.Name("blinkBorder")
    static let staticBorder = Notification.Name("staticBorder")
    static let blinkTimer = Notification.Name("blinkTimer")
    static let staticTimer = Notification.Name("staticTimer")
    static let setBackgroundColor = Notification.Name("setBackgroundColor")
}

class presentationTimerController: NSObject {
    @objc dynamic var timer: presentationTimer
    let nc = NotificationCenter.default
    
    init (timeLimit: Int, warningTime: Int){
        self.timer = presentationTimer(secondsToCount: timeLimit, warningTime: warningTime)
        super.init()
        nc.addObserver(self, selector: #selector(startCountingUpNotificationAction), name: Notification.Name.startCountingUp, object: nil)
        nc.addObserver(self, selector: #selector(startCountingDownNotificationAction), name: Notification.Name.startCountingDown, object: nil)
        nc.addObserver(self, selector: #selector(stopTimerNotificationAction), name: Notification.Name.stopTimer, object: nil)
        nc.addObserver(self, selector: #selector(resetTimerNotificationAction), name: Notification.Name.resetTimer, object: nil)
        nc.addObserver(self, selector: #selector(continueCountingNotificationAction), name: Notification.Name.continueCounting, object:nil)
        nc.addObserver(self, selector: #selector(setStopCountingNotificationAction), name: Notification.Name.stopCounting, object:nil)
        nc.addObserver(self, selector: #selector(setCountUpNotificationAction), name: Notification.Name.setCountUp, object:nil)
        nc.addObserver(self, selector: #selector(setCountDownNotificationAction), name: Notification.Name.setCountDown, object:nil)
    }
    
    @objc func startCountingUpNotificationAction() {
        countUp()
    }
    
    @objc func startCountingDownNotificationAction() {
        countDown()
    }
    
    @objc func stopTimerNotificationAction() {
        stopTheClock()
    }
    
    @objc func resetTimerNotificationAction() {
        resetTheClock()
    }
    
    @objc func continueCountingNotificationAction() {
        self.timer.continueCounting = true
    }
    
    @objc func setStopCountingNotificationAction() {
        self.timer.continueCounting = false
    }
    
    @objc func setCountUpNotificationAction() {
        self.timer.currentTime.timeInSeconds = 0
    }
    
    @objc func setCountDownNotificationAction() {
        self.timer.currentTime.timeInSeconds = self.timer.totalTime.timeInSeconds
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

class presentationTimer: NSObject {
    @objc dynamic var totalTime: time
    @objc dynamic var currentTime: time
    @objc dynamic var warningTime: time
    var isRunning: Bool {
        didSet (value) {
            if value {
                nc.post(name: Notification.Name.timerStarted, object: self)
            } else if !value {
                nc.post(name: Notification.Name.timerStopped, object: self)
            }
        }
    }
    var isOutOfTime: Bool {
        didSet (value) {
            if value == true {
                nc.post(name: Notification.Name.outOfTime, object: self)
            }
        }
    }
    
    var continueCounting: Bool
    var nc = NotificationCenter.default
    private var timer = Timer()
    
    init(secondsToCount: Int, warningTime: Int) {
        self.totalTime = time(timeToCountInSeconds: secondsToCount)
        self.currentTime = time(timeToCountInSeconds: secondsToCount)
        self.warningTime = time(timeToCountInSeconds: warningTime)
        self.isRunning = true
        self.isOutOfTime = true
        self.continueCounting = false
    }

    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int, warningTime: time) {
        self.totalTime = time(hours: Int(hoursToCount), minutes: Int(minutesToCount), seconds: Int(secondsToCount))
        self.currentTime = totalTime
        self.warningTime = warningTime
        self.isRunning = false
        self.isOutOfTime = false
        self.continueCounting = false
    }
    
    func countDown() {
        guard isRunning == false else {
            return
        }
        nc.post(name: Notification.Name.timerStarted, object: self)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(decreaseTimeByOneSecond), userInfo: nil, repeats: true)
        timer.fire()
        isRunning = true
    }
    
    func countUp() {
        guard isRunning == false else {
            return
        }
        nc.post(name: Notification.Name.timerStarted, object: self)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(increaseTimeByOneSecond), userInfo: nil, repeats: true)
        timer.fire()
        isRunning = true
    }
    
    @objc func decreaseTimeByOneSecond() {
        if self.continueCounting == true {
            currentTime.timeInSeconds -= 1
            checkCountDownWarning()
        } else if self.continueCounting == false {
            if currentTime.timeInSeconds <= 0 {
                setIsOutOfTime()
            } else if currentTime.timeInSeconds > 0 {
                currentTime.timeInSeconds -= 1
                checkCountDownWarning()
            }
        }
    }

    @objc func increaseTimeByOneSecond() {
        if self.continueCounting == true {
            currentTime.timeInSeconds += 1
            checkCountUpWarning()
        } else if self.continueCounting == false {
            if currentTime.timeInSeconds < self.totalTime.timeInSeconds {
                currentTime.timeInSeconds += 1
                checkCountUpWarning()
            }
            if currentTime.timeInSeconds >= self.totalTime.timeInSeconds {
                setIsOutOfTime()
            }
        }
    }
    
    func checkCountDownWarning() {
        if currentTime.timeInSeconds <= warningTime.timeInSeconds {
            nc.post(name: Notification.Name.warningOn, object: self)
        }
        if currentTime.timeInSeconds > warningTime.timeInSeconds {
            nc.post(name:Notification.Name.warningOff, object: self)
        }
        if currentTime.timeInSeconds <= 0 {
            self.isOutOfTime = true
        }
    }
    
    func checkCountUpWarning() {
        if currentTime.timeInSeconds >= warningTime.timeInSeconds {
            nc.post(name: Notification.Name.warningOn, object: self)
        }
        if currentTime.timeInSeconds < warningTime.timeInSeconds {
            nc.post(name:Notification.Name.warningOff, object: self)
        }
        if currentTime.timeInSeconds >= totalTime.timeInSeconds {
            setIsOutOfTime()
        }
    }
    
    func stopTheClock() {
        guard isRunning == true else {
            return
        }
        timer.invalidate()
        isRunning = false
        nc.post(name:Notification.Name.timerStopped, object: self)
    }
    
    func resetTheClock() {
        guard isRunning == false else {
            stopTheClock()
            resetTheClock()
            self.isOutOfTime = false
            return
        }
        currentTime.timeInSeconds = totalTime.timeInSeconds
        nc.post(name: Notification.Name.timerReset, object: self)
    }
    
    func setIsOutOfTime() {
        self.isOutOfTime = true
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
