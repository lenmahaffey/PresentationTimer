//
//  displayViewController.swift
//  OSXDualScreen
//
//  Created by Len Mahaffey on 3/28/18.
//  Copyright © 2018 TLA Designs. All rights reserved.
//

import Cocoa

class displayViewController: NSViewController {
    
    @IBOutlet weak var timerDisplayText: NSTextField!
    @objc dynamic var countdownTimerController = presentationTimerController(timeLimit: 360, warningTime: 359)
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func countDown() {
        countdownTimerController.countDownWithoutWarning()
        self.showBorder()
    }
    
    func countUp() {
        countdownTimerController.countUpWithWarning()
    }
    
    func showBorder() {
        let warningBorder = warningView(frame: self.view.frame)
        self.view.addSubview(warningBorder)
        self.view.setNeedsDisplay(self.view.frame)
    }
    
    func hideBorder() {
        
    }
}
