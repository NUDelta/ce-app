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
    
    override func viewWillAppear(animated: Bool) {
        if (meteorClient.userId != nil) {
            dismissViewControllerAnimated(false, completion: nil)
        }
        super.viewWillAppear(animated)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        meteorClient.signupWithEmail(emailTextField.text, password: passwordTextField.text, fullname: "") { (response, error) -> Void in
            if (self.authCallback(response, error: error)) {
                self.performSegueWithIdentifier("profileSettings", sender: self)
            }
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        meteorClient.logonWithEmail(emailTextField.text, password: passwordTextField.text) { (response, error) -> Void in
            if (self.authCallback(response, error: error)) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func authCallback(response:[NSObject: AnyObject]!, error: NSError!) -> Bool {
        if let result = response {
            let userInfo = result["result"] as! [String: AnyObject]
            let tokenExpiration = userInfo["tokenExpires"] as! [String: Int]
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(userInfo["id"] as! String, forKey: "meteorId")
            defaults.setObject(userInfo["token"] as! String, forKey: "meteorSessionToken")
            defaults.setObject(tokenExpiration["$date"], forKey: "meteorSessionTokenExpiration")
            return true
        } else {
            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
    }
}
