//
//  TaskDetailViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TaskDetailViewControllerDelegate {
    func deleteCurrentTask()
//    func editCurrentTask()
}

class TaskDetailViewController: UIViewController {
    
    var delegate: TaskDetailViewControllerDelegate?
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
        // Do nothing. Segue does the rest.
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        self.delegate?.deleteCurrentTask()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass over the correct data for the correct segue.
        if segue.identifier == "editTask" {
            (segue.destinationViewController as! TaskEditController).editDelegate = (self.delegate as! TimesViewController)
            (segue.destinationViewController as! TaskEditController).editTaskObject = (self.delegate as! TimesViewController).currentTask
            (segue.destinationViewController as! TaskEditController).currentProjectObject = (self.delegate as! TimesViewController).currentTask.project
        }
        if segue.identifier == "newTime" {
            (segue.destinationViewController as! TimeEditController).currentTaskObject = (self.delegate as! TimesViewController).currentTask
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
