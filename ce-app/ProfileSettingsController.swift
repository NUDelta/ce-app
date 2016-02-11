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
        
        let params: [AnyObject] = [["_id": meteorClient.userId]]
        meteorClient.callMethodName("getUsers", parameters: params) { (response, error) -> Void in
            if let result = response {
                let user = result["result"]![0] as! [String: AnyObject] // because this is array
                let profile = user["profile"] as! [String: AnyObject]
                let qualifications = profile["qualifications"] as! [String: Bool]
                self.cameraSwitch.setOn(qualifications["hasCamera"]!, animated: false)
                self.dogSwitch.setOn(qualifications["hasDog"]!, animated: false)
            }
        }
    }
    
    
    @IBAction func submitProfileChanges(sender: UIButton) {
        /*
        
        params[0] = ["_id": meteorClient.userId]
        params[1] = ["$set": ["profile.qualifications.hasCamera": cameraSwitch.on]]
        
        server => Meteor.users.find(params[0], params[1])
                                    {_id: meteorClient.userId},
                                    {$set: { 'profile.qualifications.hasCamera': cameraSwitch.on }

        */
        var params: [AnyObject] = []
        let query: [String: String] = ["_id": meteorClient.userId]
        params.append(query)
        let update = ["$set": ["profile.qualifications.hasCamera": cameraSwitch.on, "profile.qualifications.hasDog": dogSwitch.on]]
        params.append(update)
            
        meteorClient.callMethodName("/users/update", parameters: params) { (response, error) -> Void in
            if let _ = response {
                self.meteorClient.callMethodName("updateUserExperiences", parameters: [self.meteorClient.userId], responseCallback: { (response, error) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else if let err = error{
                print(err)
            }
        }
    }
}
