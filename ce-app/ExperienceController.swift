//
//  ViewController.swift
//  ce-app
//
//  Created by Kevin Chen on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ExperienceController: UITableViewController {
    
    var meteorClient: MeteorClient!
    var alertController: UIAlertController!
    var experiences: [Experience]!

    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        experiences = [Experience]()
    }
    
    override func viewDidAppear(animated: Bool) {
        if !meteorClient.connected {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "isConnected", name: MeteorClientDidConnectNotification, object: nil)
            alertController = UIAlertController(title: "Connecting...", message: "Waiting to connect to server", preferredStyle: .Alert)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            setupDataSources()
        }
    }
    
    func isConnected() {
        print("***************** Connected to Meteor Server *****************")
        dismissViewControllerAnimated(true) { () -> Void in
            self.setupDataSources()
        }
    }
    
    func setupDataSources() {
        let params: [AnyObject] = []
        meteorClient.callMethodName("getExperiences", parameters: params) { (result, error) -> Void in
            // load experiences here.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

