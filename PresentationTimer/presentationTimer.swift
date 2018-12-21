//
//  displayTimer.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 4/9/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let warn = Notification.Name("warn")
}

class presentationTimerController: NSObject {
    @objc dynamic var timer: presentationTimer
    
    init (timeLimit: Int, warningTime: Int){
        self.timer = presentationTimer(secondsToCount: timeLimit, warningTime: warningTime)
    }
    
    func setTime(timeLimit: time) {
        self.timer.totalTime.timeInSeconds = timeLimit.timeInSeconds
        self.timer.currentTime.timeInSeconds = timeLimit.timeInSeconds
        //self.timer.warningTime = time(timeToCountInSeconds: warningTime)
    }
    
    func countDown() {
        self.timer.countDown()
    }

    func countUp() {
        self.timer.countUp()
    }
    
    func countDownComplete () {
    
    }
    
    func warn () {
        
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

    func countDown() {
        if isRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(reduceTimeByOneSecond), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    func countUp() {
        if isRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(addOneSecond), userInfo: nil, repeats: true)
            timer.fire()
            isRunning = true
        }
    }
    
    @objc func reduceTimeByOneSecond() {
        if currentTime.timeInSeconds > 0 {
            currentTime.timeInSeconds -= 1
            print(currentTime.totalTimeAsString, "/", totalTime.totalTimeAsString)
        } else {
            stopTheClock()
        }
        if currentTime == warningTime {
            nc.post(name: Notification.Name.warn, object: self)
        }
    }
    
    @objc func addOneSecond() {
        if currentTime.timeInSeconds < totalTime.timeInSeconds {
            currentTime.timeInSeconds += 1
            print(currentTime.totalTimeAsString, "/", totalTime.totalTimeAsString)
        } else {
            stopTheClock()
        }
        if currentTime == warningTime {
            nc.post(name: Notification.Name.warn, object: self)
        }
    }
    
    func stopTheClock() {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTheClock() {
        if isRunning == true {
            timer.invalidate()
            currentTime.timeInSeconds = totalTime.timeInSeconds
            isRunning = false
            return
        }
        currentTime.timeInSeconds = totalTime.timeInSeconds
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
