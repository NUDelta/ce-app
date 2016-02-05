//
//  LoginViewController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {

    var meteorClient: MeteorClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        meteorClient.signupWithEmail(emailTextField.text, password:passwordTextField.text, fullname:"Shannon", responseCallback: nil)
    }
}
