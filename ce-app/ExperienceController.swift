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
    var subscribedTo: [String]!
    var experiences: [Experience]!
    
    var alertControllerPresenting: Bool = false // messy...

    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        alertController = UIAlertController(title: "Connecting...", message: "Waiting to connect to server", preferredStyle: .Alert)
        subscribedTo = [String]()
        experiences = [Experience]()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDisconnect", name: MeteorClientDidDisconnectNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (meteorClient.userId != nil) {
            if !meteorClient.connected {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "isReady", name: MeteorClientConnectionReadyNotification, object: nil)
                if !alertControllerPresenting {
                    alertControllerPresenting = true
                    presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                setupDataSources()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Connection event listeners
    func isReady() {
        print("***************** Connected to Meteor Server *****************")
        dismissViewControllerAnimated(true) { () -> Void in
            self.alertControllerPresenting = true
            self.setupDataSources()
        }
    }
    
    func didDisconnect() {
        print("***************** Disconnected from Meteor Server *****************")
        if !alertControllerPresenting {
            alertControllerPresenting = true
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Server data access
    func getSubscribedExperiences() {
        let params: [AnyObject] = [["_id": meteorClient.userId]]
        meteorClient.callMethodName("getSubscriptions", parameters: params) { (response, error) -> Void in
            if let result = response {
                let user = result["result"] as! [String: AnyObject]
                let profile = user["profile"] as! [String: AnyObject]
                self.subscribedTo = profile["subscriptions"] as! [String]
            }
        }
    }
    
    func setupDataSources() {
        getSubscribedExperiences()
        
        let params: [AnyObject] = [["_id": meteorClient.userId]]
        meteorClient.callMethodName("getUsers", parameters: params) { (response, error) -> Void in
            if let result = response {
                let user = result["result"]![0] as! [String: AnyObject] // because this is array
                let profile = user["profile"] as! [String: AnyObject]
                let experiences = profile["experiences"] as! [String]
                
                let query = ["_id": ["$in": experiences]]
                let params = [query]
                
                self.meteorClient.callMethodName("getExperiences", parameters: params) { (response, error) -> Void in
                    // load experiences here.
                    if let experiences = response["result"] as? [[String:AnyObject]] {
                        self.experiences = experiences.map { (experience) -> Experience in
                            return Experience(id: experience["_id"] as! String, name: experience["name"] as! String, author: experience["author"] as! String, description: experience["description"] as! String, startEmailText: experience["startEmailText"] as! String, modules: experience["modules"] as! [String], requirements: experience["requirements"] as! [String])
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: TableView delegate method
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ExperienceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExperienceTableViewCell
        let experience = experiences[indexPath.row]
        cell.titleLabel.text = experience.name
        cell.descriptionLabel.text = experience.description
        
        // might encounter race conditions
        if (subscribedTo.contains(experience.id)) {
            cell.isSubscribedCheckmark.hidden = false
        } else {
            cell.isSubscribedCheckmark.hidden = true
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let experience = experiences[indexPath.row]
        if (subscribedTo.contains(experience.id)) {
            subscribedTo = subscribedTo.filter() { $0 != experience.id }
        } else {
            subscribedTo.append(experience.id)
        }
        tableView.reloadData()
        
        let params = [["_id": meteorClient.userId], ["$set": ["profile.subscriptions": subscribedTo]]]
        meteorClient.callMethodName("/users/update", parameters: params) { (response, error) -> Void in
            print(response)
//            print(error)
        }
    }
    
    // MARK: UI Interactions
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        meteorClient.logout()
        // Probably should have this post a notification to for the navigation controller to intercept?
        self.parentViewController?.performSegueWithIdentifier("signUpModal", sender: parentViewController!)
    }
    
}

