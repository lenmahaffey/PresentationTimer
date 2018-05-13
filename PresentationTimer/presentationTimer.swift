//
//  displayTimer.swift
//  PresentationTimer
//
//  Created by Len Mahaffey on 4/9/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class presentationTimer: NSObject {
    @objc dynamic var totalTime: time
    @objc dynamic var displayTime: time
    private var timer = Timer()
    
    init(secondsToCount: Int) {
        totalTime = time(timeToCountInSeconds: secondsToCount)
        displayTime = totalTime
    }
    
    init(hoursToCount: Int, minutesToCount: Int, secondsToCount: Int) {
        totalTime = time(hours: hoursToCount, minutes: minutesToCount, seconds: secondsToCount)
        displayTime = totalTime
    }
    
    func countDown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(reduceTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func countUp() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(addTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func reduceTime() {
        displayTime.timeInSeconds -= 1
        print(displayTime.timeInSeconds, displayTime.totalTimeAsString)
    }
    
    @objc func addTime() {
        displayTime.timeInSeconds += 1
    }
    
    func showSystemTime() {
        
    }
}

class time: NSObject {
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
    
    init(timeToCountInSeconds: Int) {
        self.timeInSeconds = timeToCountInSeconds
    }
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.timeInSeconds = (hours * 3600) + (minutes * 60) + (seconds * 60)
    }
}
