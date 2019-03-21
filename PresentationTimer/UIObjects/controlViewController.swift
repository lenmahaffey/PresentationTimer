//
//  ViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var repeatButton: NSButton!
    @IBOutlet weak var totalTimeHoursEntryField: controlViewTextField?
    @IBOutlet weak var totalTimeMinutesEntryField: controlViewTextField?
    @IBOutlet weak var totalTimeSecondsEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeHoursEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeMinutesEntryField: controlViewTextField?
    @IBOutlet weak var wrapUpTimeSecondsEntryField: controlViewTextField?
    @objc dynamic var displayWindowControl: displayWindowController? = nil
    @objc dynamic var displayViewControl: displayViewController? = nil
    @objc dynamic var timerController = countdownTimerController
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        //Add notification observer to watch for screen changes.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(monitorDidChange),
            name:  NSApplication.didChangeScreenParametersNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpTime),
            name: NSText.didEndEditingNotification,
            object: nil)
        //Instantiate display controllers directly
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let displayWindowControllerSceneID = NSStoryboard.SceneIdentifier(rawValue: "displayWindowController")
        let displayViewControllerSceneID = NSStoryboard.SceneIdentifier(rawValue: "displayViewController")
        displayViewControl = (storyboard.instantiateController(withIdentifier: displayViewControllerSceneID) as! displayViewController)
        displayWindowControl = (storyboard.instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    override func viewWillAppear() {
        super .viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If only one screen then close the displayWindow
        if NSScreen.screens.count == 1 {
            displayWindowControl?.window?.close()
        }
        //If more than one screen is detected then show the displayWindow
        if NSScreen.screens.count > 1 {
            displayWindowControl?.showWindowOnExtendedDesktop()
        }
    }
    
    //Function called when a change to screens is observed by notification
    //closes displayWindow if only one screen, shows displayWindow if more than one
    @objc func monitorDidChange(notification: NSNotification) {
        if NSScreen.screens.count == 1 {
            displayWindowControl?.window?.close()
        }
        if NSScreen.screens.count > 1 {
            displayWindowControl?.showWindowOnExtendedDesktop()
        }
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        print ("done editing")
    }
    
    @IBAction func startButtonPress(_ sender: Any) {
        displayViewControl?.countDown()
    }
    
    @IBAction func stopButtonPress(_ sender: Any) {
        displayViewControl?.stopTheClock()
    }
    
    @IBAction func repeatButtonPress(_ sender: Any) {
        displayViewControl?.resetTheClock()
    }
    
    @objc func setUpTime(notification: Notification) {
        let totalHours = self.totalTimeHoursEntryField?.intValue ?? 0
        let totalMinutes = self.totalTimeMinutesEntryField?.intValue ?? 0
        let totalSeconds = self.totalTimeSecondsEntryField?.intValue ?? 0

        if Int(totalSeconds) > 59 {
            let newSeconds = Int(totalSeconds) - 60
            let newMinutes = Int(totalMinutes) + 1
            self.totalTimeSecondsEntryField?.stringValue = String(describing: newSeconds)
            self.totalTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            setUpTime(notification: notification)
        }
        if Int(totalMinutes) > 59 {
            let newMinutes = Int(totalMinutes) - 60
            let newHours = Int(totalHours) + 1
            self.totalTimeMinutesEntryField?.stringValue = String(describing: newMinutes)
            self.totalTimeHoursEntryField?.stringValue = String(describing: newHours)
            setUpTime(notification: notification)
        }
        let timerTotal = time(hours: (Int(self.totalTimeHoursEntryField?.intValue ?? 0)),
                              minutes: (Int(self.totalTimeMinutesEntryField?.intValue ?? 0)),
                              seconds: (Int(self.totalTimeSecondsEntryField?.intValue ?? 0)))
        displayViewControl?.countdownTimerController.setTime(timeLimit: timerTotal)
    }
    
}

