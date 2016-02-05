//
//  ViewController.swift
//  ce-app
//
//  Created by Kevin Chen on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ExperienceController: UIViewController {
    
    var meteorClient: MeteorClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

