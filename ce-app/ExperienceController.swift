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
    var experiences: [Experience]!

    override func viewDidLoad() {
        super.viewDidLoad()
        meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
        experiences = [Experience]()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (meteorClient.userId != nil) {
            if !meteorClient.connected {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "isConnected", name: MeteorClientDidConnectNotification, object: nil)
                alertController = UIAlertController(title: "Connecting...", message: "Waiting to connect to server", preferredStyle: .Alert)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                setupDataSources()
            }
        }
    }
    
    func isConnected() {
        print("***************** Connected to Meteor Server *****************")
        dismissViewControllerAnimated(true) { () -> Void in
            self.setupDataSources()
        }
    }
    
    func setupDataSources() {
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
                            return Experience(name: experience["name"] as! String, author: experience["author"] as! String, description: experience["description"] as! String, startEmailText: experience["startEmailText"] as! String, modules: experience["modules"] as! [String], requirements: experience["requirements"] as! [String])
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        return cell
    }
}

