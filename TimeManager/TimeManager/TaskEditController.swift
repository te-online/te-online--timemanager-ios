//
//  TaskEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TaskCreateDelegate {
    func saveNewTask(task: TaskEditController.Task)
}
protocol TaskEditDelegate {
    func editTask(task: TaskEditController.Task)
}

class TaskEditController: UIViewController {
    
    struct Task {
        var name: String!
        var object: TaskObject!
    }
    
    var currentTask: Task!
    var editTaskObject: TaskObject!
    var currentProjectObject: ProjectObject!
    var saveIntent = false
    
    var createDelegate: TaskCreateDelegate?
    var editDelegate: TaskEditDelegate?
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var ContextInfoLabel: UILabel!
    @IBOutlet weak var ModalTitleLabel: UILabel!
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTask = Task(name: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
        
        if self.editTaskObject != nil {
            // Put data into the fields.
            NameInputField.text = self.editTaskObject.name
            
            // Rename buttons.
            DoneButtonTop.setTitle("Update", forState: .Normal)
            DoneButtonBottom.setTitle("Update", forState: .Normal)
            
            // Change caption.
            ModalTitleLabel.text = "Edit task entry".uppercaseString
        }
        
        if self.currentProjectObject != nil {
            ContextInfoLabel.text = String(format: "%@ > %@", self.currentProjectObject.client!.name!, self.currentProjectObject!.name!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.saveIntent {
            // Store the input to make it accessible to the unwind segues target controller.
            self.currentTask.name = NameInputField.text!
            
            if self.editTaskObject != nil {
                self.currentTask.object = self.editTaskObject
                self.editDelegate?.editTask(self.currentTask)
            } else {
                self.createDelegate?.saveNewTask(self.currentTask)
            }
            
        }
        
        super.viewWillDisappear(animated)
    }
}
