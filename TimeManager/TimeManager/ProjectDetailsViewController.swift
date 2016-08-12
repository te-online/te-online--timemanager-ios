//
//  ProjectDetailsViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
        NSLog("Project would be edited now")
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        NSLog("Project would be deleted now")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}