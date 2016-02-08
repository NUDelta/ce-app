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
                print("")
            }
            // TODO: handle error case?
        } else {
            performSegueWithIdentifier("signUpModal", sender: self)
        }
    }
}
