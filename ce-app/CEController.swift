//
//  CEController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/7/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class CEController: UINavigationController {
    var meteorClient: MeteorClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "meteorClientConnected", name: MeteorClientConnectionReadyNotification, object: nil)
    }
    
    func meteorClientConnected() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let sessionToken = defaults.stringForKey("meteorSessionToken") {
            meteorClient.logonWithSessionToken(sessionToken) { (response, error) -> Void in
                if let _ = response {
                    print("Successfully reauthenticated with userId \(self.meteorClient.userId)")
                    
                    // This code is potentially dangerous?
                    let child = self.childViewControllers[0] as! ExperienceController
                    child.setupDataSources()
                } else {
                    self.performSegueWithIdentifier("signUpModal", sender: self)
                }
            }
        } else {
            performSegueWithIdentifier("signUpModal", sender: self)
        }
    }
}
