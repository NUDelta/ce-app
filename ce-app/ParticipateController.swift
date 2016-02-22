//
//  ParticipateController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/12/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ParticipateController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    var meteorClient: MeteorClient!
    var expId: String = "7XMzsFoXSoHq8HnH3"
    
    
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var experienceDescLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        picker.delegate = self
        
        let params: [AnyObject] = [["_id": expId]]
        meteorClient.callMethodName("getExperiences", parameters: params) { (response, error) -> Void in
            if let result = response {
                let experience = result["result"]![0] as! [String: AnyObject]
                self.experienceNameLabel.text = experience["name"] as? String
                self.experienceDescLabel.text = experience["description"]as? String
            }
        }
    }
    
    let picker = UIImagePickerController()
    
    @IBAction func choosePhotoFromLibraryButtonTapped(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
            animated: true,
            completion: nil)
    }
    
    func uploadSucceeded(){
        let alertVC = UIAlertController(
            title: "Upload success",
            message: "We got your pic!",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
            animated: true,
            completion: nil)
    }
    
    @IBAction func shootPhotoButtonTapped(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func submitPhotoButtonTapped(sender: UIButton) {
        let imageData = UIImagePNGRepresentation(imageView.image!)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let params: [AnyObject] = [expId, base64String]
        
        meteorClient.callMethodName("insertPhoto", parameters: params) { (response, error) -> Void in
            if let err = error {
                print(err);
            } else {
                self.uploadSucceeded();
            }
            
            if let result = response {
                print((result["result"] as! String) == base64String)
            }
        }
    }
    
    
    // MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .ScaleAspectFit //3
        imageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
