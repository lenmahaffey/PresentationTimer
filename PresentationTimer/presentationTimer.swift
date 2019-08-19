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
    static let warn = Notification.Name("warn")
    static let outOfTime = Notification.Name("outOfTime")
    static let clockReset = Notification.Name("clockReset")
    static let showBorder = Notification.Name("showBorder")
    static let hideBorder = Notification.Name("hideBorder")
    static let setGreenBorder = Notification.Name("setGreenBorder")
    static let setYellowBorder = Notification.Name("setYellowBorder")
    static let setRedBorder = Notification.Name("setRedBorder")
}

class presentationTimerController: NSObject {
    @objc dynamic var timer: presentationTimer
    
    init (timeLimit: Int, warningTime: Int){
        self.timer = presentationTimer(secondsToCount: timeLimit, warningTime: warningTime)
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
    
    func countDownAndContinue() {
        self.timer.countDownAndContinue()
    }
    
    func countDownAndStop() {
        self.timer.countDownAndStop()
    }
    
    func countUpAndContinue() {
        self.timer.countUpAndContinue()
    }
    
    func countUpAndStop() {
        self.timer.countUpAndStop()
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
    var nc = NotificationCenter.default
    private var timer = Timer()
    
    init(secondsToCount: Int, warningTime: Int) {
        self.totalTime = time(timeToCountInSeconds: secondsToCount)
        self.currentTime = time(timeToCountInSeconds: secondsToCount)
        self.warningTime = time(timeToCountInSeconds: warningTime)
        isRunning = false
    }

    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int, warningTime: time) {
        self.totalTime = time(hours: Int(hoursToCount), minutes: Int(minutesToCount), seconds: Int(secondsToCount))
        self.currentTime = totalTime
        self.warningTime = warningTime
        self.isRunning = false
    }
    
    func countDownAndContinue() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(decreaseTimeByOneSecondAndContinue), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }

    func countDownAndStop() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(decreaseTimeByOneSecondAndStop), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    func countUpAndContinue() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(increaseTimeByOneSecondAndContinue), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    func countUpAndStop() {
        if isRunning == false {
            nc.post(name: Notification.Name.clockStarted, object: self)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(increaseTimeByOneSecondAndStop), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    @objc func decreaseTimeByOneSecondAndContinue() {
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds -= 1
            if currentTime.timeInSeconds <= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warn, object: self)
            }
            if currentTime.timeInSeconds >= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.clockStarted, object: self)
            }
        }
    }
    
    @objc func decreaseTimeByOneSecondAndStop() {
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds -= 1
            if currentTime.timeInSeconds <= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warn, object: self)
            }
            if currentTime.timeInSeconds >= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.clockStarted, object: self)
            }
        }
        if currentTime.timeInSeconds == 0 {
            stopTheClock()
            nc.post(name: Notification.Name.outOfTime, object: self)
        }
    }
    
    @objc func increaseTimeByOneSecondAndContinue() {
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds += 1
            if currentTime.timeInSeconds <= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warn, object: self)
            }
            if currentTime.timeInSeconds >= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.clockStarted, object: self)
            }
        }
    }
    
    @objc func increaseTimeByOneSecondAndStop() {
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds += 1
            if currentTime.timeInSeconds <= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.warn, object: self)
            }
            if currentTime.timeInSeconds >= warningTime.timeInSeconds {
                nc.post(name: Notification.Name.clockStarted, object: self)
            }
        }
        if currentTime.timeInSeconds == 0 {
            stopTheClock()
            nc.post(name: Notification.Name.outOfTime, object: self)
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
            return timeInSeconds / 3600
        }
    }
    
    @objc dynamic var minutes: Int {
        get {
            let totalMinutes = timeInSeconds / 60
            if totalMinutes > 59 {
                return totalMinutes % 60
            }
            return totalMinutes
        }
    }
    
    @objc dynamic var seconds: Int {
        get {
            if timeInSeconds > 59 {
                return timeInSeconds % 60
            }
            return timeInSeconds
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
