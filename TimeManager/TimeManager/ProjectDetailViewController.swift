//
//  ProjectDetailViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ProjectDetailViewControllerDelegate {
    func deleteCurrentProject()
//    func editCurrentProject()
}

class ProjectDetailViewController: UIViewController {
    
    let Colors = SharedColorPalette.sharedInstance
    
    var delegate: ProjectDetailViewControllerDelegate?
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
        // Do nothing. Segue does the rest.
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        self.delegate?.deleteCurrentProject()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass over the correct data for the correct segue.
        if segue.identifier == "editProject" {
            (segue.destinationViewController as! ProjectEditController).editDelegate = (self.delegate as! TasksViewController)
            (segue.destinationViewController as! ProjectEditController).editProjectObject = (self.delegate as! TasksViewController).currentProject
            (segue.destinationViewController as! ProjectEditController).currentClientObject = (self.delegate as! TasksViewController).currentProject.client
        }
        if segue.identifier == "newTask" {
            (segue.destinationViewController as! TaskEditController).currentProjectObject = (self.delegate as! TasksViewController).currentProject
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.TasksCellGreen
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
