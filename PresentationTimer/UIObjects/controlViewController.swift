//
//  ViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class controlViewController: NSViewController {
    
    @IBOutlet weak var countDown: NSButton!
    var displayWindowControl: displayWindowController? = nil
    var displayViewControl: displayViewController? = nil
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(monitorDidChange),
            name:  NSApplication.didChangeScreenParametersNotification,
            object: nil)
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let storyboardSceneID = NSStoryboard.SceneIdentifier(rawValue: "displayWindowController")
        displayWindowControl = (storyboard.instantiateController(withIdentifier: storyboardSceneID) as! displayWindowController)
    }
    
    override func viewWillAppear() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSScreen.screens.count == 1 {
            displayWindowControl?.window?.close()
        }
        if NSScreen.screens.count > 1 {
            displayWindowControl?.showWindowOnExtendedDesktop()
        }
    }

    @objc func monitorDidChange(notification: NSNotification) {
        if NSScreen.screens.count == 1 {
            //print("there is one monitor")
            displayWindowControl?.window?.close()
        }
        if NSScreen.screens.count > 1 {
            //print("there are two monitors")
            displayWindowControl?.showWindowOnExtendedDesktop()
        }
    }
    @IBAction func countDownButtonPress(_ sender: Any) {
        displayWindowControl?.countDown()
    }
}

