//
//  ProfileSettingsController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ProfileSettingsController: UIViewController {

    var meteorClient: MeteorClient!
    
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var dogSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }
    
    
    @IBAction func submitProfileChanges(sender: UIButton) {
        let params: [AnyObject] = []
        meteorClient.callMethodName("updateUserProfile", parameters: params) {(response, error) -> Void in
            print(response["result"])
        }
    }
}
