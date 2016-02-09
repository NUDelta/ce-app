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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        meteorClient.signupWithEmail(emailTextField.text, password: passwordTextField.text, fullname: "", responseCallback: authCallback)
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        meteorClient.logonWithEmail(emailTextField.text, password: passwordTextField.text, responseCallback: authCallback)
    }
    
    func authCallback(response:[NSObject: AnyObject]!, error: NSError!) {
        if let result = response {
            let userInfo = result["result"] as! [String: AnyObject]
            let tokenExpiration = userInfo["tokenExpires"] as! [String: Int]
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(userInfo["id"] as! String, forKey: "meteorId")
            defaults.setObject(userInfo["token"] as! String, forKey: "meteorSessionToken")
            defaults.setObject(tokenExpiration["$date"], forKey: "meteorSessionTokenExpiration")
            
            self.performSegueWithIdentifier("profileSettings", sender: self)
        } else {
            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
