//
//  ParticipateController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/12/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ParticipateController: UIViewController,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    var meteorClient: MeteorClient!
    var expId = "7XMzsFoXSoHq8HnH3"
    
    
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var experienceDescLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func uploadPictureButtonTapped(sender: UIButton) {
        
    }
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        
        picker.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "meteorClientConnected", name: MeteorClientConnectionReadyNotification, object: nil)
        
        
    }
    
    @IBAction func shootPhotoButtonTapped(sender: UIButton) {
        
    }
    
    func meteorClientConnected() {
        let params: [AnyObject] = [["_id": expId]]
        meteorClient.callMethodName("getExperiences", parameters: params) { (response, error) -> Void in
            if let result = response {
                let experience = result["result"]![0] as! [String: AnyObject]
                self.experienceNameLabel.text = experience["name"] as! String
                self.experienceDescLabel.text = experience["description"] as! String
            }
        }
    }
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }
}
