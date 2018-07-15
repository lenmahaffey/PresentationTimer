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
    
    }
}

class presentationTimer: NSObject {
    @objc dynamic var totalTime: time
    @objc dynamic var currentTime: time
    @objc dynamic var warningTime: time
    /*@objc dynamic var currentDateTime: String {
        let currentDate = Date()
        let calendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let currentComponents =  calendar.dateComponents(requestedComponents, from: currentDate)
        let formatter = DateFormatter()
        //return formatter.string(from: currentComponents)
    }*/
    var isRunning: Bool
    var nc = NotificationCenter.default
    private var timer = Timer()
    
    init(secondsToCount: Int, warningTime: Int) {
        self.totalTime = time(timeToCountInSeconds: secondsToCount)
        self.currentTime = totalTime
        self.warningTime = time(timeToCountInSeconds: warningTime)
        isRunning = false
    }
    
    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int, warningTime: time) {
        self.totalTime = time(hours: hoursToCount, minutes: minutesToCount, seconds: secondsToCount)
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
            print(currentTime.totalTimeAsString)
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
            print(currentTime.totalTimeAsString)
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
            return (timeInSeconds - (self.hours * 3600)) / 60
        }
    }
    
    @objc dynamic var seconds: Int {
        get {
            return (timeInSeconds - (self.hours * 3600 ) - (self.minutes * 60))
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
        self.timeInSeconds = (hours * 3600) + (minutes * 60) + (seconds * 60)
    }

}
