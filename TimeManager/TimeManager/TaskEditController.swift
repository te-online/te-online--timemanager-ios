//
//  TaskEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TaskEditDelegate {
    func saveNewTask(task: TaskEditController.Task)
}

class TaskEditController: UIViewController {
    
    struct Task {
        var name: String!
    }
    
    var currentTask: Task!
    
    var delegate: TaskEditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTask = Task(name: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Store the input to make it accessible to the unwind segues target controller.
        self.currentTask.name = (self.view.viewWithTag(4) as! UITextField).text!
        
        self.delegate?.saveNewTask(self.currentTask)
        
        super.viewWillDisappear(animated)
    }
}
