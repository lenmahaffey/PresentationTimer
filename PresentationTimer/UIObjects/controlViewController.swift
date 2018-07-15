//
//  ViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewController: NSViewController {
    
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var repeatButton: NSButton!
    @IBOutlet weak var totalTimeHoursEntryField: NSTextField!
    @IBOutlet weak var totalTimeMinutesEntryField: NSTextField!
    @IBOutlet weak var totalTimeSecondsEntryField: NSTextField!
    @IBOutlet weak var wrapUpTimeHoursEntryField: NSTextField!
    @IBOutlet weak var wrapUpTimeMinutesEntryField: NSTextField!
    @IBOutlet weak var wrapUpTimeSecondsEntryField: NSTextField!
    @objc dynamic var displayWindowControl: displayWindowController? = nil
    @objc dynamic var displayViewControl: displayViewController? = nil
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        //Add notification observer to watch for screen changes.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(monitorDidChange),
            name:  NSApplication.didChangeScreenParametersNotification,
            object: nil)
        //Instantiate display controllers directly
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let displayWindowControllerSceneID = NSStoryboard.SceneIdentifier(rawValue: "displayWindowController")
        let displayViewControllerSceneID = NSStoryboard.SceneIdentifier(rawValue: "displayViewController")
        displayViewControl = (storyboard.instantiateController(withIdentifier: displayViewControllerSceneID) as! displayViewController)
        displayWindowControl = (storyboard.instantiateController(withIdentifier: displayWindowControllerSceneID) as! displayWindowController)
    }
    
    override func viewWillAppear() {
        
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
    
    @IBAction func startButtonPress(_ sender: Any) {
        displayViewControl?.countDown()
    }
    

    @IBAction func repeatButtonPress(_ sender: Any) {
        
    }
}

