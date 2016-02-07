//
//  SignUpViewController
//  ce-app
//
//  Created by Shannon Nachreiner on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//
import UIKit

class SignUpViewController: UIViewController {

    var meteorClient: MeteorClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        if let mClient = meteorClient {
            print(mClient)
        }
        
        meteorClient.signupWithEmail(emailTextField.text, password: passwordTextField.text, fullname: "") { (response, error) -> Void in
            if let result = response {
                let userInfo = result["result"] as! [String: AnyObject]
                let tokenExpiration = userInfo["tokenExpires"] as! [String: Int]
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(userInfo["id"] as! String, forKey: "meteorId")
                defaults.setObject(userInfo["token"] as! String, forKey: "meteorSessionToken")
                defaults.setObject(tokenExpiration["$date"], forKey: "meteorSessionTokenExpiration")
            }
            
        }        
    }
}
