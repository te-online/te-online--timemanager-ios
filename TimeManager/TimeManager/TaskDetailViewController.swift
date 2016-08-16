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
    func editCurrentTask()
}

class TaskDetailViewController: UIViewController {
    
    var delegate: TaskDetailViewControllerDelegate?
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
        self.delegate?.editCurrentTask()
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        self.delegate?.deleteCurrentTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
