//
//  displayTimer.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 4/9/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

var countdownTimerController = presentationTimerController(timeLimit: 3600, warningTime: 0)

extension Notification.Name {
    static let clockStarted = Notification.Name("clockStarted")
    static let warningOn = Notification.Name("warningOn")
    static let warningOff = Notification.Name("warningOff")
    static let outOfTime = Notification.Name("outOfTime")
    static let clockReset = Notification.Name("clockReset")
    static let showBorder = Notification.Name("showBorder")
    static let hideBorder = Notification.Name("hideBorder")
    static let setGreenBorder = Notification.Name("setGreenBorder")
    static let setYellowBorder = Notification.Name("setYellowBorder")
    static let setRedBorder = Notification.Name("setRedBorder")
    static let countUp = Notification.Name("countUp")
    static let countDown = Notification.Name("countDown")
    static let stopCounting = Notification.Name("stopCounting")
    static let continueCounting = Notification.Name("continueCounting")
}

class presentationTimerController: NSObject {
    @objc dynamic var timer: presentationTimer
    let nc = NotificationCenter.default
    
    init (timeLimit: Int, warningTime: Int){
        self.timer = presentationTimer(secondsToCount: timeLimit, warningTime: warningTime)
        super.init()
        nc.addObserver(self, selector: #selector(setContinueCounting), name: Notification.Name.continueCounting, object:nil)
        nc.addObserver(self, selector: #selector(setStopCounting), name: Notification.Name.stopCounting, object:nil)
        nc.addObserver(self, selector: #selector(setCountUp), name: Notification.Name.countUp, object:nil)
        nc.addObserver(self, selector: #selector(setCountDown), name: Notification.Name.countDown, object:nil)
    }
    
    @objc func setContinueCounting() {
        self.timer.continueCounting = true
    }
    
    @objc func setStopCounting() {
        self.timer.continueCounting = false
    }
    
    @objc func setCountDown() {
        self.timer.currentTime = self.timer.totalTime
    }
    
    @objc func setCountUp() {
        self.timer.currentTime.timeInSeconds = 0
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
    var isRunning: Bool
    var continueCounting: Bool
    var nc = NotificationCenter.default
    private var timer = Timer()
    
    init(secondsToCount: Int, warningTime: Int) {
        self.totalTime = time(timeToCountInSeconds: secondsToCount)
        self.currentTime = time(timeToCountInSeconds: secondsToCount)
        self.warningTime = time(timeToCountInSeconds: warningTime)
        self.isRunning = false
        self.continueCounting = false
    }

    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int, warningTime: time) {
        self.totalTime = time(hours: Int(hoursToCount), minutes: Int(minutesToCount), seconds: Int(secondsToCount))
        self.currentTime = totalTime
        self.warningTime = warningTime
        self.isRunning = false
        self.continueCounting = false
    }
    
    func countDown() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(decreaseTimeByOneSecond), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    func countUp() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(increaseTimeByOneSecond), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    @objc func decreaseTimeByOneSecond() {
        guard self.continueCounting == true else {
            guard currentTime.timeInSeconds > 0 else {
                stopTheClock()
                nc.post(name: Notification.Name.outOfTime, object: self)
                return
            }
            currentTime.timeInSeconds -= 1
            warn()
            return
        }
        currentTime.timeInSeconds -= 1
        warn()
    }

    @objc func increaseTimeByOneSecond() {
        guard self.continueCounting == true else {
            if currentTime.timeInSeconds > self.totalTime.timeInSeconds {
                currentTime.timeInSeconds += 1
                warn()
            }
            if currentTime.timeInSeconds == self.totalTime.timeInSeconds {
                stopTheClock()
                nc.post(name:Notification.Name.outOfTime, object: self)
            }
            return
        }
        currentTime.timeInSeconds += 1
        warn()
    }
    
    func warn() {
        if currentTime.timeInSeconds <= warningTime.timeInSeconds {
            nc.post(name: Notification.Name.warningOn, object: self)
        }
        if currentTime.timeInSeconds >= warningTime.timeInSeconds {
            nc.post(name:Notification.Name.warningOff, object: self)
        }
        if currentTime.timeInSeconds < 0 {
            nc.post(name:Notification.Name.outOfTime, object: self)
        }
    }
    
    func stopTheClock() {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTheClock() {
        if isRunning == true {
            timer.invalidate()
            isRunning = false
        }
        currentTime.timeInSeconds = totalTime.timeInSeconds
        nc.post(name: Notification.Name.clockReset, object: self)
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
